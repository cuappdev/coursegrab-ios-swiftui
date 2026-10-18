//
//  BellAnimationViewModel.swift
//  CourseGrab
//
//  Created by jiwon jeong on 10/18/26.
//

import Combine
import SwiftUI

/// Animation-only state for the FA26 bell wiggle (splash loop and pull-to-refresh).
/// Replays the Figma keyframes with chained `withAnimation` steps because
/// `keyframeAnimator` is iOS 17+ and the app targets iOS 16.6.
@MainActor
final class BellAnimationViewModel: ObservableObject {

    // MARK: - Properties

    @Published private(set) var bellRotation: Angle = .zero
    @Published private(set) var clapperOffset: CGSize = .zero

    private var rotationTask: Task<Void, Never>?
    private var clapperTask: Task<Void, Never>?

    // MARK: - Functions

    /// Starts (or stops) a continuous wiggle loop.
    func setAnimating(_ isAnimating: Bool) {
        if isAnimating {
            start()
        } else {
            stop()
        }
    }

    func stop() {
        rotationTask?.cancel()
        clapperTask?.cancel()
        rotationTask = nil
        clapperTask = nil
        withAnimation(.easeOut(duration: Constants.Bell.resetDuration)) {
            bellRotation = .zero
            clapperOffset = .zero
        }
    }

    // MARK: - Private

    private func start() {
        rotationTask?.cancel()
        clapperTask?.cancel()
        let rotationKeyframes = Constants.Bell.rotationKeyframes.map { ($0.time, $0.radians) }
        let clapperKeyframes = Constants.Bell.clapperKeyframes.map { ($0.time, $0.offset) }
        rotationTask = Task { [weak self] in
            repeat {
                guard let self else { return }
                await self.play(rotationKeyframes) { [weak self] radians in
                    self?.bellRotation = .radians(radians)
                }
            } while !Task.isCancelled
        }
        clapperTask = Task { [weak self] in
            repeat {
                guard let self else { return }
                await self.play(clapperKeyframes) { [weak self] offset in
                    self?.clapperOffset = offset
                }
            } while !Task.isCancelled
        }
    }

    /// Animates through `keyframes` (fractions of the loop), then idles out the remainder of the loop.
    private func play<Value>(_ keyframes: [(Double, Value)], apply: @escaping (Value) -> Void) async {
        let loop = Constants.Bell.loopDuration
        var previousTime = 0.0
        for (time, value) in keyframes {
            let duration = (time - previousTime) * loop
            if duration > 0 {
                withAnimation(.easeInOut(duration: duration)) { apply(value) }
                try? await Task.sleep(nanoseconds: UInt64(duration * 1_000_000_000))
            } else {
                apply(value)
            }
            guard !Task.isCancelled else { return }
            previousTime = time
        }
        let remainder = (1 - previousTime) * loop
        try? await Task.sleep(nanoseconds: UInt64(remainder * 1_000_000_000))
    }

}
