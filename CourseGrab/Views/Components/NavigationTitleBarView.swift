//
//  NavigationTitleBarView.swift
//  CourseGrab
//
//  Created by jiwon jeong on 10/18/26.
//

import SwiftUI

/// FA26 in-content navigation row: centered H1 title with a leading back caret.
struct NavigationTitleBarView: View {

    // MARK: - Properties

    let title: String
    let onBack: () -> Void

    // MARK: - UI

    var body: some View {
        ZStack {
            titleLabel
            HStack {
                backButton
                Spacer()
            }
        }
        .frame(height: Constants.TitleBar.height)
    }

    private var titleLabel: some View {
        Text(title)
            .font(Constants.Fonts.h1)
            .foregroundStyle(Constants.Colors.black)
            .lineLimit(1)
            .padding(.horizontal, Constants.TitleBar.backIconSize)
    }

    private var backButton: some View {
        Button(action: onBack) {
            Constants.Images.leftCaret
                .resizable()
                .scaledToFit()
                .frame(width: Constants.TitleBar.backIconSize, height: Constants.TitleBar.backIconSize)
        }
        .buttonStyle(.scale)
        .accessibilityLabel("Back")
    }

}

#Preview {
    NavigationTitleBarView(title: "Settings", onBack: {})
        .padding()
}
