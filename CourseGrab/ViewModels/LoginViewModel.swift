//
//  LoginViewModel.swift
//  CourseGrab
//
//  Created by jiwon jeong on 3/27/26.
//

import GoogleSignIn
import FirebaseAuth
import SwiftUI
import Combine

@MainActor
class LoginViewModel: ObservableObject {

    // MARK: - Properties

    @Published var didPresentError: Bool = false
    @Published var errorText: String = ""
    @Published var isLoading: Bool = false

    // MARK: - Functions

    func googleSignIn(success: @escaping (_ email: String, _ name: String) -> Void) {
        guard let presentingViewController = (UIApplication.shared.connectedScenes.first as?
            UIWindowScene)?.windows.first?.rootViewController else { return }

        isLoading = true

        Task {
            // Keep the spinner up for the whole flow — Google sheet, Firebase
            // sign-in, and backend session init — so the login screen doesn't sit
            // idle while the session is being established. Home appears (via the
            // `isLoggedIn` gate) the moment the session is ready.
            defer { isLoading = false }
            do {
                let result = try await GIDSignIn.sharedInstance.signIn(
                    withPresenting: presentingViewController
                )

                let user = result.user
                guard let email = user.profile?.email else { return }

                guard email.hasSuffix("@cornell.edu") || email == "appstoreappdev@gmail.com" else {
                    GIDSignIn.sharedInstance.signOut()
                    didPresentError = true
                    errorText = "Please sign in with a Cornell email"
                    return
                }

                guard let idToken = user.idToken?.tokenString else { return }
                let accessToken = user.accessToken.tokenString

                // Populate session identity BEFORE Firebase sign-in. The Firebase
                // auth-state listener flips `isAuthenticated` the instant sign-in
                // completes, which renders Home and triggers `refreshSessionIfNeeded`.
                // If `googleToken` weren't set yet, that path would log us straight
                // back out — the "flash then return to login" race.
                UserSessionManager.shared.googleToken = idToken
                UserSessionManager.shared.displayName = user.profile?.name
                UserSessionManager.shared.email = email

                let credential = GoogleAuthProvider.credential(
                    withIDToken: idToken,
                    accessToken: accessToken
                )

                try await Auth.auth().signIn(with: credential)

                await UserSessionManager.shared.initializeSession()

                success(email, user.profile?.name ?? "")

            } catch {
                didPresentError = true
                errorText = error.localizedDescription
            }
        }
    }

}
