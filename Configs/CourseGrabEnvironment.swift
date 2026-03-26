//
//  CourseGrabEnvironment.swift
//  CourseGrab
//
//  Created by Jiwon Jeong on 3/26/26.
//  Copyright © 2026 Cornell AppDev. All rights reserved.
//

import Foundation

/// Data from Info.plist stored as environment variables.
enum CourseGrabEnvironment {

    /// Keys from Info.plist.
    enum Keys {
        static let serverHost = "SERVER_HOST"
        static let announcementsCommonPath = "ANNOUNCEMENTS_COMMON_PATH"
        static let announcementsHost = "ANNOUNCEMENTS_HOST"
        static let announcementsPath = "ANNOUNCEMENTS_PATH"
        static let announcementsScheme = "ANNOUNCEMENTS_SCHEME"

        static let googleClientID = googleServiceDict["CLIENT_ID"] as? String ?? ""
    }

    /// A dictionary storing key-value pairs from Info.plist.
    private static let infoDict: [String: Any] = {
        guard let dict = Bundle.main.infoDictionary else {
            fatalError("Info.plist not found")
        }
        return dict
    }()

    /// An NSDictionary storing key-value pairs from GoogleService-Info.plist.
    private static let googleServiceDict: NSDictionary = {
        guard let path = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist") else {
            fatalError("Path for GoogleService-Info invalid")
        }
        guard let myDict = NSDictionary(contentsOfFile: path) else {
            fatalError("GoogleService-Info.plist not found")
        }
        return myDict
    }()

    /// The server host for CourseGrab's backend.
    static let serverHost: String = {
        guard let value = CourseGrabEnvironment.infoDict[Keys.serverHost] as? String else {
            fatalError("SERVER_HOST not found in Info.plist")
        }
        return value
    }()

    /// The common path for AppDev Announcements.
    static let announcementsCommonPath: String = {
        guard let value = CourseGrabEnvironment.infoDict[Keys.announcementsCommonPath] as? String else {
            fatalError("ANNOUNCEMENTS_COMMON_PATH not found in Info.plist")
        }
        return value
    }()

    /// The host for AppDev Announcements.
    static let announcementsHost: String = {
        guard let value = CourseGrabEnvironment.infoDict[Keys.announcementsHost] as? String else {
            fatalError("ANNOUNCEMENTS_HOST not found in Info.plist")
        }
        return value
    }()

    /// The path for AppDev Announcements.
    static let announcementsPath: String = {
        guard let value = CourseGrabEnvironment.infoDict[Keys.announcementsPath] as? String else {
            fatalError("ANNOUNCEMENTS_PATH not found in Info.plist")
        }
        return value
    }()

    /// The scheme for AppDev Announcements.
    static let announcementsScheme: String = {
        guard let value = CourseGrabEnvironment.infoDict[Keys.announcementsScheme] as? String else {
            fatalError("ANNOUNCEMENTS_SCHEME not found in Info.plist")
        }
        return value
    }()

}
