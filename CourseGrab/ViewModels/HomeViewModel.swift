//
//  HomeViewModel.swift
//  CourseGrab
//
//  Created by jiwon jeong on 3/27/26.
//

import Combine
import Foundation
import OSLog
import UIKit

extension HomeView {

    @MainActor
    class ViewModel: ObservableObject {

        // MARK: - Properties

        @Published var availableSections: [CourseSection] = []
        @Published var awaitingSections: [CourseSection] = []
        @Published var isLoading: Bool = false
        @Published var hasError: Bool = false
        /// True while a pull-to-refresh is in flight; drives the header bell animation.
        @Published private(set) var isRefreshing: Bool = false
        /// Section awaiting confirmation in the stop-tracking modal.
        @Published var sectionPendingUntrack: CourseSection?
        @Published var errorMessage: String?

        // MARK: - Computed

        var isEmpty: Bool {
            availableSections.isEmpty && awaitingSections.isEmpty
        }

        /// Open sections first, then closed / waitlisted.
        var trackedSections: [CourseSection] {
            availableSections + awaitingSections
        }

        var openCount: Int { availableSections.count }

        var closedCount: Int {
            awaitingSections.filter { $0.status == .closed }.count
        }

        var waitlistCount: Int {
            awaitingSections.filter { $0.status == .waitlist }.count
        }

        // MARK: - Functions

        func fetchTrackedSections(showsLoading: Bool = true) async {
            if showsLoading {
                isLoading = true
            }
            hasError = false
            defer { isLoading = false }
            do {
                await UserSessionManager.shared.refreshSessionIfNeeded()
                guard UserSessionManager.shared.isAuthenticated else { return }
                let sections = try await NetworkManager.shared.getAllTrackedSections()
                availableSections = sections.filter { $0.status == Status.open }
                awaitingSections = sections.filter { $0.status != Status.open }
            } catch {
                Logger.viewModels.error("fetchTrackedSections failed: \(error.localizedDescription, privacy: .public)")
                if error.invalidatesUserSession {
                    UserSessionManager.shared.logout()
                } else {
                    hasError = true
                }
            }
        }

        /// Pull-to-refresh: keeps the current content on screen and animates the header bell.
        func refresh() async {
            isRefreshing = true
            defer { isRefreshing = false }
            Haptics.shared.play(.light)
            await fetchTrackedSections(showsLoading: false)
        }

        func requestUntrack(_ section: CourseSection) {
            Haptics.shared.play(.light)
            sectionPendingUntrack = section
        }

        func cancelUntrack() {
            sectionPendingUntrack = nil
        }

        func confirmUntrack() {
            guard let section = sectionPendingUntrack else { return }
            sectionPendingUntrack = nil
            Task { await untrack(section: section) }
        }

        func untrack(section: CourseSection) async {
            do {
                let updated = try await NetworkManager.shared.untrackSection(catalogNum: section.catalogNum)
                availableSections.removeAll { $0.catalogNum == updated.catalogNum }
                awaitingSections.removeAll { $0.catalogNum == updated.catalogNum }
                Haptics.shared.play(.success)
            } catch {
                Logger.viewModels.error("untrack failed: \(error.localizedDescription, privacy: .public)")
                if error.invalidatesUserSession {
                    UserSessionManager.shared.logout()
                } else {
                    errorMessage = "Couldn't stop tracking \(section.displayCode). Please try again."
                }
            }
        }

        func copyPin(for section: CourseSection) {
            UIPasteboard.general.string = section.displayCatalogNum
            Haptics.shared.play(.success)
        }

        func openStudentCenter() {
            guard let url = Constants.URLs.studentCenter else { return }
            UIApplication.shared.open(url)
        }

    }

}
