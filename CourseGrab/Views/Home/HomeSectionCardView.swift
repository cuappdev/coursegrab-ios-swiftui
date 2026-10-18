//
//  HomeSectionCardView.swift
//  CourseGrab
//
//  Created by jiwon jeong on 3/27/26.
//

import SwiftUI

/// FA26 `class cards` lecture card for a tracked section. Open sections show the
/// PIN (copy) and ENROLL buttons; closed / waitlisted sections show no buttons.
struct HomeSectionCardView: View {

    // MARK: - Properties

    let section: CourseSection
    let onUntrack: () -> Void
    var onCopyPin: () -> Void = {}
    var onEnroll: () -> Void = {}
    @AppStorage("localTimezoneEnabled") private var localTimezoneEnabled: Bool = false

    // MARK: - UI

    var body: some View {
        VStack(alignment: .leading, spacing: Constants.Card.spacing) {
            header
            Text(section.title)
                .font(Constants.Fonts.h3)
                .foregroundStyle(Constants.Colors.black)
                .multilineTextAlignment(.leading)
            meta
            if section.status == .open {
                buttons
            }
        }
        .padding(Constants.Card.padding)
        .frame(maxWidth: .infinity, alignment: .leading)
        .cardStyle()
    }

    private var header: some View {
        HStack(spacing: Constants.Card.headerSpacing) {
            StatusBadgeView(status: section.status)
            Text(section.displayCode)
                .font(Constants.Fonts.h3)
                .foregroundStyle(Constants.Colors.black)
                .frame(maxWidth: .infinity, alignment: .leading)
            removeButton
        }
    }

    private var removeButton: some View {
        Button(action: onUntrack) {
            Constants.Images.remove
                .resizable()
                .scaledToFit()
                .frame(width: Constants.Card.removeIconSize, height: Constants.Card.removeIconSize)
                .contentShape(Rectangle())
        }
        .buttonStyle(.scale)
        .accessibilityLabel("Stop tracking \(section.displayCode)")
    }

    private var meta: some View {
        VStack(alignment: .leading, spacing: Constants.Card.metaSpacing) {
            Text(section.getSectionByTimezone(useLocalTimezone: localTimezoneEnabled))
            HStack(alignment: .top) {
                Text(section.mode)
                Spacer()
                Text(section.displayInstructors)
                    .multilineTextAlignment(.trailing)
            }
        }
        .font(Constants.Fonts.body)
        .foregroundStyle(Constants.Colors.darkGray)
    }

    private var buttons: some View {
        HStack(spacing: Constants.Card.buttonSpacing) {
            pinButton
            enrollButton
        }
    }

    private var pinButton: some View {
        Button(action: onCopyPin) {
            HStack(spacing: Constants.Card.buttonContentSpacing) {
                (Text("PIN: ").font(Constants.Fonts.label) + Text(section.displayCatalogNum).font(Constants.Fonts.pin))
                    .foregroundStyle(Constants.Colors.black)
                Constants.Images.copy
                    .resizable()
                    .scaledToFit()
                    .frame(width: Constants.Card.buttonIconSize, height: Constants.Card.buttonIconSize)
            }
            .frame(maxWidth: .infinity)
            .frame(height: Constants.Card.buttonHeight)
            .background(
                RoundedRectangle(cornerRadius: Constants.Radius.button)
                    .fill(Constants.Colors.white)
            )
            .overlay(
                RoundedRectangle(cornerRadius: Constants.Radius.button)
                    .stroke(Constants.Colors.gray, lineWidth: Constants.Border.button)
            )
        }
        .buttonStyle(.scale)
        .accessibilityLabel("Copy PIN \(section.displayCatalogNum)")
    }

    private var enrollButton: some View {
        Button(action: onEnroll) {
            HStack(spacing: Constants.Card.buttonContentSpacing) {
                Text("ENROLL")
                    .font(Constants.Fonts.label)
                    .foregroundStyle(Constants.Colors.white)
                Constants.Images.externalLink
                    .resizable()
                    .scaledToFit()
                    .frame(width: Constants.Card.buttonIconSize, height: Constants.Card.buttonIconSize)
            }
            .frame(maxWidth: .infinity)
            .frame(height: Constants.Card.buttonHeight)
            .background(
                RoundedRectangle(cornerRadius: Constants.Radius.button)
                    .fill(Constants.Colors.black)
            )
        }
        .buttonStyle(.scale)
    }

}

#if DEBUG
#Preview {
    VStack(spacing: Constants.Padding.sectionSpacing) {
        HomeSectionCardView(section: .mockOpen, onUntrack: {})
        HomeSectionCardView(section: .mockClosed, onUntrack: {})
    }
    .padding(Constants.Padding.screenHorizontal)
}
#endif
