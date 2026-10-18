//
//  HeaderBackgroundView.swift
//  CourseGrab
//
//  Created by jiwon jeong on 10/18/26.
//

import SwiftUI

/// FA26 header / splash background: `#2F2F2F` with the 4×4 mesh shader at 50% (plus-darker).
/// `MeshGradient` requires iOS 18; earlier systems get a layered-gradient approximation.
struct HeaderBackgroundView: View {

    // MARK: - UI

    var body: some View {
        ZStack {
            Constants.Colors.background
            meshLayer
                .opacity(Constants.Header.meshOpacity)
                .blendMode(.plusDarker)
        }
        .compositingGroup()
    }

    @ViewBuilder
    private var meshLayer: some View {
        if #available(iOS 18.0, *) {
            MeshGradient(
                width: 4,
                height: 4,
                points: Constants.Header.meshPoints,
                colors: Constants.Colors.headerMesh
            )
        } else {
            fallbackLayer
        }
    }

    /// Approximates the mesh: top-row colors left→right, faded into the bottom-row colors.
    private var fallbackLayer: some View {
        ZStack {
            LinearGradient(
                colors: Array(Constants.Colors.headerMesh.suffix(4)),
                startPoint: .leading,
                endPoint: .trailing
            )
            LinearGradient(
                colors: Array(Constants.Colors.headerMesh.prefix(4)),
                startPoint: .leading,
                endPoint: .trailing
            )
            .mask(
                LinearGradient(
                    colors: [.black, .black.opacity(0.5), .clear],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
        }
    }

}

/// Rectangle with only the bottom corners rounded (`UnevenRoundedRectangle` is iOS 17+).
struct BottomRoundedRectangle: Shape {

    // MARK: - Properties

    let radius: CGFloat

    // MARK: - Functions

    func path(in rect: CGRect) -> Path {
        let radius = min(radius, rect.width / 2, rect.height / 2)
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - radius))
        path.addArc(
            center: CGPoint(x: rect.maxX - radius, y: rect.maxY - radius),
            radius: radius,
            startAngle: .degrees(0),
            endAngle: .degrees(90),
            clockwise: false
        )
        path.addLine(to: CGPoint(x: rect.minX + radius, y: rect.maxY))
        path.addArc(
            center: CGPoint(x: rect.minX + radius, y: rect.maxY - radius),
            radius: radius,
            startAngle: .degrees(90),
            endAngle: .degrees(180),
            clockwise: false
        )
        path.closeSubpath()
        return path
    }

}

#Preview {
    HeaderBackgroundView()
        .frame(height: 200)
        .clipShape(BottomRoundedRectangle(radius: Constants.Radius.header))
}
