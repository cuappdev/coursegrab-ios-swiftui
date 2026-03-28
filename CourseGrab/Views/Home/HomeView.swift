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
    @State private var showSearch = false
    @State private var bannerMessage: String? = nil
    @State private var showBanner: Bool = false
    @State private var showSettings = false

    // MARK: - Body

    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                Constants.Colors.white
                    .ignoresSafeArea()

                mainContent

                if showBanner, let message = bannerMessage {
                    VStack {
                        TrackingBannerView(message: message)
                            .transition(.move(edge: .top).combined(with: .opacity))
                        Spacer()
                    }
                    .zIndex(1)
                }
            }
            .animation(.easeInOut(duration: 0.3), value: showBanner)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("CourseGrab")
                        .font(Constants.Fonts.semibold20)
                        .foregroundStyle(.white)
                }
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        showSettings = true
                    } label: {
                        Constants.Images.iconSettings
                            .foregroundStyle(.white)
                    }
                }
                .sharedBackgroundVisibility(.hidden)
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showSearch = true
                    } label: {
                        Constants.Images.iconSearch
                            .foregroundStyle(.white)
                    }
                }
                .sharedBackgroundVisibility(.hidden)
            }
            .toolbarBackground(.black, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .navigationDestination(isPresented: $showSearch) {
                SearchView(
                    onSectionTracked: { message in
                        showSearch = false
                        Task { await viewModel.fetchTrackedSections() }
                        bannerMessage = message
                        withAnimation { showBanner = true }
                        Task {
                            try? await Task.sleep(nanoseconds: 1_150_000_000)
                            withAnimation { showBanner = false }
                        }
                    }
                )
            }
            .sheet(isPresented: $showSettings) {
                SettingsView()
                    .presentationDetents([.fraction(0.44)])
                    .presentationDragIndicator(.hidden)
                    .presentationBackground(Constants.Colors.white)
            }
        }
        .task {
            await viewModel.fetchTrackedSections()
        }
    }

    // MARK: - Main Content

    @ViewBuilder
    private var mainContent: some View {
        if viewModel.isLoading {
            Spacer()
            
            ProgressView()
            
            Spacer()
        } else if viewModel.hasError {
            VStack {
                Spacer()

                HomeStateView(
                    title: "Could Not Connect to Server",
                    subtitle: "Pull down to refresh",
                    status: .closed
                )

                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.top, 24)
        } else if viewModel.isEmpty {
            Spacer()
            
            HomeStateView(
                title: "No Courses Currently Tracked",
                subtitle: "Tap the search icon to start adding courses",
                status: .open
            )
            
            Spacer()
        } else {
            ScrollView {
                LazyVStack(spacing: 0) {
                    if !viewModel.availableSections.isEmpty {
                        Section {
                            ForEach(viewModel.availableSections) { section in
                                HomeSectionCardView(section: section) {
                                    Task { await viewModel.untrack(section: section) }
                                }
                            }
                        } header: {
                            HomeSectionHeaderView(
                                count: viewModel.availableSections.count,
                                isAvailable: true
                            )
                        }
                    }

                    if !viewModel.awaitingSections.isEmpty {
                        Section {
                            ForEach(viewModel.awaitingSections) { section in
                                HomeSectionCardView(section: section) {
                                    Task { await viewModel.untrack(section: section) }
                                }
                            }
                        } header: {
                            HomeSectionHeaderView(
                                count: viewModel.awaitingSections.count,
                                isAvailable: false
                            )
                        }
                    }
                }
                .padding(.top, 18)
            }
            .refreshable {
                await viewModel.fetchTrackedSections()
            }
        }
    }

}
