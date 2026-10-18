//
//  Constants.swift
//  CourseGrab
//
//  Created by jiwon jeong on 3/27/26.
//

import SwiftUI

struct Constants {

    // MARK: - Colors (FA26 color styles)

    enum Colors {
        static let black = Color(hex: 0x000000)
        static let white = Color(hex: 0xFFFFFF)
        static let offWhite = Color(hex: 0xFAFAFA)
        static let lightGray = Color(hex: 0xF6F7FB)
        static let bellGray = Color(hex: 0xE1E4E8)
        static let gray = Color(hex: 0xCDD4DD)
        static let darkGray = Color(hex: 0x6A737D)
        static let background = Color(hex: 0x2F2F2F)
        static let green = Color(hex: 0x47C753)
        static let red = Color(hex: 0xCA4238)
        static let yellow = Color(hex: 0xFFD828)
        static let blue = Color(hex: 0x4A90E2)
        static let cancelGray = Color(hex: 0x8D8D8D)
        static let googleText = Color(hex: 0x767676)
        static let scrim = Color.black.opacity(0.25)

        /// Header mesh shader colors, row-major on a 4×4 grid.
        static let headerMesh: [Color] = ([
            0xFF6B6B, 0xFFA36B, 0xFFD16B, 0xFFD166,
            0xB24D99, 0xCC8C80, 0xE5B273, 0x80B259,
            0x6680B2, 0x59A6A6, 0x33A68C, 0x1A8CB2,
            0x05D6A1, 0x1AB2A6, 0x1A99B2, 0x128AB2
        ] as [UInt32]).map { Color(hex: $0) }
    }

    // MARK: - Fonts (SF Pro, FA26 text styles)

    enum Fonts {
        static let h1 = Font.system(size: 20, weight: .medium)
        static let h2 = Font.system(size: 18, weight: .medium)
        static let h3 = Font.system(size: 16, weight: .medium)
        static let h4 = Font.system(size: 16, weight: .regular)
        static let body = Font.system(size: 14, weight: .medium)
        static let label = Font.system(size: 14, weight: .medium)
        static let pin = Font.system(size: 14, weight: .bold)
        static let googleButton = Font.system(size: 14, weight: .regular)
        static let headerTitle = Font.system(size: 24, weight: .medium)
        static let splashWelcome = Font.system(size: 27, weight: .medium)
        static let splashTitle = Font.system(size: 40, weight: .bold)
        static let dialog = Font.system(size: 18, weight: .regular)
        static let stateTitle = Font.system(size: 20, weight: .medium)
        static let stateSubtitle = Font.system(size: 18, weight: .medium)
        static let creditCaption = Font.system(size: 16, weight: .regular)
        static let creditCornell = Font.system(size: 24, weight: .regular)
        static let creditAppDev = Font.system(size: 24, weight: .bold)
        static let banner = Font.system(size: 12, weight: .bold)
    }

    // MARK: - Images

    enum Images {
        // FA26 icons
        static let logoBell = Image("LogoBell")
        static let settings = Image("SettingsIcon")
        static let search = Image("SearchIcon")
        static let clearSearch = Image("ClearSearchIcon")
        static let remove = Image("RemoveIcon")
        static let copy = Image("CopyIcon")
        static let externalLink = Image("ExternalLinkIcon")
        static let externalLinkBlue = Image("ExternalLinkBlueIcon")
        static let rightCaret = Image("RightCaretIcon")
        static let leftCaret = Image("LeftCaretIcon")
        static let waitlist = Image("WaitlistIcon")
        static let trackingOn = Image("TrackingOn")
        static let trackingOff = Image("TrackingOff")
        static let trackBellGray = Image("TrackBellGray")
        static let trackBellWhite = Image("TrackBellWhite")

        // FA26 illustrations and logos
        static let emptyNoInternet = Image("EmptyNoInternet")
        static let emptyNoCourses = Image("EmptyNoCourses")
        static let trackingConfirm = Image("TrackingConfirm")
        static let rocketLogo = Image("RocketLogo")
        static let bellHeroBody = Image("BellHeroBody")
        static let googleLogo = Image("GoogleLogo")
    }

    // MARK: - Spacing

    enum Padding {
        static let screenHorizontal: CGFloat = 24
        static let sectionSpacing: CGFloat = 24
        static let screenBottom: CGFloat = 64
        static let detailTop: CGFloat = 8
    }

