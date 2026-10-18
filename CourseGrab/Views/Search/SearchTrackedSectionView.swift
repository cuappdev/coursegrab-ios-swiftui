//
//  SearchTrackedSectionView.swift
//  CourseGrab
//
//  Created by jiwon jeong on 3/27/26.
//

import SwiftUI

/// A tracked section inside a search result card, with the FA26 remove (✕) control.
struct SearchTrackedSectionRow: View {

    // MARK: - Properties

    let section: CourseSection
    let onUntrack: (CourseSection) -> Void
    @AppStorage("localTimezoneEnabled") private var localTimezoneEnabled: Bool = false

    // MARK: - UI

    var body: some View {
        HStack(spacing: Constants.Card.headerSpacing) {
            StatusBadgeView(status: section.status)
            Text(section.getSectionByTimezone(useLocalTimezone: localTimezoneEnabled))
                .font(Constants.Fonts.body)
                .foregroundStyle(Constants.Colors.darkGray)
                .lineLimit(1)
                .frame(maxWidth: .infinity, alignment: .leading)
            removeButton
        }
        .padding(.horizontal, Constants.Card.padding)
        .padding(.vertical, Constants.Card.trackedRowVerticalPadding)
    }

    private var removeButton: some View {
        Button {
            onUntrack(section)
        } label: {
            Constants.Images.remove
                .resizable()
                .scaledToFit()
                .frame(width: Constants.Card.removeIconSize, height: Constants.Card.removeIconSize)
                .contentShape(Rectangle())
        }
        .buttonStyle(.scale)
        .accessibilityLabel("Stop tracking \(section.getSectionNum())")
    }

}

#if DEBUG
#Preview {
    SearchTrackedSectionRow(section: .mockOpen, onUntrack: { _ in })
}
#endif
