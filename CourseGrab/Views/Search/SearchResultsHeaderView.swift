//
//  SearchResultsHeaderView.swift
//  CourseGrab
//
//  Created by jiwon jeong on 3/27/26.
//

import SwiftUI

struct SearchResultsHeaderView: View {

    // MARK: - Properties

    let count: Int

    // MARK: - Body

    var body: some View {
        HStack {
            Text("\(count) Result\(count == 1 ? "" : "s")")
                .font(Constants.Fonts.semibold20)
                .foregroundStyle(Constants.Colors.black)
            
            Spacer()
        }
        .padding(.horizontal, Constants.Padding.screenHorizontal)
        .padding(.vertical, 6)
        .background(Constants.Colors.white)
    }

}
