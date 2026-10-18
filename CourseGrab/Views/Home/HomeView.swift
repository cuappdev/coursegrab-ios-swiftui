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
    @StateObject private var searchViewModel = SearchViewModel()
    @StateObject private var bellAnimation = BellAnimationViewModel()
    @FocusState private var isSearchFieldFocused: Bool
    @State private var showSettings = false

    /// True once the user types anything: Home swaps its tracked list for live search results.
    private var isSearching: Bool {
        !searchViewModel.searchText.isEmpty
    }

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
            .animation(.easeInOut(duration: Constants.Banner.animationDuration), value: viewModel.bannerMessage)
            .animation(
                .easeInOut(duration: Constants.Interaction.modalAnimationDuration),
                value: viewModel.sectionPendingUntrack?.id
            )
            .toolbar(.hidden, for: .navigationBar)
            .navigationDestination(isPresented: $showSettings) {
                SettingsView()
            }
            .errorAlert($viewModel.errorMessage)
            .errorAlert($searchViewModel.errorMessage)
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
            HStack(spacing: Constants.Header.searchRowSpacing) {
                searchField
                if isSearching || isSearchFieldFocused {
                    clearButton
                }
            }
        }
    }

    private var searchField: some View {
        HStack(spacing: Constants.Header.searchIconSpacing) {
            Constants.Images.search
                .resizable()
                .scaledToFit()
                .frame(width: Constants.Header.searchIconSize, height: Constants.Header.searchIconSize)
            TextField(
                "",
                text: $searchViewModel.searchText,
                prompt: Text("Search for a course...").foregroundColor(Constants.Colors.darkGray)
            )
            .font(Constants.Fonts.h4)
            .foregroundStyle(Constants.Colors.black)
            .tint(Constants.Colors.black)
            .autocorrectionDisabled()
            .textInputAutocapitalization(.characters)
            .submitLabel(.search)
            .focused($isSearchFieldFocused)
            .onChange(of: searchViewModel.searchText) { _ in
                searchViewModel.onSearchTextChanged()
            }
        }
        .headerSearchFieldStyle()
    }

    /// FA26 circular ✕ that exits search in place, returning Home to the tracked list.
    private var clearButton: some View {
        Button {
            searchViewModel.clear()
            isSearchFieldFocused = false
        } label: {
            Constants.Images.clearSearch
                .resizable()
                .scaledToFit()
                .frame(width: Constants.Header.clearIconSize, height: Constants.Header.clearIconSize)
                .frame(width: Constants.Header.clearButtonSize, height: Constants.Header.clearButtonSize)
                .background(Circle().fill(Constants.Colors.lightGray))
        }
        .buttonStyle(.scale)
        .accessibilityLabel("Clear search")
    }

    // MARK: - Main Content

    @ViewBuilder
    private var mainContent: some View {
        if isSearching {
            searchContent
        } else if viewModel.isLoading {
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

    // MARK: - Search Content

    @ViewBuilder
    private var searchContent: some View {
        if searchViewModel.showMinCharWarning {
            HomeStateView(
                title: "3 characters needed",
                subtitle: "Please add more"
            )
        } else if searchViewModel.isLoading {
            ProgressView()
        } else if searchViewModel.courses.isEmpty && searchViewModel.hasSearched {
            HomeStateView(
                title: "No Results",
                subtitle: "Try a different search",
                image: Constants.Images.emptyNoCourses
            )
        } else {
            searchResults
        }
    }

    private var searchResults: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: Constants.Padding.sectionSpacing) {
                if !searchViewModel.courses.isEmpty {
                    SearchResultsHeaderView(count: searchViewModel.courses.count)
                }
                ForEach(searchViewModel.courses) { course in
                    NavigationLink {
                        SearchDetailView(
                            course: course,
                            searchViewModel: searchViewModel,
                            onSectionTracked: { message in
                                searchViewModel.clear()
                                isSearchFieldFocused = false
                                viewModel.showTrackingBanner(message)
                                Task { await viewModel.fetchTrackedSections() }
                            }
                        )
                    } label: {
                        SearchCourseCardView(
                            course: course,
                            onUntrack: { section in
                                Task { await searchViewModel.untrack(section: section) }
                            }
                        )
                    }
                    .buttonStyle(.scale)
                }
            }
            .padding(.horizontal, Constants.Padding.screenHorizontal)
            .padding(.top, Constants.Padding.sectionSpacing)
            .padding(.bottom, Constants.Padding.screenBottom)
        }
        .scrollDismissesKeyboard(.immediately)
    }

    // MARK: - Overlays

    @ViewBuilder
    private var banner: some View {
        if let message = viewModel.bannerMessage {
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
