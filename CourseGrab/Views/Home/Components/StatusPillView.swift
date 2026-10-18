//
//  StatusPillView.swift
//  CourseGrab
//
//  Created by jiwon jeong on 10/18/26.
//

import SwiftUI

/// FA26 `pills` component: status glyph plus "N Open / Closed / Waitlisted".
struct StatusPillView: View {

    // MARK: - Properties

    let status: Status
    let count: Int

    private var label: String {
        switch status {
        case .open:
            return "\(count) Open"
        case .closed:
            return "\(count) Closed"
        case .waitlist:
            return "\(count) Waitlisted"
        }
    }

    // MARK: - UI

    var body: some View {
        HStack(spacing: Constants.Pill.spacing) {
            StatusBadgeView(status: status)
            Text(label)
                .font(Constants.Fonts.label)
                .foregroundStyle(Constants.Colors.black)
                .lineLimit(1)
        }
        .padding(.horizontal, Constants.Pill.horizontalPadding)
        .padding(.vertical, Constants.Pill.verticalPadding)
        .background(Capsule().fill(Constants.Colors.white))
        .overlay(Capsule().stroke(Constants.Colors.gray, lineWidth: Constants.Border.hairline))
        .shadow(
            color: Constants.Shadow.dropColor,
            radius: Constants.Shadow.dropRadius,
            x: 0,
            y: Constants.Shadow.dropY
        )
        .accessibilityElement(children: .combine)
    }

}

#Preview {
    HStack {
        StatusPillView(status: .open, count: 1)
        StatusPillView(status: .closed, count: 3)
        StatusPillView(status: .waitlist, count: 0)
    }
}
