//
//  HomeView.swift
//  CourseGrab
//
//  Created by jiwon jeong on 3/27/26.
//

import SwiftUI

struct HomeView: View {

    // MARK: - Properties

    @StateObject private var viewModel = ViewModel()
    @StateObject private var bellAnimation = BellAnimationViewModel()
    @State private var showSearch = false
    @State private var bannerMessage: String? = nil
    @State private var showBanner: Bool = false
    @State private var showSettings = false

    // MARK: - UI

    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                Constants.Colors.white
                    .ignoresSafeArea()

                VStack(spacing: 0) {
                    header
                    mainContent
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }

                banner
                stopTrackingModal
            }
            .animation(.easeInOut(duration: Constants.Banner.animationDuration), value: showBanner)
            .animation(
                .easeInOut(duration: Constants.Interaction.modalAnimationDuration),
                value: viewModel.sectionPendingUntrack?.id
            )
            .toolbar(.hidden, for: .navigationBar)
            .navigationDestination(isPresented: $showSettings) {
                SettingsView()
            }
            .errorAlert($viewModel.errorMessage)
            .onChange(of: viewModel.isRefreshing) { isRefreshing in
                bellAnimation.setAnimating(isRefreshing)
            }
        }
        .task {
            await viewModel.fetchTrackedSections()
        }
    }

    // MARK: - Header

    private var header: some View {
        CourseGrabHeaderView(
            isRefreshing: viewModel.isRefreshing,
            bellAnimation: bellAnimation,
            onSettingsTapped: { showSettings = true }
        ) {
            searchFieldButton
        }
        .navigationDestination(isPresented: $showSearch) {
            searchDestination
        }
    }

    private var searchFieldButton: some View {
        Button {
            showSearch = true
        } label: {
            HStack(spacing: Constants.Header.searchIconSpacing) {
                Constants.Images.search
                    .resizable()
                    .scaledToFit()
                    .frame(width: Constants.Header.searchIconSize, height: Constants.Header.searchIconSize)
                Text("Search for a course...")
                    .font(Constants.Fonts.h4)
                    .foregroundStyle(Constants.Colors.darkGray)
            }
            .headerSearchFieldStyle()
        }
        .buttonStyle(.scale)
    }

    private var searchDestination: some View {
        SearchView(
            onSectionTracked: { message in
                showSearch = false
                Task { await viewModel.fetchTrackedSections() }
                bannerMessage = message // MARK: Completion Handler!
                withAnimation { showBanner = true }
                Task {
                    try? await Task.sleep(nanoseconds: Constants.Banner.displayNanoseconds)
                    withAnimation { showBanner = false }
                }
            },
            onSettingsTapped: { showSettings = true }
        )
    }

    // MARK: - Main Content

    @ViewBuilder
    private var mainContent: some View {
        if viewModel.isLoading {
            ProgressView()
        } else if viewModel.hasError {
            stateContent(
                title: "No Internet Connection",
                subtitle: "Please try again later",
                image: Constants.Images.emptyNoInternet
            )
        } else if viewModel.isEmpty {
            stateContent(
                title: "No Courses Currently Tracked",
                subtitle: "Search to start adding courses",
                image: Constants.Images.emptyNoCourses
            )
        } else {
            trackedList
        }
    }

    private var trackedList: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: Constants.Padding.sectionSpacing) {
                HomeSectionHeaderView(
                    openCount: viewModel.openCount,
                    closedCount: viewModel.closedCount,
                    waitlistCount: viewModel.waitlistCount
                )

                ForEach(viewModel.trackedSections) { section in
                    HomeSectionCardView(
                        section: section,
                        onUntrack: { viewModel.requestUntrack(section) },
                        onCopyPin: { viewModel.copyPin(for: section) },
                        onEnroll: { viewModel.openStudentCenter() }
                    )
                }
            }
            .padding(.horizontal, Constants.Padding.screenHorizontal)
            .padding(.top, Constants.Padding.sectionSpacing)
            .padding(.bottom, Constants.Padding.screenBottom)
        }
        .refreshable {
            await viewModel.refresh()
        }
    }

    /// Empty / offline content, scrollable so pull-to-refresh works there too.
    private func stateContent(title: String, subtitle: String, image: Image) -> some View {
        GeometryReader { geo in
            ScrollView {
                HomeStateView(title: title, subtitle: subtitle, image: image)
                    .frame(width: geo.size.width)
                    .frame(minHeight: geo.size.height)
            }
            .refreshable {
                await viewModel.refresh()
            }
        }
    }

    // MARK: - Overlays

    @ViewBuilder
    private var banner: some View {
        if showBanner, let message = bannerMessage {
            VStack {
                TrackingBannerView(message: message)
                    .transition(.move(edge: .top).combined(with: .opacity))
                Spacer()
            }
            .zIndex(1)
        }
    }

    @ViewBuilder
    private var stopTrackingModal: some View {
        if let section = viewModel.sectionPendingUntrack {
            StopTrackingConfirmationView(
                courseCode: section.displayCode,
                onConfirm: { viewModel.confirmUntrack() },
                onCancel: { viewModel.cancelUntrack() }
            )
            .transition(.opacity)
            .zIndex(2)
        }
    }

}

#Preview {
    HomeView()
}
