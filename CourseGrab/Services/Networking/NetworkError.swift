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
