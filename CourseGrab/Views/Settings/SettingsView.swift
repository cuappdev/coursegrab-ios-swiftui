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

    private var notificationsBinding: Binding<Bool> {
        Binding(
            get: { viewModel.notificationsEnabled },
            set: { viewModel.setNotificationsEnabled($0) }
        )
    }

    // MARK: - UI

    var body: some View {
        VStack(alignment: .leading, spacing: Constants.Settings.spacing) {
            NavigationTitleBarView(title: "Settings") { dismiss() }
            ScrollView {
                VStack(alignment: .leading, spacing: Constants.Settings.spacing) {
                    credit
                    actions
                }
            }
            footer
        }
        .padding(.horizontal, Constants.Padding.screenHorizontal)
        .padding(.top, Constants.Padding.detailTop)
        .background(Constants.Colors.white.ignoresSafeArea())
        .toolbar(.hidden, for: .navigationBar)
        .task {
            await viewModel.refreshNotificationStatus()
        }
        .sheet(isPresented: $viewModel.showMailComposer) {
            MailComposerView(recipient: "team@cornellappdev.com", subject: "CourseGrab Feedback")
        }
        .alert("Couldn't Send Email", isPresented: $viewModel.showMailError) {
            Button("Open Settings") { viewModel.openAppSettings() }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Please add an email account in Settings or contact us at team@cornellappdev.com")
        }
    }

    // MARK: - Credit

    private var credit: some View {
        HStack(spacing: Constants.Settings.creditSpacing) {
            Constants.Images.rocketLogo
                .resizable()
                .scaledToFit()
                .frame(width: Constants.Settings.rocketSize.width, height: Constants.Settings.rocketSize.height)
            VStack(alignment: .leading, spacing: Constants.Settings.creditTextSpacing) {
                Text("Designed and developed by")
                    .font(Constants.Fonts.creditCaption)
                    .foregroundStyle(Constants.Colors.darkGray)
                (Text("Cornell").font(Constants.Fonts.creditCornell)
                    + Text("AppDev").font(Constants.Fonts.creditAppDev))
                    .tracking(Constants.Settings.creditTracking)
                    .foregroundStyle(Constants.Colors.black)
            }
        }
        .frame(maxWidth: .infinity)
        .accessibilityElement(children: .combine)
    }

    // MARK: - Actions

    private var actions: some View {
        VStack(alignment: .leading, spacing: Constants.Settings.actionsSpacing) {
            toggleRow(title: "Mobile Alerts", isOn: notificationsBinding)
            toggleRow(title: "Display Local Timezone", isOn: $viewModel.localTimezoneEnabled)
                .onChange(of: viewModel.localTimezoneEnabled) { newValue in
                    viewModel.toggleLocalTimezone(newValue)
                }
            linkRow(title: "Cornell Academic Calendar") { viewModel.openCalendar() }
            linkRow(title: "Leave Feedback") { viewModel.leaveFeedback() }
        }
    }

    private func toggleRow(title: String, isOn: Binding<Bool>) -> some View {
        Toggle(isOn: isOn) {
            Text(title)
                .font(Constants.Fonts.h3)
                .foregroundStyle(Constants.Colors.black)
        }
        .tint(Constants.Colors.green)
        .padding(Constants.Settings.rowPadding)
    }

    private func linkRow(title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack {
                Text(title)
                    .font(Constants.Fonts.h3)
                    .foregroundStyle(Constants.Colors.blue)
                Spacer()
                Constants.Images.externalLinkBlue
                    .resizable()
                    .scaledToFit()
                    .frame(width: Constants.Settings.externalIconSize, height: Constants.Settings.externalIconSize)
            }
            .padding(Constants.Settings.rowPadding)
            .cardStyle(cornerRadius: Constants.Radius.button)
        }
        .buttonStyle(.scale)
    }

    // MARK: - Footer

    private var footer: some View {
        HStack {
            Text(viewModel.accountEmail)
                .font(Constants.Settings.footerFont)
                .foregroundStyle(Constants.Colors.darkGray)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
            Spacer()
            Button("Sign Out") { viewModel.signOut() }
                .font(Constants.Settings.footerFont)
                .foregroundStyle(Constants.Colors.red)
                .buttonStyle(.scale)
        }
        .padding(Constants.Settings.rowPadding)
    }

}

#Preview {
    NavigationStack {
        SettingsView()
    }
}
