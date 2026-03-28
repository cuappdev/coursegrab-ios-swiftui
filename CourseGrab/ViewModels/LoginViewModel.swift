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
            do {
                let result = try await GIDSignIn.sharedInstance.signIn(
                    withPresenting: presentingViewController
                )

                isLoading = false

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

                let credential = GoogleAuthProvider.credential(
                    withIDToken: idToken,
                    accessToken: accessToken
                )

                try await Auth.auth().signIn(with: credential)

                UserSessionManager.shared.googleToken = idToken
                UserSessionManager.shared.displayName = user.profile?.name
                UserSessionManager.shared.email = email

                await UserSessionManager.shared.initializeSession()

                success(email, user.profile?.name ?? "")

            } catch {
                isLoading = false
                didPresentError = true
                errorText = error.localizedDescription
            }
        }
    }

}
