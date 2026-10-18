//
//  SearchResultsHeaderView.swift
//  CourseGrab
//
//  Created by jiwon jeong on 3/27/26.
//

import SwiftUI

/// FA26 "N Results" heading above the search result cards.
struct SearchResultsHeaderView: View {

    // MARK: - Properties

    let count: Int

    // MARK: - UI

    var body: some View {
        Text("\(count) Result\(count == 1 ? "" : "s")")
            .font(Constants.Fonts.h1)
            .foregroundStyle(Constants.Colors.black)
            .frame(maxWidth: .infinity, alignment: .leading)
    }

}

#Preview {
    SearchResultsHeaderView(count: 50)
        .padding()
}
