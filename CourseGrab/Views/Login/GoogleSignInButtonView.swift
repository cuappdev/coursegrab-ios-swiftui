//
//  GoogleSignInButtonView.swift
//  CourseGrab
//
//  Created by jiwon jeong on 3/27/26.
//

import SwiftUI

/// "Sign in with Google" button following Google's official branding guidelines:
/// white surface, 1pt neutral stroke, multicolor "G", and the required
/// "Sign in with Google" label. Rendered natively in SwiftUI (no legacy
/// `GIDSignInButton` widget) so it matches modern iOS design.
struct GoogleSignInButtonView: View {

    // MARK: - Properties

    let viewModel: LoginViewModel

    // Google-spec surface colors.
    private let surface = Color.white
    private let stroke = Color(red: 218/255, green: 220/255, blue: 224/255) // #dadce0
    private let label = Color(red: 60/255, green: 64/255, blue: 67/255)     // #3c4043

    // MARK: - Body

    var body: some View {
        Button {
            viewModel.googleSignIn { _, _ in
                // UserSessionManager.isAuthenticated fires via the Firebase
                // listener; ContentView reacts automatically.
            }
        } label: {
            HStack(spacing: 12) {
                Constants.Images.googleG
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)

                Text("Sign in with Google")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(label)
            }
            .frame(maxWidth: .infinity, minHeight: 48)
            .background(
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(surface)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .stroke(stroke, lineWidth: 1)
            )
        }
        .buttonStyle(GoogleSignInButtonStyle())
    }

}

/// Subtle press feedback that keeps the Google-spec look intact.
private struct GoogleSignInButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .opacity(configuration.isPressed ? 0.85 : 1)
            .animation(.easeOut(duration: 0.1), value: configuration.isPressed)
    }
}
