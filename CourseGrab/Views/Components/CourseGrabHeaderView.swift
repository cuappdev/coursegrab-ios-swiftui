//
//  CourseGrabHeaderView.swift
//  CourseGrab
//
//  Created by jiwon jeong on 10/18/26.
//

import SwiftUI

/// FA26 `header` component: mesh-gradient background with rounded bottom corners, the
/// "CourseGrab" title bar with the settings gear, and a caller-provided search row.
/// While `isRefreshing`, the wiggling bell is shown above the title bar (the `loading` variant).
struct CourseGrabHeaderView<SearchRow: View>: View {

    // MARK: - Properties

    let isRefreshing: Bool
    @ObservedObject var bellAnimation: BellAnimationViewModel
    let onSettingsTapped: () -> Void
    @ViewBuilder let searchRow: () -> SearchRow

    // MARK: - UI

    var body: some View {
        VStack(spacing: Constants.Header.spacing) {
            if isRefreshing {
                refreshingBell
            }
            titleBar
            searchRow()
        }
        .padding(.top, Constants.Header.topPadding)
        .padding(.horizontal, Constants.Header.horizontalPadding)
        .padding(.bottom, Constants.Header.bottomPadding)
        .frame(maxWidth: .infinity)
        .background(background)
        .animation(.easeInOut, value: isRefreshing)
    }

    private var background: some View {
        HeaderBackgroundView()
            .clipShape(BottomRoundedRectangle(radius: Constants.Radius.header))
            .ignoresSafeArea(edges: .top)
    }

    private var refreshingBell: some View {
        BellView(width: Constants.Header.refreshingBellSize, animation: bellAnimation)
            .transition(.scale.combined(with: .opacity))
    }

    private var titleBar: some View {
        HStack {
            HStack(spacing: Constants.Header.titleSpacing) {
                if !isRefreshing {
                    Constants.Images.logoBell
                        .resizable()
                        .scaledToFit()
                        .frame(width: Constants.Header.logoSize.width, height: Constants.Header.logoSize.height)
                }
                Text("CourseGrab")
                    .font(Constants.Fonts.headerTitle)
                    .foregroundStyle(Constants.Colors.white)
            }
            Spacer()
            settingsButton
        }
    }

    private var settingsButton: some View {
        Button(action: onSettingsTapped) {
            Constants.Images.settings
                .resizable()
                .scaledToFit()
                .frame(width: Constants.Header.settingsIconSize, height: Constants.Header.settingsIconSize)
        }
        .buttonStyle(.scale)
        .accessibilityLabel("Settings")
    }

}

/// The capsule search field used in the header (placeholder on Home, live field on Search).
struct HeaderSearchFieldStyle: ViewModifier {

    // MARK: - UI

    func body(content: Content) -> some View {
        content
            .padding(.horizontal, Constants.Header.searchHorizontalPadding)
            .padding(.vertical, Constants.Header.searchVerticalPadding)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Capsule().fill(Constants.Colors.lightGray))
            .shadow(
                color: Constants.Shadow.dropColor,
                radius: Constants.Shadow.searchRadius,
                x: 0,
                y: Constants.Shadow.searchY
            )
    }

}

extension View {

    func headerSearchFieldStyle() -> some View {
        modifier(HeaderSearchFieldStyle())
    }

}

#Preview {
    VStack {
        CourseGrabHeaderView(isRefreshing: false, bellAnimation: BellAnimationViewModel(), onSettingsTapped: {}) {
            HStack(spacing: Constants.Header.searchIconSpacing) {
                Constants.Images.search
                Text("Search for a course...")
                    .font(Constants.Fonts.h4)
                    .foregroundStyle(Constants.Colors.darkGray)
            }
            .headerSearchFieldStyle()
        }
        Spacer()
    }
}
