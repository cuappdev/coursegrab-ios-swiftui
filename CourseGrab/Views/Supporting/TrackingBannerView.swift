//
//  TrackingBannerView.swift
//  CourseGrab
//
//  Created by jiwon jeong on 3/27/26.
//

import SwiftUI

struct TrackingBannerView: View {

    // MARK: - Properties

    let message: String

    // MARK: - UI

    var body: some View {
        Text(message)
            .font(Constants.Fonts.banner)
            .foregroundStyle(Constants.Colors.black)
            .multilineTextAlignment(.center)
            .padding(.horizontal, Constants.Banner.horizontalPadding)
            .padding(.vertical, Constants.Banner.verticalPadding)
            .frame(maxWidth: .infinity)
            .cardStyle(cornerRadius: Constants.Radius.button)
            .padding(.horizontal, Constants.Padding.screenHorizontal)
            .padding(.top, Constants.Banner.topPadding)
    }

}

#Preview {
    TrackingBannerView(message: "You are now tracking ANTHR 1400 LEC 001")
}
