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

    // MARK: - Body

    var body: some View {
        Text(message)
            .font(Constants.Fonts.bold12)
            .foregroundStyle(Constants.Colors.black)
            .multilineTextAlignment(.center)
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity)
            .background(Constants.Colors.white)
            .clipShape(RoundedRectangle(cornerRadius: 5))
            .shadow(color: .black.opacity(0.15), radius: 4)
            .padding(.horizontal, Constants.Padding.screenHorizontal)
            .padding(.top, 8)
    }

}
