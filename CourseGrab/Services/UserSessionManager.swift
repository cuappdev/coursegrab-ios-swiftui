//
//  UserSessionManager.swift
//  CourseGrab
//
//  Created by jiwon jeong on 3/27/26.
//

import Combine
import FirebaseAuth
import Foundation
import GoogleSignIn

enum SessionRestoreResult {
    case success
    case needsSignIn
    case invalidEmail
    case error(String)
}

class UserSessionManager: ObservableObject {

    // MARK: - Singleton

    static let shared = UserSessionManager()

    // MARK: - Published Properties

    @Published var isAuthenticated: Bool = false

    @Published var displayName: String? {
        didSet {
            if let displayName {
                KeychainManager.shared.save(displayName, forKey: "displayName")
            } else {
                KeychainManager.shared.delete(forKey: "displayName")
            }
        }
    }

    @Published var email: String? {
        didSet {
            if let email {
                KeychainManager.shared.save(email, forKey: "email")
            } else {
                KeychainManager.shared.delete(forKey: "email")
            }
        }
    }

    @Published var googleToken: String? {
        didSet {
            if let googleToken {
                KeychainManager.shared.save(googleToken, forKey: "googleToken")
            } else {
                KeychainManager.shared.delete(forKey: "googleToken")
            }
        }
    }

    // Session token from CourseGrab backend
    @Published var sessionToken: String? {
        didSet {
            if let sessionToken {
                KeychainManager.shared.save(sessionToken, forKey: "sessionToken")
            } else {
                KeychainManager.shared.delete(forKey: "sessionToken")
            }
        }
    }

    @Published var updateToken: String? {
        didSet {
            if let updateToken {
                KeychainManager.shared.save(updateToken, forKey: "updateToken")
            } else {
                KeychainManager.shared.delete(forKey: "updateToken")
            }
        }
    }

    // MARK: - Private

    private var authStateHandle: AuthStateDidChangeListenerHandle?

    // MARK: - Init

    private init() {
        // Restore from Keychain on launch
        self.displayName = KeychainManager.shared.get(forKey: "displayName")
        self.email = KeychainManager.shared.get(forKey: "email")
        self.googleToken = KeychainManager.shared.get(forKey: "googleToken")
        self.sessionToken = KeychainManager.shared.get(forKey: "sessionToken")
        self.updateToken = KeychainManager.shared.get(forKey: "updateToken")

        authStateHandle = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            guard let self else { return }
            DispatchQueue.main.async {
                self.isAuthenticated = user != nil
            }
        }
    }

    // MARK: - Session Functions

    func restorePreviousSession(completion: @escaping (SessionRestoreResult) -> Void) {
        GIDSignIn.sharedInstance.restorePreviousSignIn { [weak self] user, error in
            guard let self else {
                completion(.error("Session manager deallocated"))
                return
            }

            if let error {
                print("Failed to restore Google Sign-In: \(error.localizedDescription)")
                completion(.needsSignIn)
                return
            }

            guard let user else {
                completion(.needsSignIn)
                return
            }

            guard let email = user.profile?.email,
                  self.isValidCornellEmail(email) else {
                self.logout()
                completion(.invalidEmail)
                return
            }

            self.displayName = user.profile?.name
            self.email = user.profile?.email

            // Restore Firebase session
            guard let idToken = user.idToken?.tokenString else {
                completion(.needsSignIn)
                return
            }

            let credential = GoogleAuthProvider.credential(
                withIDToken: idToken,
                accessToken: user.accessToken.tokenString
            )

            Auth.auth().signIn(with: credential) { [weak self] _, error in
                guard let self else { return }
                if let error {
                    print("Firebase sign-in failed: \(error.localizedDescription)")
                    completion(.needsSignIn)
                    return
                }
                self.googleToken = idToken
                // Backend session init would go here via NetworkManager
                completion(.success)
            }
        }
    }

    func logout() {
        displayName = nil
        email = nil
        googleToken = nil
        sessionToken = nil
        updateToken = nil
        GIDSignIn.sharedInstance.signOut()
        try? Auth.auth().signOut()
    }

    // MARK: - Helpers

    private func isValidCornellEmail(_ email: String) -> Bool {
        let domain = email.split(separator: "@").last
        return domain == "cornell.edu" || email == "appstoreappdev@gmail.com"
    }

}
