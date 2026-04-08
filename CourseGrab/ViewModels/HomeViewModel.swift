//
//  HomeViewModel.swift
//  CourseGrab
//
//  Created by jiwon jeong on 3/27/26.
//

import Combine
import Foundation

extension HomeView {

    @MainActor
    class ViewModel: ObservableObject {

        // MARK: - Properties

        @Published var availableSections: [CourseSection] = []
        @Published var awaitingSections: [CourseSection] = []
        @Published var isLoading: Bool = false
        @Published var hasError: Bool = false

        // MARK: - Computed

        var isEmpty: Bool {
            availableSections.isEmpty && awaitingSections.isEmpty
        }

        // MARK: - Functions

        func fetchTrackedSections() async {
            isLoading = true
            hasError = false
            defer { isLoading = false }

            do {
                let session = UserSessionManager.shared
                guard session.isAuthenticated, session.sessionToken != nil else { return }

                // Avoid refreshing immediately after Firebase restores auth but Google restore failed
                // (e.g. simulator/fresh install -> no Google credentials in keychain).
                if session.googleToken != nil {
                    await session.refreshSessionIfNeeded()
                }

                let sections = try await NetworkManager.shared.getAllTrackedSections()
                availableSections = sections.filter { $0.status == Status.open }
                awaitingSections = sections.filter { $0.status != Status.open }
            } catch {
                print("fetchTrackedSections failed: \(error)")
                if error.invalidatesUserSession {
                    UserSessionManager.shared.logout()
                } else {
                    hasError = true
                }
            }
        }

        func untrack(section: CourseSection) async {
            do {
                let updated = try await NetworkManager.shared.untrackSection(catalogNum: section.catalogNum)
                if updated.status == Status.open {
                    availableSections.removeAll { $0.catalogNum == updated.catalogNum }
                } else {
                    awaitingSections.removeAll { $0.catalogNum == updated.catalogNum }
                }
            } catch {
                print("Failed to untrack: \(error)")
                if error.invalidatesUserSession {
                    UserSessionManager.shared.logout()
                }
            }
        }

    }

}
