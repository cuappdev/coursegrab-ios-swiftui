//
//  ScaleButtonStyle.swift
//  CourseGrab
//
//  Created by jiwon jeong on 10/18/26.
//

import SwiftUI

/// Shared press feedback: a slight scale-down and dim while pressed.
struct ScaleButtonStyle: ButtonStyle {

    // MARK: - UI

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? Constants.Interaction.pressedScale : 1)
            .opacity(configuration.isPressed ? Constants.Interaction.pressedOpacity : 1)
            .animation(.easeOut(duration: Constants.Interaction.pressDuration), value: configuration.isPressed)
    }

}

extension ButtonStyle where Self == ScaleButtonStyle {

    static var scale: ScaleButtonStyle { ScaleButtonStyle() }

}
