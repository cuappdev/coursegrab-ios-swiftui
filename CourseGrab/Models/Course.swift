//
//  Course.swift
//  CourseGrab
//
//  Created by jiwon jeong on 3/27/26.
//

import Foundation

struct Course: Codable, Identifiable {
    var id: Int { courseNum }
    let courseNum: Int
    let subjectCode: String
    let sections: [CourseSection]
    let title: String

    var instructors: [String] {
        Array(Set(sections.reduce(into: []) { $0 += $1.instructors }))
    }
}
