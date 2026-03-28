//
//  ContentView.swift
//  CourseGrab
//
//  Created by jiwon jeong on 3/26/26.
//

import SwiftUI

struct ContentView: View {

    @StateObject private var sessionManager = UserSessionManager.shared

    var body: some View {
        Group {
            if sessionManager.isAuthenticated {
                HomeView()
            } else {
                LoginView()
            }
        }
        .onAppear {
            sessionManager.restorePreviousSession { result in
                switch result {
                case .success:
                    break // isAuthenticated fires via Firebase listener
                case .needsSignIn, .invalidEmail, .error:
                    break // LoginView shown via isAuthenticated = false
                }
            }
        }
    }

}