    // MARK: - Radii

    enum Radius {
        static let header: CGFloat = 24
        static let modal: CGFloat = 14
        static let card: CGFloat = 10
        static let button: CGFloat = 8
        static let statusSquare: CGFloat = 4
    }

    // MARK: - Borders

    enum Border {
        static let hairline: CGFloat = 0.5
        static let button: CGFloat = 1
    }

    // MARK: - Shadows

    enum Shadow {
        static let dropColor = Color.black.opacity(0.10)
        static let dropRadius: CGFloat = 5
        static let dropY: CGFloat = 2
        static let searchRadius: CGFloat = 1
        static let searchY: CGFloat = 2
        static let modalColor = Color.black.opacity(0.25)
        static let modalRadius: CGFloat = 7.5
        static let modalY: CGFloat = 4
    }

    // MARK: - Status icons

    enum StatusIcon {
        static let iconSize: CGFloat = 18
        static let waitlistIconSize: CGFloat = 22
    }

    // MARK: - Header

    enum Header {
        static let topPadding: CGFloat = 8
        static let horizontalPadding: CGFloat = 24
        static let bottomPadding: CGFloat = 24
        static let spacing: CGFloat = 16
        static let titleSpacing: CGFloat = 4
        static let logoSize = CGSize(width: 25, height: 24)
        static let settingsIconSize: CGFloat = 24
        static let searchIconSize: CGFloat = 16
        static let searchHorizontalPadding: CGFloat = 16
        static let searchVerticalPadding: CGFloat = 12
        static let searchRowSpacing: CGFloat = 12
        static let searchIconSpacing: CGFloat = 8
        static let clearButtonSize: CGFloat = 32
        static let clearIconSize: CGFloat = 20
        static let refreshingBellSize: CGFloat = 120
        /// Overlay opacity of the mesh shader over `Colors.background`.
        static let meshOpacity: Double = 0.5
        /// 4×4 grid of evenly spaced mesh control points (row-major).
        static let meshPoints: [SIMD2<Float>] = [
            [0, 0], [1 / 3, 0], [2 / 3, 0], [1, 0],
            [0, 1 / 3], [1 / 3, 1 / 3], [2 / 3, 1 / 3], [1, 1 / 3],
            [0, 2 / 3], [1 / 3, 2 / 3], [2 / 3, 2 / 3], [1, 2 / 3],
            [0, 1], [1 / 3, 1], [2 / 3, 1], [1, 1]
        ]
    }

    // MARK: - Navigation title bar (Settings, Class detail)

    enum TitleBar {
        static let backIconSize: CGFloat = 30
        static let height: CGFloat = 30
    }

    // MARK: - Pills

    enum Pill {
        static let horizontalPadding: CGFloat = 12
        static let verticalPadding: CGFloat = 10
        static let spacing: CGFloat = 8
    }

    // MARK: - Class card

    enum Card {
        static let padding: CGFloat = 16
        static let spacing: CGFloat = 18
        static let headerSpacing: CGFloat = 8
        static let metaSpacing: CGFloat = 8
        static let removeIconSize: CGFloat = 16
        static let buttonSpacing: CGFloat = 16
        static let buttonHeight: CGFloat = 43
        static let buttonIconSize: CGFloat = 16
        static let buttonContentSpacing: CGFloat = 8
        static let searchTrailingPadding: CGFloat = 8
        static let caretSize: CGFloat = 30
        static let trackedRowVerticalPadding: CGFloat = 12
    }

    // MARK: - Class detail

    enum Detail {
        static let infoSpacing: CGFloat = 16
        static let statusSpacing: CGFloat = 8
        static let discussionSpacing: CGFloat = 32
        static let discussionTextSpacing: CGFloat = 8
        static let trackToggleSize: CGFloat = 28
        static let trackBellSize = CGSize(width: 15, height: 16)
        static let trackButtonHorizontalPadding: CGFloat = 18
        static let trackButtonVerticalPadding: CGFloat = 12
    }

    // MARK: - Empty / error states

    enum EmptyState {
        static let imageSize: CGFloat = 120
        static let spacing: CGFloat = 32
        static let textSpacing: CGFloat = 12
        static let verticalPadding: CGFloat = 40
    }

    // MARK: - Stop-tracking modal

