//
//  BellView.swift
//  CourseGrab
//
//  Created by jiwon jeong on 10/18/26.
//

import SwiftUI

/// The FA26 hero bell: body artwork plus a separately animated green clapper,
/// driven by a `BellAnimationViewModel`. Scales from the 243×236 Figma artboard.
struct BellView: View {

    // MARK: - Properties

    let width: CGFloat
    @ObservedObject var animation: BellAnimationViewModel

    private var scale: CGFloat { width / Constants.Bell.artboardSize.width }

    // MARK: - UI

    var body: some View {
        ZStack(alignment: .topLeading) {
            clapper
            Constants.Images.bellHeroBody
                .resizable()
                .scaledToFit()
                .frame(
                    width: Constants.Bell.artboardSize.width * scale,
                    height: Constants.Bell.artboardSize.height * scale
                )
        }
        .frame(
            width: Constants.Bell.artboardSize.width * scale,
            height: Constants.Bell.artboardSize.height * scale,
            alignment: .topLeading
        )
        .rotationEffect(animation.bellRotation)
        .accessibilityHidden(true)
    }

    private var clapper: some View {
        Circle()
            .fill(Constants.Colors.green)
            .frame(
                width: Constants.Bell.clapperDiameter * scale,
                height: Constants.Bell.clapperDiameter * scale
            )
            .offset(
                x: (Constants.Bell.clapperOrigin.x + animation.clapperOffset.width) * scale,
                y: (Constants.Bell.clapperOrigin.y + animation.clapperOffset.height) * scale
            )
    }

}

#Preview {
    BellView(width: Constants.Splash.bellSize, animation: BellAnimationViewModel())
        .padding()
        .background(Constants.Colors.background)
}
