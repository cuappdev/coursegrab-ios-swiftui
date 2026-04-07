//
//  SearchViewModel.swift
//  CourseGrab
//
//  Created by jiwon jeong on 3/27/26.
//

import Combine
import Foundation

extension SearchView {

    @MainActor
    class ViewModel: ObservableObject {

        // MARK: - Properties

        @Published var searchText: String = ""
        @Published var courses: [Course] = []
        @Published var isLoading: Bool = false
        @Published var hasSearched: Bool = false

        private var searchTask: Task<Void, Never>?

        // MARK: - Computed

        var showMinCharWarning: Bool {
            searchText.count > 0 && searchText.count < 3
        }

        // MARK: - Functions

        func onSearchTextChanged() {
            searchTask?.cancel()

            guard searchText.count >= 3 else {
                courses = []
                hasSearched = false
                return
            }

            searchTask = Task {
                try? await Task.sleep(nanoseconds: 200_000_000) // 0.2s debounce
                guard !Task.isCancelled else { return }
                await search()
            }
        }

        func search() async {
            isLoading = true
            do {
                courses = try await NetworkManager.shared.searchCourse(query: searchText)
                hasSearched = true
            } catch {
                print("Search failed: \(error)")
                if error.invalidatesUserSession {
                    UserSessionManager.shared.logout()
                }
            }
            isLoading = false
        }

        func untrack(section: CourseSection) async {
            do {
                let updated = try await NetworkManager.shared.untrackSection(catalogNum: section.catalogNum)
                updateSection(updated)
            } catch {
                print("Failed to untrack: \(error)")
                if error.invalidatesUserSession {
                    UserSessionManager.shared.logout()
                }
            }
        }

        func track(section: CourseSection) async {
            do {
                let updated = try await NetworkManager.shared.trackSection(catalogNum: section.catalogNum)
                updateSection(updated)
            } catch {
                print("Failed to track: \(error)")
                if error.invalidatesUserSession {
                    UserSessionManager.shared.logout()
                }
            }
        }

        private func updateSection(_ section: CourseSection) {
            guard let courseIndex = courses.firstIndex(where: { $0.courseNum == section.courseNum }),
                  let sectionIndex = courses[courseIndex].sections.firstIndex(where: { $0.catalogNum == section.catalogNum })
            else { return }

            var sections = courses[courseIndex].sections
            sections[sectionIndex] = section

            let old = courses[courseIndex]
            courses[courseIndex] = Course(
                courseNum: old.courseNum,
                subjectCode: old.subjectCode,
                sections: sections,
                title: old.title
            )
        }

    }

}
