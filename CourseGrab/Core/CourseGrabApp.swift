//
//  CourseGrabApp.swift
//  CourseGrab
//
//  Created by jiwon jeong on 3/26/26.
//

import Firebase
import GoogleSignIn
import OSLog
import SwiftUI
import UserNotifications

@main
struct CourseGrabApp: App {

    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.light)
                .dynamicTypeSize(.medium ... .medium)
                .environment(\.legibilityWeight, .regular)
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {

    private let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier ?? "com.cornellappdev.coursegrab",
        category: "AppDelegate"
    )

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        FirebaseApp.configure()
        GIDSignIn.sharedInstance.configuration = GIDConfiguration(
            clientID: CourseGrabEnvironment.Keys.googleClientID
        )

        UNUserNotificationCenter.current().delegate = self
        registerForRemoteNotificationsIfAuthorized()
        return true
    }

    private func registerForRemoteNotificationsIfAuthorized() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            let hasPermission: Bool = {
                switch settings.authorizationStatus {
                case .authorized, .provisional:
                    return true
                default:
                    return false
                }
            }()

            guard hasPermission else { return }

            // Respect the in-app toggle: only register with APNs if the user has enabled notifications
            // in Settings (the system permission alone isn't enough).
            guard UserDefaults.standard.bool(forKey: "areNotificationsEnabled") else { return }

            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }

    func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey: Any] = [:]
    ) -> Bool {
        GIDSignIn.sharedInstance.handle(url)
    }

    // MARK: - APNs Device Token Registration

    /// Called by iOS after a successful call to `registerForRemoteNotifications()`.
    /// Converts the raw token Data into a hex string and forwards it to the backend.
    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        let tokenString = deviceToken
            .map { String(format: "%02x", $0) }
            .joined()

        logger.info("APNs device token registered: \(tokenString)")

        Task {
            await UserSessionManager.shared.updateDeviceToken(tokenString)
        }
    }

    /// Called when APNs token registration fails (e.g. on the Simulator or with no network).
    func application(
        _ application: UIApplication,
        didFailToRegisterForRemoteNotificationsWithError error: Error
    ) {
        logger.error("Failed to register for remote notifications: \(error.localizedDescription)")
    }

}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.banner, .badge, .sound])
    }
}