    enum Modal {
        static let width: CGFloat = 300
        static let horizontalPadding: CGFloat = 24
        static let topPadding: CGFloat = 24
        static let bottomPadding: CGFloat = 12
        static let spacing: CGFloat = 24
        static let buttonSpacing: CGFloat = 8
        static let buttonHeight: CGFloat = 43
        static let imageSize: CGFloat = 120
        /// 24pt line height on 18pt text.
        static let lineSpacing: CGFloat = 6
    }

    // MARK: - Settings

    enum Settings {
        static let spacing: CGFloat = 24
        static let actionsSpacing: CGFloat = 20
        static let rowPadding: CGFloat = 12
        static let creditSpacing: CGFloat = 18
        static let creditTextSpacing: CGFloat = 4
        static let creditTracking: CGFloat = 2
        static let rocketSize = CGSize(width: 36.7, height: 79.4)
        static let externalIconSize: CGFloat = 24
        static let footerFont = Font.system(size: 16, weight: .medium)
    }

    // MARK: - Splash / sign-in

    enum Splash {
        static let spacing: CGFloat = 56
        static let heroSpacing: CGFloat = 32
        static let titleSpacing: CGFloat = 8
        static let welcomeTracking: CGFloat = -1
        static let bellSize: CGFloat = 243
        static let googleHorizontalPadding: CGFloat = 24
        static let googleVerticalPadding: CGFloat = 12
        static let googleSpacing: CGFloat = 7
        static let googleLogoSize: CGFloat = 24
        static let googleTracking: CGFloat = 0.16
        static let googleShadowColor = Color.black.opacity(0.17)
        static let googleShadowRadius: CGFloat = 1.5
        static let googleShadowY: CGFloat = 1.5
        static let errorBottomPadding: CGFloat = 12
        static let loadingScale: CGFloat = 1.5
    }

    // MARK: - Bell (hero illustration and wiggle animation)

    enum Bell {
        /// Figma frame of the bell artwork; everything below is in this coordinate space.
        static let artboardSize = CGSize(width: 243, height: 236)
        static let clapperDiameter: CGFloat = 53
        static let clapperOrigin = CGPoint(x: 92, y: 175)
        /// Full wiggle loop length, in seconds.
        static let loopDuration: Double = 2
        /// Ease back to rest when the wiggle is stopped mid-loop.
        static let resetDuration: Double = 0.2
        /// Bell body rotation keyframes: (fraction of loop, radians).
        static let rotationKeyframes: [(time: Double, radians: Double)] = [
            (0.00, 0), (0.07, -0.384), (0.16, 0.297), (0.25, -0.332), (0.34, 0.227),
            (0.43, -0.209), (0.52, 0.122), (0.61, -0.087), (0.70, 0.035), (0.79, 0)
        ]
        /// Clapper translation keyframes: (fraction of loop, offset) in artboard points.
        static let clapperKeyframes: [(time: Double, offset: CGSize)] = [
            (0.00, CGSize(width: 0, height: 0)), (0.09, CGSize(width: -18, height: -6.8)),
            (0.18, CGSize(width: 16, height: 2.8)), (0.27, CGSize(width: -15, height: -5.4)),
            (0.36, CGSize(width: 12, height: 2.4)), (0.45, CGSize(width: -10, height: -3.3)),
            (0.54, CGSize(width: 7, height: 1.6)), (0.63, CGSize(width: -4, height: -1.2)),
            (0.72, CGSize(width: 2, height: 0.5)), (0.83, CGSize(width: 0, height: 0))
        ]
    }

    // MARK: - Banner

    enum Banner {
        static let horizontalPadding: CGFloat = 16
        static let verticalPadding: CGFloat = 12
        static let topPadding: CGFloat = 8
        static let displayNanoseconds: UInt64 = 1_150_000_000
        static let animationDuration: Double = 0.3
    }

    // MARK: - Interaction

    enum Interaction {
        static let pressedScale: CGFloat = 0.96
        static let pressedOpacity: Double = 0.85
        static let pressDuration: Double = 0.12
        static let modalAnimationDuration: Double = 0.2
    }

    // MARK: - URLs

    enum URLs {
        static let studentCenter = URL(string: "https://studentcenter.cornell.edu")
        static let academicCalendar = URL(string: "https://registrar.cornell.edu/academic-calendar")
    }

}
