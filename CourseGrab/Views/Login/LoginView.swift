//
//  LoginView.swift
//  CourseGrab
//
//  Created by jiwon jeong on 3/27/26.
//

import GoogleSignIn
import SwiftUI

struct LoginView: View {

    // MARK: - Properties

    @StateObject private var viewModel = LoginViewModel()

    // MARK: - Body

    var body: some View {
        ZStack {
            Color(Constants.Colors.black)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer()

                Text("Welcome to")
                    .foregroundStyle(.white)
                    .font(Constants.Fonts.medium27)

                Text("CourseGrab")
                    .foregroundStyle(.white)
                    .font(Constants.Fonts.bold40)
                    .padding(.top, 8)

                Constants.Images.courseGrabLogo
                    .resizable()
                    .scaledToFit()
                    .frame(width: 143, height: 140)
                    .padding(.top, 44)

                Spacer()

                if viewModel.didPresentError {
                    Text(viewModel.errorText)
                        .foregroundStyle(Constants.Colors.ruby)
                        .font(Constants.Fonts.regular14)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, Constants.Padding.screenHorizontal)
                        .padding(.bottom, 12)
                }

                GoogleSignInButtonView(viewModel: viewModel)
                    .frame(width: 240, height: 48)
                    .padding(.bottom, 60)
            }

            if viewModel.isLoading {
                Color.black.opacity(0.3).ignoresSafeArea()
                ProgressView()
                    .tint(.white)
                    .scaleEffect(1.5)
            }
        }
    }

}

// MARK: - GoogleSignInButtonView

private struct GoogleSignInButtonView: UIViewRepresentable {

    let viewModel: LoginViewModel

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
