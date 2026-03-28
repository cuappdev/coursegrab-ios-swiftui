//
//  SearchDetailView.swift
//  CourseGrab
//
//  Created by jiwon jeong on 3/27/26.
//

import SwiftUI

struct SearchDetailView: View {

    // MARK: - Properties

    let course: Course
    let searchViewModel: SearchView.ViewModel
    let onSectionTracked: (_ message: String) -> Void

    // MARK: - Body

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                SearchDetailCardView(course: course)
                    .padding(.vertical, 12)

                ForEach(course.sections) { section in
                    Divider()
                    SearchDetailSectionRow(
                        section: section,
                        onTrack: {
                            Task {
                                await searchViewModel.track(section: section)
                                let message = "You are now tracking \(course.subjectCode) \(String(course.courseNum)) \(section.getSectionNum())"
                                onSectionTracked(message)
                            }
                        },
                        onUntrack: {
                            Task {
                                await searchViewModel.untrack(section: section)
                                let message = "You are no longer tracking \(course.subjectCode) \(String(course.courseNum)) \(section.getSectionNum())"
                                onSectionTracked(message)
                            }
                        }
                    )
                }
            }
        }
        .navigationTitle("\(course.subjectCode) \(String(course.courseNum))")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.black, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
    }

}
