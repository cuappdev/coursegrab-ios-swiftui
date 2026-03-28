//
//  SearchDetailCardView.swift
//  CourseGrab
//
//  Created by jiwon jeong on 3/27/26.
//

import SwiftUI

struct SearchDetailCardView: View {

    // MARK: - Properties

    let course: Course

    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(course.displayTitle)
                .font(Constants.Fonts.semibold16)
                .foregroundStyle(Constants.Colors.black)

            Text(course.instructors.joined(separator: ", "))
                .font(Constants.Fonts.medium14)
                .foregroundStyle(Constants.Colors.gray)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 4))
        .overlay(
            RoundedRectangle(cornerRadius: 4)
                .stroke(Constants.Colors.border, lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.1), radius: 4)
        .padding(.horizontal, Constants.Padding.screenHorizontal)
    }

}
