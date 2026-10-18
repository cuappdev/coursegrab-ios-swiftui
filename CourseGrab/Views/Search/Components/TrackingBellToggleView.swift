//
//  TrackingBellToggleView.swift
//  CourseGrab
//
//  Created by jiwon jeong on 10/18/26.
//

import SwiftUI

/// FA26 `tracking?` control: 28pt bell that is black / ringing when tracked, outlined when not.
struct TrackingBellToggleView: View {

    // MARK: - Properties

    let isTracking: Bool
    let onToggle: () -> Void

    // MARK: - UI

    var body: some View {
        Button(action: onToggle) {
            (isTracking ? Constants.Images.trackingOn : Constants.Images.trackingOff)
                .resizable()
                .scaledToFit()
                .frame(width: Constants.Detail.trackToggleSize, height: Constants.Detail.trackToggleSize)
                .contentShape(Circle())
        }
        .buttonStyle(.scale)
        .accessibilityLabel(isTracking ? "Stop tracking" : "Track")
        .accessibilityAddTraits(isTracking ? .isSelected : [])
    }

}

#Preview {
    HStack {
        TrackingBellToggleView(isTracking: true, onToggle: {})
        TrackingBellToggleView(isTracking: false, onToggle: {})
    }
}
