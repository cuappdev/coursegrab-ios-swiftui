//
//  SearchViewModel.swift
//  CourseGrab
//
//  Created by jiwon jeong on 3/27/26.
//

import Combine
import Foundation
import OSLog

/// Drives the live course search in the Home header and the class detail screen it pushes.
@MainActor
final class SearchViewModel: ObservableObject {

    // MARK: - Properties

    @Published var searchText: String = ""
    @Published var courses: [Course] = []
    @Published var isLoading: Bool = false
    @Published var hasSearched: Bool = false
    @Published var errorMessage: String?
    /// Banner message for the most recent track / untrack made on the class detail screen.
    /// When set, leaving the detail screen returns to Home (FA26 "Track: back → home page").
    @Published private(set) var detailTrackingMessage: String?

    private var searchTask: Task<Void, Never>?
    /// Sections with a track / untrack request in flight (single-flight per section).
    private var sectionsUpdating: Set<Int> = []

    // MARK: - Computed

    var showMinCharWarning: Bool {
        searchText.count > 0 && searchText.count < 3
    }

    // MARK: - Functions

    /// Exits search: clears the field and any results, returning the caller to its base content.
    func clear() {
        searchText = ""
        onSearchTextChanged()
    }

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
        defer { isLoading = false }
        do {
            courses = try await NetworkManager.shared.searchCourse(query: searchText)
            hasSearched = true
        } catch {
            Logger.viewModels.error("Search failed: \(error.localizedDescription, privacy: .public)")
            if error.invalidatesUserSession {
                UserSessionManager.shared.logout()
            }
        }
    }

    @discardableResult
    func untrack(section: CourseSection) async -> Bool {
        do {
            let updated = try await NetworkManager.shared.untrackSection(catalogNum: section.catalogNum)
            updateSection(updated)
            return true
        } catch {
            Logger.viewModels.error("Failed to untrack: \(error.localizedDescription, privacy: .public)")
            if error.invalidatesUserSession {
                UserSessionManager.shared.logout()
            } else {
                errorMessage = "Couldn't stop tracking \(section.displayCode). Please try again."
            }
            return false
        }
    }

    @discardableResult
    func track(section: CourseSection) async -> Bool {
        do {
            let updated = try await NetworkManager.shared.trackSection(catalogNum: section.catalogNum)
            updateSection(updated)
            return true
        } catch {
            Logger.viewModels.error("Failed to track: \(error.localizedDescription, privacy: .public)")
            if error.invalidatesUserSession {
                UserSessionManager.shared.logout()
            } else {
                errorMessage = "Couldn't track \(section.displayCode). Please try again."
            }
            return false
        }
    }

    // MARK: - Class detail

    /// The latest copy of `course` from the search results (reflects track / untrack updates).
    func currentCourse(for course: Course) -> Course {
        courses.first { $0.id == course.id } ?? course
    }

    /// The section featured at the top of the class detail screen with the TRACK button:
    /// the first lecture, or the first section when the course has no lecture.
    func primarySection(of course: Course) -> CourseSection? {
        course.sections.first { $0.isLecture } ?? course.sections.first
    }

    /// Every other section, listed under the primary one with bell toggles.
    func secondarySections(of course: Course) -> [CourseSection] {
        guard let primary = primarySection(of: course) else { return [] }
        return course.sections.filter { $0.catalogNum != primary.catalogNum }
    }

    /// "Discussion Sections" when every listed section is a discussion, otherwise "Other Sections".
    func secondarySectionsTitle(of course: Course) -> String {
        let sections = secondarySections(of: course)
        let allDiscussions = sections.allSatisfy { $0.section.uppercased().hasPrefix("DIS") }
        return allDiscussions ? "Discussion Sections" : "Other Sections"
    }

    /// Tracks or untracks `section` in place and remembers the banner message for Home.
    func toggleTracking(_ section: CourseSection, in course: Course) async {
        guard sectionsUpdating.insert(section.catalogNum).inserted else { return }
        defer { sectionsUpdating.remove(section.catalogNum) }
        let wasTracking = section.isTracking
        let succeeded: Bool
        if wasTracking {
            succeeded = await untrack(section: section)
        } else {
            succeeded = await track(section: section)
        }
        guard succeeded else { return }
        Haptics.shared.play(wasTracking ? .light : .success)
        let sectionName = "\(course.displayCode) \(section.getSectionNum())"
        detailTrackingMessage = wasTracking
            ? "You are no longer tracking \(sectionName)"
            : "You are now tracking \(sectionName)"
    }

    /// TRACK / TRACKING button on the class detail info block.
    func togglePrimaryTracking(in course: Course) async {
        guard let primary = primarySection(of: course) else { return }
        await toggleTracking(primary, in: course)
    }

    /// Back from class detail: to Home (with a banner) if tracking changed, otherwise back to Search.
    func leaveDetail(onTrackingChanged: (String) -> Void, onDismiss: () -> Void) {
        guard let message = detailTrackingMessage else {
            onDismiss()
            return
        }
        detailTrackingMessage = nil
        onTrackingChanged(message)
    }

    // MARK: - Private

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
