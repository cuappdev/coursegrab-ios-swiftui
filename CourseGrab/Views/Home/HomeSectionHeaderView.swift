//
//  HomeSectionHeaderView.swift
//  CourseGrab
//
//  Created by jiwon jeong on 3/27/26.
//

import SwiftUI

struct HomeSectionHeaderView: View {

    // MARK: - Properties

    let count: Int
    let isAvailable: Bool

    // MARK: - Body

    var body: some View {
        HStack {
            Text("\(count) \(isAvailable ? "Available" : "Awaiting")")
                .font(Constants.Fonts.semibold20)
                .foregroundStyle(isAvailable ? Constants.Colors.green : Constants.Colors.black)
            Spacer()
        }
        .padding(.horizontal, Constants.Padding.screenHorizontal)
        .padding(.vertical, 6)
        .background(Constants.Colors.white)
    }

}
