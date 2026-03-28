//
//  NetworkModels.swift
//  CourseGrab
//
//  Created by jiwon jeong on 3/27/26.
//

import Foundation

// MARK: - Response Wrappers

struct Response<T: Codable>: Codable {
    let data: T
    let success: Bool
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
