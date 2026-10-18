//
//  SearchDetailSectionRow.swift
//  CourseGrab
//
//  Created by jiwon jeong on 3/27/26.
//

import SwiftUI

/// FA26 `class cards` type=discussion: status, section time and logistics, plus the bell toggle.
struct SearchDetailSectionRow: View {

    // MARK: - Properties

    let section: CourseSection
    let onTrack: () -> Void
    let onUntrack: () -> Void
    @AppStorage("localTimezoneEnabled") private var localTimezoneEnabled: Bool = false

    // MARK: - UI

    var body: some View {
        HStack(alignment: .top, spacing: Constants.Detail.discussionSpacing) {
            StatusBadgeView(status: section.status)
                .padding(.top, 1)
            texts
            TrackingBellToggleView(
                isTracking: section.isTracking,
                onToggle: section.isTracking ? onUntrack : onTrack
            )
        }
        .padding(Constants.Card.padding)
        .frame(maxWidth: .infinity, alignment: .leading)
        .cardStyle()
    }

    private var texts: some View {
        VStack(alignment: .leading, spacing: Constants.Detail.discussionTextSpacing) {
            Text(section.getSectionByTimezone(useLocalTimezone: localTimezoneEnabled))
                .font(Constants.Fonts.h3)
                .foregroundStyle(Constants.Colors.black)
            Text("\(section.mode) · \(section.displayInstructors)")
                .font(Constants.Fonts.body)
                .foregroundStyle(Constants.Colors.darkGray)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

}

#if DEBUG
#Preview {
    VStack {
        SearchDetailSectionRow(section: .mockDiscussion, onTrack: {}, onUntrack: {})
        SearchDetailSectionRow(section: .mockClosed, onTrack: {}, onUntrack: {})
    }
    .padding()
}
#endif
