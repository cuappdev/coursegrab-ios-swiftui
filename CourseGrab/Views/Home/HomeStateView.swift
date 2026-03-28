//
//  HomeStateView.swift
//  CourseGrab
//
//  Created by jiwon jeong on 3/27/26.
//

import SwiftUI

struct HomeStateView: View {

    // MARK: - Properties

    let title: String
    let subtitle: String
    let status: Status

    // MARK: - Body

    var body: some View {
        VStack(spacing: 24) {
            StatusBadgeView(status: status)
                .frame(width: 60, height: 60)
            Text(title)
                .font(Constants.Fonts.medium20)
                .foregroundStyle(Constants.Colors.black)
            Text(subtitle)
                .font(Constants.Fonts.medium18)
                .foregroundStyle(Constants.Colors.lightGray)
        }
    }

}
