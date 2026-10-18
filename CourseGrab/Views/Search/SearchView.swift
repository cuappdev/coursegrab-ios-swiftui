//
//  SearchView.swift
//  CourseGrab
//
//  Created by jiwon jeong on 3/27/26.
//

import SwiftUI

struct SearchView: View {

    // MARK: - Properties

    @StateObject private var viewModel = ViewModel()
    @StateObject private var bellAnimation = BellAnimationViewModel()
    @Environment(\.dismiss) private var dismiss
    @FocusState private var isSearchFieldFocused: Bool
    let onSectionTracked: (_ message: String) -> Void
    var onSettingsTapped: () -> Void = {}

    // MARK: - UI

    var body: some View {
        ZStack {
            Constants.Colors.white
                .ignoresSafeArea()

            VStack(spacing: 0) {
                header
                content
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .toolbar(.hidden, for: .navigationBar)
        .errorAlert($viewModel.errorMessage)
        .onAppear { isSearchFieldFocused = viewModel.searchText.isEmpty }
    }

    // MARK: - Header

    private var header: some View {
        CourseGrabHeaderView(
            isRefreshing: false,
            bellAnimation: bellAnimation,
            onSettingsTapped: onSettingsTapped
        ) {
            HStack(spacing: Constants.Header.searchRowSpacing) {
                searchField
                clearButton
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
                text: $viewModel.searchText,
                prompt: Text("Search for a course...").foregroundColor(Constants.Colors.darkGray)
            )
            .font(Constants.Fonts.h4)
            .foregroundStyle(Constants.Colors.black)
            .tint(Constants.Colors.black)
            .autocorrectionDisabled()
            .textInputAutocapitalization(.characters)
            .submitLabel(.search)
            .focused($isSearchFieldFocused)
            .onChange(of: viewModel.searchText) { _ in
                viewModel.onSearchTextChanged()
            }
        }
        .headerSearchFieldStyle()
    }

    /// FA26 circular ✕ next to the field; exits search back to Home.
    private var clearButton: some View {
        Button {
            dismiss()
        } label: {
            Constants.Images.clearSearch
                .resizable()
                .scaledToFit()
                .frame(width: Constants.Header.clearIconSize, height: Constants.Header.clearIconSize)
                .frame(width: Constants.Header.clearButtonSize, height: Constants.Header.clearButtonSize)
                .background(Circle().fill(Constants.Colors.lightGray))
        }
        .buttonStyle(.scale)
        .accessibilityLabel("Close search")
    }

    // MARK: - Content

    @ViewBuilder
    private var content: some View {
        if viewModel.showMinCharWarning {
            HomeStateView(
                title: "3 characters needed",
                subtitle: "Please add more"
            )
        } else if viewModel.isLoading {
            ProgressView()
        } else if viewModel.courses.isEmpty && viewModel.hasSearched {
            HomeStateView(
                title: "No Results",
                subtitle: "Try a different search",
                image: Constants.Images.emptyNoCourses
            )
        } else {
            results
        }
    }

    private var results: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: Constants.Padding.sectionSpacing) {
                if !viewModel.courses.isEmpty {
                    SearchResultsHeaderView(count: viewModel.courses.count)
                }
                ForEach(viewModel.courses) { course in
                    NavigationLink {
                        SearchDetailView(
                            course: course,
                            searchViewModel: viewModel,
                            onSectionTracked: onSectionTracked
                        )
                    } label: {
                        SearchCourseCardView(
                            course: course,
                            onUntrack: { section in
                                Task { await viewModel.untrack(section: section) }
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

}

#Preview {
    NavigationStack {
        SearchView(onSectionTracked: { _ in })
    }
}
