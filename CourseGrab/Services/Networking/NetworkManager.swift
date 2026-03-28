//
//  NetworkManager.swift
//  CourseGrab
//
//  Created by jiwon jeong on 3/27/26.
//

import Foundation
import OSLog

class NetworkManager: APIClient {

    // MARK: - Singleton

    static let shared = NetworkManager()

    // MARK: - Properties

    private let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier ?? "com.cornellappdev.coursegrab",
        category: "Network"
    )

    private let jsonEncoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        return encoder
    }()

    private let jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()

    private let baseURL = "https://\(CourseGrabEnvironment.serverHost)/api"

    // MARK: - Init

    private init() {}

    // MARK: - URL Construction

    func constructURL(endpoint: String) throws -> URL {
        let path = endpoint.hasPrefix("/") ? endpoint : "/\(endpoint)"
        guard let url = URL(string: baseURL + path) else {
            logger.error("Failed to construct URL for endpoint: \(endpoint)")
            throw URLError(.badURL)
        }
        return url
    }

    // MARK: - APIClient

    func get<T: Decodable>(url: URL, attempt: Int = 1) async throws -> T {
        let request = try createRequest(url: url, method: "GET")
        let (data, response) = try await URLSession.shared.data(for: request)
        try handleResponse(data: data, response: response)
        return try jsonDecoder.decode(T.self, from: data)
    }

    func post<T: Decodable, U: Encodable>(url: URL, body: U, attempt: Int = 1) async throws -> T {
        let requestData = try jsonEncoder.encode(body)
        let request = try createRequest(url: url, method: "POST", body: requestData)
        let (data, response) = try await URLSession.shared.data(for: request)
        try handleResponse(data: data, response: response)
        return try jsonDecoder.decode(T.self, from: data)
    }

    func post<U: Encodable>(url: URL, body: U, attempt: Int = 1) async throws {
        let requestData = try jsonEncoder.encode(body)
        let request = try createRequest(url: url, method: "POST", body: requestData)
        let (data, response) = try await URLSession.shared.data(for: request)
        try handleResponse(data: data, response: response)
    }

    func post<T: Decodable>(url: URL, attempt: Int = 1) async throws -> T {
        let request = try createRequest(url: url, method: "POST")
        let (data, response) = try await URLSession.shared.data(for: request)
        try handleResponse(data: data, response: response)
        return try jsonDecoder.decode(T.self, from: data)
    }

    func delete(url: URL, attempt: Int = 1) async throws {
        let request = try createRequest(url: url, method: "DELETE")
        let (data, response) = try await URLSession.shared.data(for: request)
        try handleResponse(data: data, response: response)
    }

    // MARK: - CourseGrab Endpoints

    func getAllTrackedSections() async throws -> [CourseSection] {
        let url = try constructURL(endpoint: "/users/tracking/")
        let response: Response<Sections> = try await get(url: url)
        return response.data.sections
    }

    func trackSection(catalogNum: Int) async throws -> CourseSection {
        let url = try constructURL(endpoint: "/sections/track/")
        let body = CoursePostBody(courseId: catalogNum)
        let response: Response<CourseSection> = try await post(url: url, body: body)
        return response.data
    }

    func untrackSection(catalogNum: Int) async throws -> CourseSection {
        let url = try constructURL(endpoint: "/sections/untrack/")
        let body = CoursePostBody(courseId: catalogNum)
        let response: Response<CourseSection> = try await post(url: url, body: body)
        return response.data
    }

    func searchCourse(query: String) async throws -> [Course] {
        let url = try constructURL(endpoint: "/courses/search/")
        let body = QueryBody(query: query)
        let response: Response<CourseSearch> = try await post(url: url, body: body)
        return response.data.courses
    }

    func getSection(catalogNum: Int) async throws -> CourseSection {
        let url = try constructURL(endpoint: "/sections/\(catalogNum)/")
        let response: Response<CourseSection> = try await get(url: url)
        return response.data
    }

    func getCourse(courseNum: Int) async throws -> Course {
        let url = try constructURL(endpoint: "/courses/\(courseNum)/")
        let response: Response<Course> = try await get(url: url)
        return response.data
    }

    func enableNotifications(enabled: Bool) async throws {
        let url = try constructURL(endpoint: "/users/notification/")
        let body = EnableNotificationsBody(notification: enabled ? "IOS" : "NONE")
        try await post(url: url, body: body)
    }

    func sendDeviceToken(deviceToken: String) async throws {
        let url = try constructURL(endpoint: "/users/device-token/")
        let body = DeviceTokenBody(deviceToken: deviceToken)
        try await post(url: url, body: body)
    }
    
    func initializeSession(googleToken: String) async throws -> SessionAuthorization {
        let url = try constructURL(endpoint: "/session/initialize/")
        let deviceToken = UserSessionManager.shared.deviceToken
        let body = SessionBody(
            deviceToken: deviceToken.isEmpty ? nil : deviceToken,
            deviceType: "IOS",
            token: googleToken
        )
        let response: Response<SessionAuthorization> = try await post(url: url, body: body)
        return response.data
    }

    func updateSession() async throws -> SessionAuthorization {
        let url = try constructURL(endpoint: "/session/update/")
        let response: Response<SessionAuthorization> = try await post(url: url)
        return response.data
    }

    // MARK: - Private Helpers
    
    private func createRequest(url: URL, method: String, body: Data? = nil, useUpdateToken: Bool = false) throws -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        if useUpdateToken, let token = UserSessionManager.shared.updateToken {
            request.setValue(token, forHTTPHeaderField: "Authorization")
        } else if let token = UserSessionManager.shared.sessionToken {
            request.setValue(token, forHTTPHeaderField: "Authorization")
        }
        request.httpBody = body
        return request
    }

    private func handleResponse(data: Data, response: URLResponse) throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        guard (200..<300).contains(httpResponse.statusCode) else {
            let urlString = httpResponse.url?.absoluteString ?? ""
            let bodyString = String(data: data, encoding: .utf8) ?? ""
            logger.error("HTTP \(httpResponse.statusCode) for \(urlString): \(bodyString)")
            throw NetworkError(statusCode: httpResponse.statusCode, url: urlString, responseBody: bodyString)
        }
    }

}
