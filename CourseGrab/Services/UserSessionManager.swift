//
//  UserSessionManager.swift
//  CourseGrab
//
//  Created by jiwon jeong on 3/26/26.
//

import Combine
import FirebaseAuth
import Foundation
import GoogleSignIn

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

    @Published var deviceToken: String {
        didSet {
            KeychainManager.shared.save(deviceToken, forKey: "deviceToken")
        }
    }

    @Published var sessionExpiration: Date? {
        didSet {
            if let sessionExpiration {
                KeychainManager.shared.save(
                    ISO8601DateFormatter().string(from: sessionExpiration),
                    forKey: "sessionExpiration"
                )
            } else {
                KeychainManager.shared.delete(forKey: "sessionExpiration")
            }
        }
    }

    // MARK: - Private

    private var authStateHandle: AuthStateDidChangeListenerHandle?
    private var sessionInitTask: Task<Void, Never>?

    // MARK: - Init

    private init() {
        self.displayName = KeychainManager.shared.get(forKey: "displayName")
        self.email = KeychainManager.shared.get(forKey: "email")
        self.googleToken = KeychainManager.shared.get(forKey: "googleToken")
        self.sessionToken = KeychainManager.shared.get(forKey: "sessionToken")
        self.updateToken = KeychainManager.shared.get(forKey: "updateToken")
        self.deviceToken = KeychainManager.shared.get(forKey: "deviceToken") ?? ""
        if let expStr = KeychainManager.shared.get(forKey: "sessionExpiration") {
            self.sessionExpiration = ISO8601DateFormatter().date(from: expStr)
        }

        authStateHandle = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            guard let self else { return }
            DispatchQueue.main.async {
                self.isAuthenticated = user != nil
                // Keep profile fields in sync when Firebase restores a user
                if let user {
                    if self.email?.isEmpty ?? true, let firebaseEmail = user.email, !firebaseEmail.isEmpty {
                        self.email = firebaseEmail
                    }
                    if self.displayName?.isEmpty ?? true, let name = user.displayName, !name.isEmpty {
                        self.displayName = name
                    }
                }
            }
        }
    }

    // MARK: - Session Functions

    func initializeSession() async {
        guard let googleToken else { return }
        if let task = sessionInitTask {
            await task.value
            return
        }
        sessionInitTask = Task { [weak self] in
            guard let self else { return }
            self.debugSessionState("initializeSession (start)")
            do {
                let auth = try await NetworkManager.shared.initializeSession(googleToken: googleToken)
                self.sessionToken = auth.sessionToken
                self.updateToken = auth.updateToken
                self.sessionExpiration = auth.sessionExpiration
                self.debugSessionState("initializeSession (success)")
            } catch {
                print("Failed to initialize session: \(error)")
                self.debugSessionState("initializeSession (failed)")
                if error.invalidatesUserSession {
                    await MainActor.run { self.logout() }
                }
            }
            self.sessionInitTask = nil
        }
        await sessionInitTask?.value
    }

    func refreshSessionIfNeeded() async {
        debugSessionState("refreshSessionIfNeeded (start)")
        guard let expiration = sessionExpiration else {
            await initializeSession()
            return
        }
        if expiration <= Date() {
            do {
                let auth = try await NetworkManager.shared.updateSession()
                sessionToken = auth.sessionToken
                updateToken = auth.updateToken
                sessionExpiration = auth.sessionExpiration
                debugSessionState("refreshSessionIfNeeded (refreshed)")
            } catch {
                print("Failed to refresh session: \(error)")
                debugSessionState("refreshSessionIfNeeded (refresh failed)")
                await MainActor.run { logout() }
            }
        }
    }

    func restorePreviousSession(completion: @escaping (SessionRestoreResult) -> Void) {
        debugSessionState("restorePreviousSession (start)")
        GIDSignIn.sharedInstance.restorePreviousSignIn { [weak self] user, error in
            guard let self else {
                completion(.error("Session manager deallocated"))
                return
            }

            if let error {
                print("Failed to restore Google Sign-In: \(error.localizedDescription)")
                self.debugSessionState("restorePreviousSession (google restore failed)")
                completion(.needsSignIn)
                return
            }

            guard let user else {
                self.debugSessionState("restorePreviousSession (no user)")
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
            self.email = email

            guard let idToken = user.idToken?.tokenString else {
                self.debugSessionState("restorePreviousSession (missing idToken)")
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
                    self.debugSessionState("restorePreviousSession (firebase sign-in failed)")
                    completion(.needsSignIn)
                    return
                }
                self.googleToken = idToken
                Task {
                    await self.refreshSessionIfNeeded()
                }
                self.debugSessionState("restorePreviousSession (success)")
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
        sessionExpiration = nil
        deviceToken = ""
        GIDSignIn.sharedInstance.signOut()
        try? Auth.auth().signOut()
    }

    // MARK: - Device Token

    /// Called from AppDelegate whenever iOS issues or rotates the APNs device token.
    /// Persists the token locally and — if a session is already active — sends it to
    /// the backend immediately so push notifications stay functional after token rotation.
    @MainActor
    func updateDeviceToken(_ token: String) async {
        // No-op if the token hasn't actually changed, to avoid redundant network calls.
        guard token != deviceToken else { return }

        deviceToken = token

        // Only send to the backend if the user is already authenticated.
        // If not, the token will be included in the next `initializeSession()` call.
        guard isAuthenticated, sessionToken != nil else { return }

        do {
            try await NetworkManager.shared.sendDeviceToken(deviceToken: token)
        } catch {
            print("Failed to send device token to backend: \(error)")
        }
    }

    // MARK: - Helpers

    private func isValidCornellEmail(_ email: String) -> Bool {
        let domain = email.split(separator: "@").last
        return domain == "cornell.edu" || email == "appstoreappdev@gmail.com"
    }

    private func debugSessionState(_ label: String) {
        let now = Date()
        let exp = sessionExpiration
        let isExpired = exp.map { $0 <= now } ?? true

        print(
            """
            [SessionDebug] \(label)
              isAuthenticated=\(isAuthenticated)
              hasGoogleToken=\(googleToken != nil)
              hasSessionToken=\(sessionToken != nil)
              hasUpdateToken=\(updateToken != nil)
              expiration=\(exp?.description ?? "nil")
              isExpired=\(isExpired)
            """
        )
    }

}

enum SessionRestoreResult {
    case success
    case needsSignIn
    case invalidEmail
    case error(String)
}
