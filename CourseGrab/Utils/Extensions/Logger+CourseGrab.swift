//
//  Logger+CourseGrab.swift
//  CourseGrab
//
//  Created by jiwon jeong on 10/18/26.
//

import Foundation
import OSLog

extension Logger {

    private static let subsystem = Bundle.main.bundleIdentifier ?? "com.cornellappdev.coursegrab"

    /// View model / feature-level events (tracking, search, refresh).
    static let viewModels = Logger(subsystem: subsystem, category: "ViewModels")

}
