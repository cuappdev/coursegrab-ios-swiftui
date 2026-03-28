//
//  SessionAuthorization.swift
//  CourseGrab
//
//  Created by jiwon jeong on 3/27/26.
//

import Foundation

struct SessionAuthorization: Codable {
    let sessionToken: String
    let updateToken: String
    let sessionExpiration: Date
}
