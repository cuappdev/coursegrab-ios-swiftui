//
//  SettingsViewModel.swift
//  CourseGrab
//
//  Created by jiwon jeong on 3/28/26.
//

import MessageUI
import SwiftUI
import UserNotifications
import Combine

extension SettingsView {

    @MainActor
    class ViewModel: ObservableObject {

        // MARK: - Properties

        @Published var notificationsEnabled: Bool = false
        @Published var localTimezoneEnabled: Bool = false
        @Published var canSendMail: Bool = false
        @Published var showMailError: Bool = false

        // MARK: - Init

        init() {
            localTimezoneEnabled = UserDefaults.standard.bool(forKey: "localTimezoneEnabled")
            canSendMail = MFMailComposeViewController.canSendMail()
            Task { await refreshNotificationStatus() }
        }

        // MARK: - Functions

        func refreshNotificationStatus() async {
            let settings = await UNUserNotificationCenter.current().notificationSettings()
            notificationsEnabled = settings.authorizationStatus == .authorized
                && UserDefaults.standard.bool(forKey: "areNotificationsEnabled")
        }

        func toggleNotifications(_ enabled: Bool) {
            Task {
                let settings = await UNUserNotificationCenter.current().notificationSettings()
                if settings.authorizationStatus == .authorized {
                    UserDefaults.standard.set(enabled, forKey: "areNotificationsEnabled")
                    try? await NetworkManager.shared.enableNotifications(enabled: enabled)
                } else {
                    notificationsEnabled = false
                    if let url = URL(string: UIApplication.openSettingsURLString) {
                        await UIApplication.shared.open(url)
                    }
                }
            }
        }

        func toggleLocalTimezone(_ enabled: Bool) {
            UserDefaults.standard.set(enabled, forKey: "localTimezoneEnabled")
        }

        func openCalendar() {
            if let url = URL(string: "https://registrar.cornell.edu/academic-calendar") {
                UIApplication.shared.open(url)
            }
        }

        func openStudentCenter() {
            if let url = URL(string: "https://studentcenter.cornell.edu") {
                UIApplication.shared.open(url)
            }
        }

        func signOut() {
            Task {
                try? await NetworkManager.shared.enableNotifications(enabled: false)
                UserSessionManager.shared.logout()
            }
        }

    }

}
