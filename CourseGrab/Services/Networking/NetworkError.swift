//
//  NetworkError.swift
//  CourseGrab
//
//  Created by jiwon jeong on 3/27/26.
//

import Foundation

struct NetworkError: Error, LocalizedError {
    let statusCode: Int
    let url: String
    let responseBody: String

    var errorDescription: String? {
        "HTTP \(statusCode) for \(url): \(responseBody)"
    }
}

struct APIError: Error, LocalizedError {
    let url: String
    let errors: [String]

    var errorDescription: String? {
        if errors.isEmpty { return "API error for \(url)" }
        return "API error for \(url): \(errors.joined(separator: ", "))"
    }
}

extension Error {
    /// `true` when the API rejected the session or credentials (user should sign in again).
    var invalidatesUserSession: Bool {
        if let network = self as? NetworkError {
            return network.statusCode == 401 || network.statusCode == 403
        }
        if let api = self as? APIError {
            return api.errors.contains { $0.localizedCaseInsensitiveContains("invalid session token") }
        }
        return false
    }
}
