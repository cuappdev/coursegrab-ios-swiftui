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
            do {
                await UserSessionManager.shared.refreshSessionIfNeeded()
                guard UserSessionManager.shared.isAuthenticated else {
                    isLoading = false
                    return
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
            isLoading = false
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
