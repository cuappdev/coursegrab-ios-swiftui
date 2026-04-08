//
//  CourseSection.swift
//  CourseGrab
//
//  Created by jiwon jeong on 3/27/26.
//

import Foundation

enum Status: String, Codable {
    case closed = "CLOSED"
    case open = "OPEN"
    case waitlist = "WAITLISTED"
}

struct CourseSection: Codable, Identifiable {
    var id: Int { catalogNum }
    let catalogNum: Int
    let courseId: Int
    let courseNum: Int
    let instructors: [String]
    let isTracking: Bool
    let mode: String
    let numTracking: Int
    let section: String
    let status: Status
    let subjectCode: String
    let title: String
    
    var displayCatalogNum: String {
        String(catalogNum)
    }
    
    func getSectionNum() -> String {
        let sectionNum = self.section.components(separatedBy: "/")[0]
        return sectionNum.trimmingCharacters(in: .whitespaces)
    }
    
    var displayTitle: String {
        "\(subjectCode) \(String(courseNum)): \(title)"
    }
    
    func getSectionByTimezone() -> String {
        getSectionByTimezone(
            useLocalTimezone: UserDefaults.standard.bool(forKey: "localTimezoneEnabled")
        )
    }

    func getSectionByTimezone(useLocalTimezone: Bool) -> String {
        if let index = section.lastIndex(of: " ") {
            let timeIndexStart = section.index(after: index)
            let sectionString = String(section[..<timeIndexStart])
            let timeString = String(section[timeIndexStart...])

            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "h:mma"
            dateFormatter.timeZone = TimeZone(identifier: "America/New_York")
            guard let date = dateFormatter.date(from: timeString) else {
                return section
            }
            if useLocalTimezone {
                dateFormatter.timeZone = TimeZone.current
            }
            dateFormatter.dateFormat = "h:mma"
            return sectionString + dateFormatter.string(from: date)
        }
        return section
    }
}
