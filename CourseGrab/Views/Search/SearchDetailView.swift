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

    // MARK: - Body

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Course info card
                SearchDetailCardView(course: course)
                    .padding(.vertical, 12)

                // Section rows
                ForEach(course.sections) { section in
                    
                    Divider()
                    
                    SearchDetailSectionRow(
                        section: section,
                        onTrack: {
                            Task { await searchViewModel.track(section: section) }
                        },
                        onUntrack: {
                            Task { await searchViewModel.untrack(section: section) }
                        }
                    )
                }
            }
        }
        .navigationTitle("\(course.subjectCode) \(course.courseNum)")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.black, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
    }

}
