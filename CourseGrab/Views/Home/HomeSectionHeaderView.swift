//
//  HomeSectionHeaderView.swift
//  CourseGrab
//
//  Created by jiwon jeong on 3/27/26.
//

import SwiftUI

/// FA26 "Tracked Classes" title with the open / closed / waitlisted summary pills.
struct HomeSectionHeaderView: View {

    // MARK: - Properties

    let openCount: Int
    let closedCount: Int
    let waitlistCount: Int

    // MARK: - UI

    var body: some View {
        VStack(alignment: .leading, spacing: Constants.Padding.sectionSpacing) {
            title
            pills
        }
    }

    private var title: some View {
        Text("Tracked Classes")
            .font(Constants.Fonts.h1)
            .foregroundStyle(Constants.Colors.black)
    }

    private var pills: some View {
        HStack {
            StatusPillView(status: .open, count: openCount)
            Spacer(minLength: 0)
            StatusPillView(status: .closed, count: closedCount)
            Spacer(minLength: 0)
            StatusPillView(status: .waitlist, count: waitlistCount)
        }
    }

}

#Preview {
    HomeSectionHeaderView(openCount: 1, closedCount: 3, waitlistCount: 0)
        .padding()
}
