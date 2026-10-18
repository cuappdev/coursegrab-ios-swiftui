//
//  PreviewMocks.swift
//  CourseGrab
//
//  Created by jiwon jeong on 10/18/26.
//

#if DEBUG
import Foundation

/// Fixture data for SwiftUI previews only; never reference from shipping code.
extension CourseSection {

    static let mockOpen = CourseSection(
        catalogNum: 1389,
        courseId: 358_210,
        courseNum: 1400,
        instructors: ["Fiskesjo, M"],
        isTracking: true,
        mode: "In-Person",
        numTracking: 12,
        section: "LEC 001 / MW 10:10AM",
        status: .open,
        subjectCode: "ANTHR",
        title: "Introduction to Sociocultural Anthropology"
    )

    static let mockClosed = CourseSection(
        catalogNum: 1390,
        courseId: 358_210,
        courseNum: 1400,
        instructors: [],
        isTracking: false,
        mode: "In-Person",
        numTracking: 4,
        section: "DIS 201 / R 9:05AM",
        status: .closed,
        subjectCode: "ANTHR",
        title: "Introduction to Sociocultural Anthropology"
    )

    static let mockDiscussion = CourseSection(
        catalogNum: 1394,
        courseId: 358_210,
        courseNum: 1400,
        instructors: [],
        isTracking: true,
        mode: "In-Person",
        numTracking: 7,
        section: "DIS 205 / R 1:25PM",
        status: .open,
        subjectCode: "ANTHR",
        title: "Introduction to Sociocultural Anthropology"
    )

    static let mockWaitlisted = CourseSection(
        catalogNum: 4790,
        courseId: 361_005,
        courseNum: 4790,
        instructors: ["Brainerd, C"],
        isTracking: true,
        mode: "In-Person",
        numTracking: 3,
        section: "LEC 001 / MW 2:55PM",
        status: .waitlist,
        subjectCode: "HD",
        title: "Memory and the Law"
    )

}

extension Course {

    static let mock = Course(
        courseNum: 1400,
        subjectCode: "ANTHR",
        sections: [.mockOpen, .mockClosed, .mockDiscussion],
        title: "Introduction to Sociocultural Anthropology"
    )

}
#endif
