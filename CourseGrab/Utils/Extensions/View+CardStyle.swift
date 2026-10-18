//
//  View+CardStyle.swift
//  CourseGrab
//
//  Created by jiwon jeong on 10/18/26.
//

import SwiftUI

/// FA26 surface: white fill, 0.5pt gray hairline, rounded corners and the drop shadow.
struct CardStyleModifier: ViewModifier {

    // MARK: - Properties

    let cornerRadius: CGFloat

    // MARK: - UI

    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .fill(Constants.Colors.white)
            )
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .stroke(Constants.Colors.gray, lineWidth: Constants.Border.hairline)
            )
            .shadow(
                color: Constants.Shadow.dropColor,
                radius: Constants.Shadow.dropRadius,
                x: 0,
                y: Constants.Shadow.dropY
            )
    }

}

extension View {

    func cardStyle(cornerRadius: CGFloat = Constants.Radius.card) -> some View {
        modifier(CardStyleModifier(cornerRadius: cornerRadius))
    }

}
