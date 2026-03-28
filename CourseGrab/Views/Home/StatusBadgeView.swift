//
//  StatusBadgeView.swift
//  CourseGrab
//
//  Created by jiwon jeong on 3/27/26.
//

import SwiftUI

struct StatusBadgeView: View {

    let status: Status

    var body: some View {
        switch status {
        case .open:
            Circle()
                .fill(Constants.Colors.green)
        case .closed:
            RoundedRectangle(cornerRadius: 8)
                .fill(Constants.Colors.ruby)
        case .waitlist:
            Triangle()
                .fill(Constants.Colors.yellow)
        }
    }
}

// MARK: - Triangle Shape

private struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}
