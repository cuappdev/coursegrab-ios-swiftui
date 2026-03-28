//
//  SettingsView.swift
//  CourseGrab
//
//  Created by jiwon jeong on 3/27/26.
//

import MessageUI
import SwiftUI

struct SettingsView: View {

    // MARK: - Properties

    @StateObject private var viewModel = ViewModel()
    @Environment(\.dismiss) private var dismiss
    @State private var showMailComposer = false

    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Drag indicator
            HStack {
                Spacer()
                
                RoundedRectangle(cornerRadius: 3)
                    .fill(Constants.Colors.veryLightGray)
                    .frame(width: 40, height: 5)
                
                Spacer()
            }
            .padding(.top, 12)
            .padding(.bottom, 20)

            Text("Settings")
                .font(Constants.Fonts.bold24)
                .padding(.horizontal, Constants.Padding.screenHorizontal)

            VStack(alignment: .leading, spacing: 20) {

                // Mobile alerts
                HStack {
                    Text("Mobile Alerts")
                        .font(Constants.Fonts.semibold16)
                    
                    Spacer()
                    
                    Toggle("", isOn: $viewModel.notificationsEnabled)
                        .labelsHidden()
                        .onChange(of: viewModel.notificationsEnabled) { _, newValue in
                            viewModel.toggleNotifications(newValue)
                        }
                }

                // Local timezone
                HStack {
                    Text("Use Local Timezone")
                        .font(Constants.Fonts.semibold16)
                    
                    Spacer()
                    
                    Toggle("", isOn: $viewModel.localTimezoneEnabled)
                        .labelsHidden()
                        .onChange(of: viewModel.localTimezoneEnabled) { _, newValue in
                            viewModel.toggleLocalTimezone(newValue)
                        }
                }

                // Cornell Academic Calendar
                Button {
                    viewModel.openCalendar()
                } label: {
                    Text("Cornell Academic Calendar")
                        .font(Constants.Fonts.semibold16)
                        .foregroundStyle(Constants.Colors.hotlink)
                }

                // Leave Feedback
                Button {
                    if viewModel.canSendMail {
                        showMailComposer = true
                    } else {
                        viewModel.showMailError = true
                    }
                } label: {
                    Text("Leave Feedback")
                        .font(Constants.Fonts.semibold16)
                        .foregroundStyle(Constants.Colors.hotlink)
                }

                // Account + Sign out
                HStack {
                    Text(UserSessionManager.shared.email ?? "")
                        .font(Constants.Fonts.semibold16)
                        .foregroundStyle(Constants.Colors.darkGray)
                    
                    Spacer()
                    
                    Button {
                        dismiss()
                        viewModel.signOut()
                    } label: {
                        Text("Sign Out")
                            .font(Constants.Fonts.semibold16)
                            .foregroundStyle(Constants.Colors.ruby)
                    }
                }

            }
            .padding(.horizontal, Constants.Padding.screenHorizontal)
            .padding(.top, 27)

            Spacer()
        }
        .onAppear {
            Task { await viewModel.refreshNotificationStatus() }
        }
        .sheet(isPresented: $showMailComposer) {
            MailComposerView(recipient: "team@cornellappdev.com", subject: "CourseGrab Feedback")
        }
        .alert("Couldn't Send Email", isPresented: $viewModel.showMailError) {
            Button("Open Settings") {
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url)
                }
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Please add an email account in Settings or contact us at team@cornellappdev.com")
        }
    }

}
