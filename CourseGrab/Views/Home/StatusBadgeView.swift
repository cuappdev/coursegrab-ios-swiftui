//
//  StatusBadgeView.swift
//  CourseGrab
//
//  Created by jiwon jeong on 3/27/26.
//

import SwiftUI

/// FA26 status glyph: green circle (open), red rounded square (closed), yellow triangle (waitlisted).
struct StatusBadgeView: View {

    // MARK: - Properties

    let status: Status

    // MARK: - UI

    var body: some View {
        switch status {
        case .open:
            Circle()
                .fill(Constants.Colors.green)
                .frame(width: Constants.StatusIcon.iconSize, height: Constants.StatusIcon.iconSize)
        case .closed:
            RoundedRectangle(cornerRadius: Constants.Radius.statusSquare)
                .fill(Constants.Colors.red)
                .frame(width: Constants.StatusIcon.iconSize, height: Constants.StatusIcon.iconSize)
        case .waitlist:
            Constants.Images.waitlist
                .resizable()
                .scaledToFit()
                .frame(width: Constants.StatusIcon.waitlistIconSize, height: Constants.StatusIcon.waitlistIconSize)
        }
    }

}

#Preview {
    HStack {
        StatusBadgeView(status: .open)
        StatusBadgeView(status: .closed)
        StatusBadgeView(status: .waitlist)
    }
}
