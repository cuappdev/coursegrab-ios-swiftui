//
//  HomeStateView.swift
//  CourseGrab
//
//  Created by jiwon jeong on 3/27/26.
//

import SwiftUI

/// FA26 `home` empty / error block: illustration, title and subtitle.
struct HomeStateView: View {

    // MARK: - Properties

    let title: String
    let subtitle: String
    var image: Image?

    // MARK: - UI

    var body: some View {
        VStack(spacing: Constants.EmptyState.spacing) {
            if let image {
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: Constants.EmptyState.imageSize, height: Constants.EmptyState.imageSize)
            }
            texts
        }
        .multilineTextAlignment(.center)
        .padding(.vertical, Constants.EmptyState.verticalPadding)
        .padding(.horizontal, Constants.Padding.screenHorizontal)
    }

    private var texts: some View {
        VStack(spacing: Constants.EmptyState.textSpacing) {
            Text(title)
                .font(Constants.Fonts.stateTitle)
                .foregroundStyle(Constants.Colors.black)
            Text(subtitle)
                .font(Constants.Fonts.stateSubtitle)
                .foregroundStyle(Constants.Colors.darkGray)
        }
    }

}

#Preview {
    VStack {
        HomeStateView(
            title: "No Courses Currently Tracked",
            subtitle: "Search to start adding courses",
            image: Constants.Images.emptyNoCourses
        )
        HomeStateView(
            title: "No Internet Connection",
            subtitle: "Please try again later",
            image: Constants.Images.emptyNoInternet
        )
    }
}
