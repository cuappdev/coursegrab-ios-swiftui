//
//  SearchTrackedSectionRow.swift
//  CourseGrab
//
//  Created by jiwon jeong on 3/27/26.
//

import SwiftUI

struct SearchTrackedSectionRow: View {

    // MARK: - Properties

    let section: CourseSection
    let onUntrack: (CourseSection) -> Void
    @AppStorage("localTimezoneEnabled") private var localTimezoneEnabled: Bool = false

    // MARK: - Body

    var body: some View {
        HStack(spacing: 12) {
            StatusBadgeView(status: section.status)
                .frame(width: 16, height: 16)

            Text(section.getSectionByTimezone(useLocalTimezone: localTimezoneEnabled))
                .font(Constants.Fonts.semibold14)
                .foregroundStyle(Constants.Colors.black)
                .lineLimit(1)

            Spacer()

            Button {
                onUntrack(section)
            } label: {
                Text("REMOVE")
                    .font(Constants.Fonts.medium12)
                    .foregroundStyle(Constants.Colors.ruby)
                    .frame(width: 90, height: 24)
                    .overlay(
                        RoundedRectangle(cornerRadius: 2)
                            .stroke(Constants.Colors.ruby, lineWidth: 1)
                    )
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }

}
