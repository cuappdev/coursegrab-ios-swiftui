//
//  Haptics.swift
//  CourseGrab
//
//  Created by jiwon jeong on 10/18/26.
//

import UIKit

/// Single entry point for tactile feedback.
final class Haptics {

    enum Feedback {
        case light
        case medium
        case success
        case error
    }

    // MARK: - Properties

    static let shared = Haptics()

    private init() {}

    // MARK: - Functions

    func play(_ feedback: Feedback) {
        switch feedback {
        case .light:
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        case .medium:
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        case .success:
            UINotificationFeedbackGenerator().notificationOccurred(.success)
        case .error:
            UINotificationFeedbackGenerator().notificationOccurred(.error)
        }
    }

}
