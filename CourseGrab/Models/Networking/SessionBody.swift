//
//  SessionBody.swift
//  CourseGrab
//
//  Created by jiwon jeong on 3/27/26.
//

import Foundation

struct SessionBody: Codable {
    let deviceToken: String?
    let deviceType: String
    let token: String
}
