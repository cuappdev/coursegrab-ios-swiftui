//
//  GoogleSignInButtonView.swift
//  CourseGrab
//
//  Created by jiwon jeong on 3/27/26.
//

import SwiftUI

/// FA26 "Sign in with Google" button: white surface, radius 8, the multicolor "G"
/// and the required "Sign in with Google" label (Google branding guidelines).
struct GoogleSignInButtonView: View {

    // MARK: - Properties

    let viewModel: LoginViewModel

    // MARK: - UI

    var body: some View {
        Button {
            viewModel.googleSignIn { _, _ in
                // UserSessionManager.isAuthenticated fires via the Firebase
                // listener; ContentView reacts automatically.
            }
        } label: {
            HStack(spacing: Constants.Splash.googleSpacing) {
                Constants.Images.googleLogo
                    .resizable()
                    .scaledToFit()
                    .frame(width: Constants.Splash.googleLogoSize, height: Constants.Splash.googleLogoSize)
                Text("Sign in with Google")
                    .font(Constants.Fonts.googleButton)
                    .tracking(Constants.Splash.googleTracking)
                    .foregroundStyle(Constants.Colors.googleText)
            }
            .padding(.horizontal, Constants.Splash.googleHorizontalPadding)
            .padding(.vertical, Constants.Splash.googleVerticalPadding)
            .background(
                RoundedRectangle(cornerRadius: Constants.Radius.button, style: .continuous)
                    .fill(Constants.Colors.white)
            )
            .shadow(
                color: Constants.Splash.googleShadowColor,
                radius: Constants.Splash.googleShadowRadius,
                x: 0,
                y: Constants.Splash.googleShadowY
            )
        }
        .buttonStyle(.scale)
    }

}

#Preview {
    GoogleSignInButtonView(viewModel: LoginViewModel())
        .padding()
        .background(Constants.Colors.background)
}
