//
//  Color+Hex.swift
//  CourseGrab
//
//  Created by jiwon jeong on 10/18/26.
//

import SwiftUI

extension Color {

    /// Creates an sRGB color from a 24-bit hex literal such as `0x47C753`.
    init(hex: UInt32, opacity: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xFF) / 255,
            green: Double((hex >> 8) & 0xFF) / 255,
            blue: Double(hex & 0xFF) / 255,
            opacity: opacity
        )
    }

}
