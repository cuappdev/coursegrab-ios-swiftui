//
//  GoogleSignInButtonView.swift
//  CourseGrab
//
//  Created by jiwon jeong on 3/27/26.
//

import GoogleSignIn
import SwiftUI

struct GoogleSignInButtonView: UIViewRepresentable {

    // MARK: - Properties

    let viewModel: LoginViewModel

    // MARK: - UIViewRepresentable

    func makeUIView(context: Context) -> GIDSignInButton {
        let button = GIDSignInButton()
        button.style = .wide
        button.addTarget(
            context.coordinator,
            action: #selector(Coordinator.tapped),
            for: .touchUpInside
        )
        return button
    }

    func updateUIView(_ uiView: GIDSignInButton, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(viewModel: viewModel)
    }

    // MARK: - Coordinator

    class Coordinator: NSObject {
        let viewModel: LoginViewModel
        init(viewModel: LoginViewModel) { self.viewModel = viewModel }

        @objc func tapped() {
            viewModel.googleSignIn { _, _ in
                // UserSessionManager.isAuthenticated fires via Firebase listener
                // ContentView reacts automatically
            }
        }
    }

}
