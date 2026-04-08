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
        // Backend uses Unix timestamps (seconds) for dates.
        encoder.dateEncodingStrategy = .secondsSince1970
        return encoder
    }()

    private let jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        // Backend uses Unix timestamps (seconds) for dates.
        decoder.dateDecodingStrategy = .secondsSince1970
        return decoder
    }()

    private let baseURL = "https://\(CourseGrabEnvironment.serverHost)/api"

    // MARK: - Init

    private init() {}

    // MARK: - URL Construction

    func constructURL(endpoint: String) throws -> URL {
        let path = endpoint.hasPrefix("/") ? endpoint : "/\(endpoint)"
        guard let url = URL(string: baseURL + path) else {
            logger.error("Failed to construct URL. baseURL=\(self.baseURL) endpoint=\(endpoint)")
            throw URLError(.badURL)
        }
        return url
    }

    // MARK: - APIClient

    func get<T: Decodable>(url: URL, attempt: Int = 1) async throws -> T {
        let request = try createRequest(url: url, method: "GET")
        let (data, response) = try await perform(request: request)
        try handleResponse(data: data, response: response)
        do {
            return try jsonDecoder.decode(T.self, from: data)
        } catch {
            logDecodingFailure(expectedType: T.self, request: request, data: data, error: error)
            throw error
        }
    }

    func post<T: Decodable, U: Encodable>(url: URL, body: U, attempt: Int = 1) async throws -> T {
        let requestData = try jsonEncoder.encode(body)
        let request = try createRequest(url: url, method: "POST", body: requestData)
        let (data, response) = try await perform(request: request)
        try handleResponse(data: data, response: response)
        do {
            return try jsonDecoder.decode(T.self, from: data)
        } catch {
            logDecodingFailure(expectedType: T.self, request: request, data: data, error: error)
            throw error
        }
    }

    func post<U: Encodable>(url: URL, body: U, attempt: Int = 1) async throws {
        let requestData = try jsonEncoder.encode(body)
        let request = try createRequest(url: url, method: "POST", body: requestData)
        let (data, response) = try await perform(request: request)
        try handleResponse(data: data, response: response)
    }

    func post<T: Decodable>(url: URL, attempt: Int = 1) async throws -> T {
        let request = try createRequest(url: url, method: "POST")
        let (data, response) = try await perform(request: request)
        try handleResponse(data: data, response: response)
        do {
            return try jsonDecoder.decode(T.self, from: data)
        } catch {
            logDecodingFailure(expectedType: T.self, request: request, data: data, error: error)
            throw error
        }
    }

    func delete(url: URL, attempt: Int = 1) async throws {
        let request = try createRequest(url: url, method: "DELETE")
        let (data, response) = try await perform(request: request)
        try handleResponse(data: data, response: response)
    }

    // MARK: - CourseGrab Endpoints

    func getAllTrackedSections() async throws -> [CourseSection] {
        let url = try constructURL(endpoint: "/users/tracking/")
        let response: APIResponse<Sections> = try await get(url: url)
        try requireSuccess(response, url: url)
        return response.data?.sections ?? []
    }

    func trackSection(catalogNum: Int) async throws -> CourseSection {
        let url = try constructURL(endpoint: "/sections/track/")
        let body = CoursePostBody(courseId: catalogNum)
        let response: APIResponse<CourseSection> = try await post(url: url, body: body)
        try requireSuccess(response, url: url)
        guard let data = response.data else { throw APIError(url: url.absoluteString, errors: response.errors ?? ["Missing response data"]) }
        return data
    }

    func untrackSection(catalogNum: Int) async throws -> CourseSection {
        let url = try constructURL(endpoint: "/sections/untrack/")
        let body = CoursePostBody(courseId: catalogNum)
        let response: APIResponse<CourseSection> = try await post(url: url, body: body)
        try requireSuccess(response, url: url)
        guard let data = response.data else { throw APIError(url: url.absoluteString, errors: response.errors ?? ["Missing response data"]) }
        return data
    }

    func searchCourse(query: String) async throws -> [Course] {
        let url = try constructURL(endpoint: "/courses/search/")
        let body = QueryBody(query: query)
        let response: APIResponse<CourseSearch> = try await post(url: url, body: body)
        try requireSuccess(response, url: url)
        return response.data?.courses ?? []
    }

    func getSection(catalogNum: Int) async throws -> CourseSection {
        let url = try constructURL(endpoint: "/sections/\(catalogNum)/")
        let response: APIResponse<CourseSection> = try await get(url: url)
        try requireSuccess(response, url: url)
        guard let data = response.data else { throw APIError(url: url.absoluteString, errors: response.errors ?? ["Missing response data"]) }
        return data
    }

    func getCourse(courseNum: Int) async throws -> Course {
        let url = try constructURL(endpoint: "/courses/\(courseNum)/")
        let response: APIResponse<Course> = try await get(url: url)
        try requireSuccess(response, url: url)
        guard let data = response.data else { throw APIError(url: url.absoluteString, errors: response.errors ?? ["Missing response data"]) }
        return data
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
        let response: APIResponse<SessionAuthorization> = try await post(url: url, body: body)
        try requireSuccess(response, url: url)
        guard let data = response.data else { throw APIError(url: url.absoluteString, errors: response.errors ?? ["Missing response data"]) }
        return data
    }

    func updateSession() async throws -> SessionAuthorization {
        let url = try constructURL(endpoint: "/session/update/")
        // Backend expects the *update* token on this endpoint, not the session token.
        let request = try createRequest(url: url, method: "POST", useUpdateToken: true)
        let (data, response) = try await perform(request: request)
        try handleResponse(data: data, response: response)
        let decoded: APIResponse<SessionAuthorization>
        do {
            decoded = try jsonDecoder.decode(APIResponse<SessionAuthorization>.self, from: data)
        } catch {
            logDecodingFailure(expectedType: APIResponse<SessionAuthorization>.self, request: request, data: data, error: error)
            throw error
        }
        try requireSuccess(decoded, url: url)
        guard let sessionData = decoded.data else {
            throw APIError(url: url.absoluteString, errors: decoded.errors ?? ["Missing response data"])
        }
        return sessionData
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

    private func perform(request: URLRequest) async throws -> (Data, URLResponse) {
        logOutgoingRequest(request)
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            if let http = response as? HTTPURLResponse {
                logger.info("⬅️ \(request.httpMethod ?? "") \(http.statusCode) \(request.url?.absoluteString ?? "")")
            } else {
                logger.info("⬅️ \(request.httpMethod ?? "") \(request.url?.absoluteString ?? "") (non-HTTP response)")
            }
            return (data, response)
        } catch {
            logRequestFailure(request, error: error)
            throw error
        }
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

    private func logOutgoingRequest(_ request: URLRequest) {
        let method = request.httpMethod ?? "?"
        let url = request.url?.absoluteString ?? "?"
        let bodyBytes = request.httpBody?.count ?? 0
        let hasAuth = (request.value(forHTTPHeaderField: "Authorization") != nil)
        logger.info("➡️ \(method) \(url) (bodyBytes=\(bodyBytes), auth=\(hasAuth))")
    }

    private func logRequestFailure(_ request: URLRequest, error: Error) {
        let method = request.httpMethod ?? "?"
        let url = request.url?.absoluteString ?? "?"

        if let urlError = error as? URLError {
            logger.error("❌ \(method) \(url) failed: URLError(\(urlError.code.rawValue)) \(urlError.localizedDescription)")
        } else {
            logger.error("❌ \(method) \(url) failed: \(String(describing: error))")
        }
    }

    private func logDecodingFailure<T>(
        expectedType: T.Type,
        request: URLRequest,
        data: Data,
        error: Error
    ) {
        let method = request.httpMethod ?? "?"
        let url = request.url?.absoluteString ?? "?"
        let bodyString = String(data: data, encoding: .utf8) ?? "<non-utf8 body, \(data.count) bytes>"
        logger.error(
            """
            🧩 Decoding failed for \(method) \(url). Expected=\(String(describing: expectedType)). Error=\(String(describing: error)).
            Body=\(bodyString)
            """
        )
    }

    private func requireSuccess<T: Codable>(_ response: APIResponse<T>, url: URL) throws {
        guard response.success else {
            throw APIError(url: url.absoluteString, errors: response.errors ?? ["Request failed"])
        }
    }

}
