//
//  SearchDetailSectionRow.swift
//  CourseGrab
//
//  Created by jiwon jeong on 3/27/26.
//

import SwiftUI

struct SearchDetailSectionRow: View {

    // MARK: - Properties

    let section: CourseSection
    let onTrack: () -> Void
    let onUntrack: () -> Void

    // MARK: - Body

    var body: some View {
        HStack(spacing: 12) {
            StatusBadgeView(status: section.status)
                .frame(width: 16, height: 16)

            VStack(alignment: .leading, spacing: 4) {
                Text(section.getSectionByTimezone())
                    .font(Constants.Fonts.semibold14)
                    .foregroundStyle(Constants.Colors.black)

                HStack(spacing: 4) {
                    Constants.Images.iconPopularity
                        .resizable()
                        .scaledToFit()
                        .frame(width: 16, height: 12)
                    
                    Text("\(section.numTracking) tracking")
                        .font(Constants.Fonts.medium12)
                        .foregroundStyle(Constants.Colors.mediumGray)
                }
            }

            Spacer()

            Button {
                section.isTracking ? onUntrack() : onTrack()
            } label: {
                Text(section.isTracking ? "REMOVE" : "TRACK")
                    .font(Constants.Fonts.medium12)
                    .foregroundStyle(
                        section.isTracking ? Constants.Colors.ruby : Constants.Colors.black
                    )
                    .frame(width: 90, height: 24)
                    .overlay(
                        RoundedRectangle(cornerRadius: 2)
                            .stroke(
                                section.isTracking ? Constants.Colors.ruby : Constants.Colors.black,
                                lineWidth: 1
                            )
                    )
            }
        }
        .padding(.horizontal, Constants.Padding.screenHorizontal)
        .frame(height: 62)
    }

}
