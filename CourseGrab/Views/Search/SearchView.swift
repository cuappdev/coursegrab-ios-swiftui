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
    @Environment(\.dismiss) private var dismiss
    let onSectionTracked: (_ message: String) -> Void

    // MARK: - Body

    var body: some View {
        ZStack {
            Constants.Colors.white
                .ignoresSafeArea()

            VStack(spacing: 0) {
                if viewModel.showMinCharWarning {
                    HomeStateView(
                        title: "3 characters needed",
                        subtitle: "Please add more",
                        status: .waitlist
                    )
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if viewModel.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if viewModel.courses.isEmpty && viewModel.hasSearched {
                    HomeStateView(
                        title: "No Results",
                        subtitle: "Try a different search",
                        status: .closed
                    )
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    ScrollView {
                        LazyVStack(spacing: 0) {
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
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.top, 12)
                    }
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Constants.Images.iconBack
                        .foregroundStyle(.white)
                }
            }
            .sharedBackgroundVisibility(.hidden)
            ToolbarItem(placement: .principal) {
                TextField("", text: $viewModel.searchText, prompt:
                    Text("Search for a course")
                        .foregroundColor(.white.opacity(0.7))
                )
                .font(Constants.Fonts.medium20)
                .foregroundStyle(.white)
                .tint(.white)
                .autocorrectionDisabled()
                .frame(width: UIScreen.main.bounds.width - 80)
                .onChange(of: viewModel.searchText) {
                    viewModel.onSearchTextChanged()
                }
            }
            .sharedBackgroundVisibility(.hidden)
        }
        .toolbarBackground(.black, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
    }

}
