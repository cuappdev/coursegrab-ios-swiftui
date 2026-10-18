//
//  StopTrackingConfirmationView.swift
//  CourseGrab
//
//  Created by jiwon jeong on 10/18/26.
//

import SwiftUI

/// FA26 "Cancel tracking" modal: centered card over a 25% black scrim.
struct StopTrackingConfirmationView: View {

    // MARK: - Properties

    let courseCode: String
    let onConfirm: () -> Void
    let onCancel: () -> Void

    // MARK: - UI

    var body: some View {
        ZStack {
            scrim
            card
        }
    }

    private var scrim: some View {
        Constants.Colors.scrim
            .ignoresSafeArea()
            .onTapGesture(perform: onCancel)
            .accessibilityHidden(true)
    }

    private var card: some View {
        VStack(spacing: Constants.Modal.spacing) {
            Constants.Images.trackingConfirm
                .resizable()
                .scaledToFit()
                .frame(width: Constants.Modal.imageSize, height: Constants.Modal.imageSize)
            Text("Are you sure you want to stop tracking \(courseCode)?")
                .font(Constants.Fonts.dialog)
                .lineSpacing(Constants.Modal.lineSpacing)
                .multilineTextAlignment(.center)
                .foregroundStyle(Constants.Colors.black)
                .fixedSize(horizontal: false, vertical: true)
            buttons
        }
        .padding(.horizontal, Constants.Modal.horizontalPadding)
        .padding(.top, Constants.Modal.topPadding)
        .padding(.bottom, Constants.Modal.bottomPadding)
        .frame(width: Constants.Modal.width)
        .background(
            RoundedRectangle(cornerRadius: Constants.Radius.modal, style: .continuous)
                .fill(Constants.Colors.white)
        )
        .shadow(
            color: Constants.Shadow.modalColor,
            radius: Constants.Shadow.modalRadius,
            x: 0,
            y: Constants.Shadow.modalY
        )
    }

    private var buttons: some View {
        VStack(spacing: Constants.Modal.buttonSpacing) {
            Button(action: onConfirm) {
                Text("STOP TRACKING")
                    .font(Constants.Fonts.label)
                    .foregroundStyle(Constants.Colors.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: Constants.Modal.buttonHeight)
                    .background(
                        RoundedRectangle(cornerRadius: Constants.Radius.button)
                            .fill(Constants.Colors.black)
                    )
            }
            .buttonStyle(.scale)

            Button(action: onCancel) {
                Text("CANCEL")
                    .font(Constants.Fonts.label)
                    .foregroundStyle(Constants.Colors.cancelGray)
                    .frame(maxWidth: .infinity)
                    .frame(height: Constants.Modal.buttonHeight)
                    .contentShape(Rectangle())
            }
            .buttonStyle(.scale)
        }
    }

}

#Preview {
    StopTrackingConfirmationView(courseCode: "HD 4790", onConfirm: {}, onCancel: {})
}
