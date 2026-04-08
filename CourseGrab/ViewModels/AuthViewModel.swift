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
        // Initial value
        isAuthenticated = session.isAuthenticated

        // Keep in sync
        session.$isAuthenticated
            .sink { [weak self] value in
                self?.isAuthenticated = value
            }
            .store(in: &cancellables)
    }

    // MARK: - Actions

    func restoreSession() {
        session.restorePreviousSession { _ in
            // nothing needed
            // Firebase listener updates isAuthenticated automatically
        }
    }

    func logout() {
        session.logout()
    }
}
