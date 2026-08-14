//
//  AuthViewModel.swift
//  CourseGrab
//
//  Created by jiwon jeong on 4/8/26.
//

import SwiftUI
import Combine

@MainActor
class AuthViewModel: ObservableObject {

    // MARK: - Published

    @Published var isAuthenticated: Bool = false

    // MARK: - Private

    private let session = UserSessionManager.shared
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Init

    init() {
        // Gate the UI on a fully-established session (Firebase user + backend
        // session token), not just Firebase auth state. This prevents Home from
        // rendering before the backend session exists and bouncing back to login.
        isAuthenticated = session.isLoggedIn

        // Keep in sync
        session.$isLoggedIn
            .sink { [weak self] value in
                self?.isAuthenticated = value
            }
            .store(in: &cancellables)
    }

    // MARK: - Actions

    func restoreSession() {
        session.restorePreviousSession { [session] result in
            // On a successful Google/Firebase restore, make sure we also hold a
            // valid backend session. Since the UI now gates on `isLoggedIn`
            // (which requires a session token), establish/refresh it here so a
            // returning user lands on Home instead of being stuck on Login.
            if case .success = result {
                Task { await session.refreshSessionIfNeeded() }
            }
        }
    }

    func logout() {
        session.logout()
    }
}
