//
//  HomeView.swift
//  CourseGrab
//
//  Created by jiwon jeong on 3/27/26.
//

import SwiftUI

struct HomeView: View {

    @StateObject private var viewModel = ViewModel()
    @State private var showSearch = false

    var body: some View {
        NavigationStack {
            mainContent
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarBackButtonHidden(false)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text("CourseGrab")
                            .font(Constants.Fonts.semibold20)
                            .foregroundStyle(.white)
                    }
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            // Settings
                        } label: {
                            Constants.Images.iconSettings
                                .foregroundStyle(.white)
                        }
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            showSearch = true
                        } label: {
                            Constants.Images.iconSearch
                                .foregroundStyle(.white)
                        }
                    }
                }
                .toolbarBackground(.black, for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
                .navigationDestination(isPresented: $showSearch) {
                    SearchView()
                }
        }
        .task {
            await viewModel.fetchTrackedSections()
        }
    }

    @ViewBuilder
    private var mainContent: some View {
        ZStack {
            Constants.Colors.white
                .ignoresSafeArea()

            if viewModel.isLoading {
                ProgressView()
            } else if viewModel.hasError {
                HomeStateView(
                    title: "Could Not Connect to Server",
                    subtitle: "Pull down to refresh",
                    status: .closed
                )
            } else if viewModel.isEmpty {
                HomeStateView(
                    title: "No Courses Currently Tracked",
                    subtitle: "Tap the search icon to start adding courses",
                    status: .open
                )
            } else {
                ScrollView {
                    LazyVStack(spacing: 0, pinnedViews: .sectionHeaders) {
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
}
