//
//  ContentView.swift
//  CourseGrab
//
//  Created by jiwon jeong on 3/26/26.
//

import SwiftUI

struct ContentView: View {

    @StateObject private var viewModel = AuthViewModel()

    var body: some View {
        Group {
            if viewModel.isAuthenticated {
                HomeView()
            } else {
                LoginView()
            }
        }
        .onAppear {
            viewModel.restoreSession()
        }
    }
}
