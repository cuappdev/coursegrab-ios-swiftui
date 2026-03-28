//
//  Response.swift
//  CourseGrab
//
//  Created by jiwon jeong on 3/27/26.
//

import Foundation

struct Response<T: Codable>: Codable {
    let data: T
    let success: Bool
}
