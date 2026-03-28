//
//  SearchCourseCardView.swift
//  CourseGrab
//
//  Created by jiwon jeong on 3/27/26.
//

import SwiftUI

struct SearchCourseCardView: View {

    // MARK: - Properties

    let course: Course
    let onUntrack: (CourseSection) -> Void

    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .top) {
                Text("\(course.subjectCode) \(course.courseNum.formatted(.number.grouping(.never))): \(course.title)")
                    .font(Constants.Fonts.semibold16)
                    .foregroundStyle(Constants.Colors.black)
                    .multilineTextAlignment(.leading)
                
                Spacer()
                
                Constants.Images.iconArrow
                    .resizable()
                    .scaledToFit()
                    .frame(width: 16, height: 16)
                    .foregroundStyle(Constants.Colors.black)
            }
            .padding(16)

            let tracked = course.sections.filter { $0.isTracking }
            
            if !tracked.isEmpty {
                ForEach(tracked) { section in
                    Divider()
                        .padding(.horizontal, 0)
                    SearchTrackedSectionRow(section: section, onUntrack: onUntrack)
                }
            }
        }
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 5))
        .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 0)
        .padding(.horizontal, Constants.Padding.screenHorizontal)
        .padding(.vertical, Constants.Padding.cellVertical)
    }

}
