//
//  NetworkModels.swift
//  CourseGrab
//
//  Created by jiwon jeong on 3/27/26.
//

import Foundation

// MARK: - Response Wrappers

/// Backend responses are wrapped in an envelope like:
/// - success: true  -> { "data": <T>, "success": true, ... }
/// - success: false -> { "data": { "errors": [String] }, "success": false, ... }
///
/// This model decodes both cases so we can surface a real error instead of failing JSON decoding.
struct APIResponse<T: Codable>: Codable {
    let data: T?
    let success: Bool
    let timestamp: Int?
    let errors: [String]?

    private struct ErrorPayload: Codable {
        let errors: [String]
    }

    enum CodingKeys: String, CodingKey {
        case data
        case success
        case timestamp
    }

    init(data: T?, success: Bool, timestamp: Int?, errors: [String]?) {
        self.data = data
        self.success = success
        self.timestamp = timestamp
        self.errors = errors
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        success = try container.decode(Bool.self, forKey: .success)
        timestamp = try container.decodeIfPresent(Int.self, forKey: .timestamp)

        if let decodedData = try? container.decode(T.self, forKey: .data) {
            data = decodedData
            errors = nil
            return
        }

        if let decodedError = try? container.decode(ErrorPayload.self, forKey: .data) {
            data = nil
            errors = decodedError.errors
            return
        }

        data = nil
        errors = nil
    }
}

struct Sections: Codable {
    let sections: [CourseSection]
}

struct CourseSearch: Codable {
    let courses: [Course]
    let query: String
}

struct SessionAuthorization: Codable {
    let sessionToken: String
    let updateToken: String
    let sessionExpiration: Date
}

// MARK: - Request Bodies

struct SessionBody: Codable {
    let deviceToken: String?
    let deviceType: String
    let token: String
}

struct QueryBody: Codable {
    let query: String
}

struct CoursePostBody: Codable {
    let courseId: Int
}

struct DeviceTokenBody: Codable {
    let deviceToken: String
}

struct EnableNotificationsBody: Codable {
    let notification: String
}
