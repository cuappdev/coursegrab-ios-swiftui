//
//  SearchCourseCardView.swift
//  CourseGrab
//
//  Created by jiwon jeong on 3/27/26.
//

import SwiftUI

/// FA26 `class cards` type=search: course title with a trailing caret. Sections the user
/// already tracks are listed underneath with a remove button (kept from the previous design).
struct SearchCourseCardView: View {

    // MARK: - Properties

    let course: Course
    let onUntrack: (CourseSection) -> Void

    private var trackedSections: [CourseSection] {
        course.sections.filter { $0.isTracking }
    }

    // MARK: - UI

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            titleRow
            ForEach(trackedSections) { section in
                Divider()
                    .overlay(Constants.Colors.gray)
                SearchTrackedSectionRow(section: section, onUntrack: onUntrack)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .cardStyle()
    }

    private var titleRow: some View {
        HStack {
            Text(course.displayTitle)
                .font(Constants.Fonts.h3)
                .foregroundStyle(Constants.Colors.black)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
            Constants.Images.rightCaret
                .resizable()
                .scaledToFit()
                .frame(width: Constants.Card.caretSize, height: Constants.Card.caretSize)
        }
        .padding(.vertical, Constants.Card.padding)
        .padding(.leading, Constants.Card.padding)
        .padding(.trailing, Constants.Card.searchTrailingPadding)
    }

}

#if DEBUG
#Preview {
    SearchCourseCardView(course: .mock, onUntrack: { _ in })
        .padding()
}
#endif
