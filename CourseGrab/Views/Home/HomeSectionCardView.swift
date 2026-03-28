//
//  HomeSectionCardView.swift
//  CourseGrab
//
//  Created by jiwon jeong on 3/27/26.
//

import SwiftUI

struct HomeSectionCardView: View {

    // MARK: - Properties

    let section: CourseSection
    let onUntrack: () -> Void

    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {

            HStack(alignment: .top) {
                Text(section.displayTitle)
                    .font(Constants.Fonts.semibold16)
                    .foregroundStyle(Constants.Colors.black)
                    .multilineTextAlignment(.leading)
                
                Spacer()
                
                StatusBadgeView(status: section.status)
                    .frame(width: 16, height: 16)
            }

            HStack(spacing: 6) {
                Text(section.displayCatalogNum)
                    .font(Constants.Fonts.medium14)
                    .foregroundStyle(Constants.Colors.black)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(Constants.Colors.veryLightGray)
                    .clipShape(Capsule())

                Text(section.mode)
                    .font(Constants.Fonts.semibold12)
                    .foregroundStyle(Constants.Colors.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(Constants.Colors.gray)
                    .clipShape(Capsule())
            }

            Text(section.section)
                .font(Constants.Fonts.medium14)
                .foregroundStyle(Constants.Colors.gray)

            HStack(spacing: 4) {
                Constants.Images.iconPopularity
                    .resizable()
                    .scaledToFit()
                    .frame(width: 16, height: 12)
                
                Text("\(section.numTracking) tracking")
                    .font(Constants.Fonts.medium12)
                    .foregroundStyle(Constants.Colors.mediumGray)
            }

            HStack(spacing: 12) {
                if section.status == .open {
                    Button {
                        if let url = URL(string: "https://studentcenter.cornell.edu") {
                            UIApplication.shared.open(url)
                        }
                    } label: {
                        Text("ENROLL")
                            .font(Constants.Fonts.medium12)
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 37)
                            .background(Constants.Colors.black)
                            .clipShape(RoundedRectangle(cornerRadius: 2))
                    }
                }

                Button(action: onUntrack) {
                    Text("REMOVE")
                        .font(Constants.Fonts.medium12)
                        .foregroundStyle(Constants.Colors.ruby)
                        .frame(maxWidth: .infinity)
                        .frame(height: 37)
                        .overlay(
                            RoundedRectangle(cornerRadius: 2)
                                .stroke(Constants.Colors.ruby, lineWidth: 1)
                        )
                }
            }
            .padding(.top, 10)
        }
        .padding(Constants.Padding.cardInset)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 5))
        .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 0)
        .padding(.horizontal, Constants.Padding.screenHorizontal)
        .padding(.vertical, Constants.Padding.cellVertical)
    }

}
