//
//  SearchDetailView.swift
//  CourseGrab
//
//  Created by jiwon jeong on 3/27/26.
//

import SwiftUI

/// FA26 class detail. Tracking happens in place; the back caret returns to Home (with the
/// tracking banner) if anything was tracked or untracked here, otherwise back to Search.
struct SearchDetailView: View {

    // MARK: - Properties

    let course: Course
    @ObservedObject var searchViewModel: SearchViewModel
    let onSectionTracked: (_ message: String) -> Void
    @Environment(\.dismiss) private var dismiss

    private var currentCourse: Course {
        searchViewModel.currentCourse(for: course)
    }

    // MARK: - UI

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Constants.Padding.sectionSpacing) {
                titleBar
                infoBlock
                secondarySections
            }
            .padding(.horizontal, Constants.Padding.screenHorizontal)
            .padding(.top, Constants.Padding.detailTop)
            .padding(.bottom, Constants.Padding.screenBottom)
        }
        .background(Constants.Colors.white.ignoresSafeArea())
        .toolbar(.hidden, for: .navigationBar)
    }

    private var titleBar: some View {
        NavigationTitleBarView(title: currentCourse.displayCode) {
            searchViewModel.leaveDetail(onTrackingChanged: onSectionTracked, onDismiss: { dismiss() })
        }
    }

    private var infoBlock: some View {
        SearchDetailCardView(
            course: currentCourse,
            section: searchViewModel.primarySection(of: currentCourse),
            onToggleTracking: { Task { await searchViewModel.togglePrimaryTracking(in: currentCourse) } }
        )
    }

    @ViewBuilder
    private var secondarySections: some View {
        let sections = searchViewModel.secondarySections(of: currentCourse)
        if !sections.isEmpty {
            Text(searchViewModel.secondarySectionsTitle(of: currentCourse))
                .font(Constants.Fonts.h3)
                .foregroundStyle(Constants.Colors.black)

            ForEach(sections) { section in
                SearchDetailSectionRow(
                    section: section,
                    onTrack: { Task { await searchViewModel.toggleTracking(section, in: currentCourse) } },
                    onUntrack: { Task { await searchViewModel.toggleTracking(section, in: currentCourse) } }
                )
            }
        }
    }

}

#if DEBUG
#Preview {
    NavigationStack {
        SearchDetailView(course: .mock, searchViewModel: SearchViewModel(), onSectionTracked: { _ in })
    }
}
#endif
