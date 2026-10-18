//
//  SearchDetailCardView.swift
//  CourseGrab
//
//  Created by jiwon jeong on 3/27/26.
//

import SwiftUI

/// FA26 class detail info block: course title, the primary (lecture) section with its
/// status and logistics, and the full-width TRACK / TRACKING button.
struct SearchDetailCardView: View {

    // MARK: - Properties

    let course: Course
    var section: CourseSection?
    var onToggleTracking: () -> Void = {}
    @AppStorage("localTimezoneEnabled") private var localTimezoneEnabled: Bool = false

    // MARK: - UI

    var body: some View {
        VStack(alignment: .leading, spacing: Constants.Detail.infoSpacing) {
            Text(course.title)
                .font(Constants.Fonts.h2)
                .foregroundStyle(Constants.Colors.black)
                .multilineTextAlignment(.leading)
            if let section {
                sectionRow(section)
                logistics(section)
                trackButton(isTracking: section.isTracking)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func sectionRow(_ section: CourseSection) -> some View {
        HStack(spacing: Constants.Detail.statusSpacing) {
            StatusBadgeView(status: section.status)
            Text(section.getSectionByTimezone(useLocalTimezone: localTimezoneEnabled))
                .font(Constants.Fonts.h3)
                .foregroundStyle(Constants.Colors.black)
        }
    }

    private func logistics(_ section: CourseSection) -> some View {
        HStack(alignment: .top) {
            Text(section.mode)
            Spacer()
            Text(section.displayInstructors)
                .multilineTextAlignment(.trailing)
        }
        .font(Constants.Fonts.body)
        .foregroundStyle(Constants.Colors.darkGray)
    }

    private func trackButton(isTracking: Bool) -> some View {
        Button(action: onToggleTracking) {
            HStack(spacing: Constants.Card.buttonContentSpacing) {
                (isTracking ? Constants.Images.trackBellWhite : Constants.Images.trackBellGray)
                    .resizable()
                    .scaledToFit()
                    .frame(width: Constants.Detail.trackBellSize.width, height: Constants.Detail.trackBellSize.height)
                Text(isTracking ? "TRACKING" : "TRACK")
                    .font(Constants.Fonts.label)
                    .foregroundStyle(isTracking ? Constants.Colors.white : Constants.Colors.darkGray)
            }
            .padding(.horizontal, Constants.Detail.trackButtonHorizontalPadding)
            .padding(.vertical, Constants.Detail.trackButtonVerticalPadding)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: Constants.Radius.button)
                    .fill(isTracking ? Constants.Colors.black : Constants.Colors.white)
            )
            .overlay(
                RoundedRectangle(cornerRadius: Constants.Radius.button)
                    .stroke(isTracking ? Color.clear : Constants.Colors.gray, lineWidth: Constants.Border.button)
            )
        }
        .buttonStyle(.scale)
        .animation(.easeInOut(duration: Constants.Interaction.modalAnimationDuration), value: isTracking)
    }

}

#if DEBUG
#Preview {
    SearchDetailCardView(course: .mock, section: .mockOpen)
        .padding()
}
#endif
