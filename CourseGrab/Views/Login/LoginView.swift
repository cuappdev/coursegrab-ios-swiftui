//
//  LoginView.swift
//  CourseGrab
//
//  Created by jiwon jeong on 3/27/26.
//

import GoogleSignIn
import SwiftUI

/// FA26 Splash / sign-in: mesh background, "Welcome to CourseGrab", the wiggling bell
/// and the Google sign-in button.
struct LoginView: View {

    // MARK: - Properties

    @StateObject private var viewModel = LoginViewModel()
    @StateObject private var bellAnimation = BellAnimationViewModel()

    // MARK: - UI

    var body: some View {
        ZStack {
            HeaderBackgroundView()
                .ignoresSafeArea()

            VStack(spacing: Constants.Splash.spacing) {
                hero
                signIn
            }
            .padding(.horizontal, Constants.Padding.screenHorizontal)

            if viewModel.isLoading {
                loadingOverlay
            }
        }
        .onAppear { bellAnimation.setAnimating(true) }
        .onDisappear { bellAnimation.setAnimating(false) }
    }

    private var hero: some View {
        VStack(spacing: Constants.Splash.heroSpacing) {
            VStack(spacing: Constants.Splash.titleSpacing) {
                Text("Welcome to")
                    .font(Constants.Fonts.splashWelcome)
                    .tracking(Constants.Splash.welcomeTracking)
                Text("CourseGrab")
                    .font(Constants.Fonts.splashTitle)
            }
            .foregroundStyle(Constants.Colors.white)

            BellView(width: Constants.Splash.bellSize, animation: bellAnimation)
        }
    }

    private var signIn: some View {
        VStack(spacing: Constants.Splash.errorBottomPadding) {
            if viewModel.didPresentError {
                Text(viewModel.errorText)
                    .font(Constants.Fonts.body)
                    .foregroundStyle(Constants.Colors.red)
                    .multilineTextAlignment(.center)
            }
            GoogleSignInButtonView(viewModel: viewModel)
        }
    }

    private var loadingOverlay: some View {
        ZStack {
            Constants.Colors.scrim
                .ignoresSafeArea()
            ProgressView()
                .tint(Constants.Colors.white)
                .scaleEffect(Constants.Splash.loadingScale)
        }
    }

}

#Preview {
    LoginView()
}
