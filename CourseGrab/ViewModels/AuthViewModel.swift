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
        isAuthenticated = session.isLoggedIn

        session.$isLoggedIn
            .sink { [weak self] value in
                self?.isAuthenticated = value
            }
            .store(in: &cancellables)
    }

    // MARK: - Actions

    func restoreSession() {
        session.restorePreviousSession { [session] result in
            if case .success = result {
                Task { await session.refreshSessionIfNeeded() }
            }
        }
    }

    func logout() {
        session.logout()
    }
}
