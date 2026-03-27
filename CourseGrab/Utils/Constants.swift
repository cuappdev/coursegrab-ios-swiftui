//
//  Constants.swift
//  CourseGrab
//
//  Created by jiwon jeong on 3/27/26.
//

import SwiftUI

struct Constants {

    enum Colors {
        static let black = Color(red: 27/255, green: 31/255, blue: 35/255)
        static let border = Color(red: 209/255, green: 213/255, blue: 218/255)
        static let darkGray = Color(red: 88/255, green: 96/255, blue: 105/255)
        static let green = Color(red: 71/255, green: 199/255, blue: 83/255)
        static let gray = Color(red: 106/255, green: 115/255, blue: 125/255)
        static let hotlink = Color(red: 74/255, green: 144/255, blue: 226/255)
        static let lightGray = Color(red: 158/255, green: 167/255, blue: 179/255)
        static let mediumGray = Color(red: 118/255, green: 118/255, blue: 118/255)
        static let veryLightGray = Color(red: 225/255, green: 228/255, blue: 232/255)
        static let ruby = Color(red: 202/255, green: 66/255, blue: 56/255)
        static let yellow = Color(red: 253/255, green: 195/255, blue: 41/255)
        static let white = Color(red: 250/255, green: 250/255, blue: 250/255)
    }

    enum Fonts {
        static let regular12 = Font.system(size: 12)
        static let regular14 = Font.system(size: 14)
        static let regular16 = Font.system(size: 16)
        static let regular18 = Font.system(size: 18)

        static let medium12 = Font.system(size: 12, weight: .medium)
        static let medium14 = Font.system(size: 14, weight: .medium)
        static let medium18 = Font.system(size: 18, weight: .medium)
        static let medium20 = Font.system(size: 20, weight: .medium)
        static let medium27 = Font.system(size: 27, weight: .medium)

        static let semibold12 = Font.system(size: 12, weight: .semibold)
        static let semibold14 = Font.system(size: 14, weight: .semibold)
        static let semibold16 = Font.system(size: 16, weight: .semibold)
        static let semibold18 = Font.system(size: 18, weight: .semibold)
        static let semibold20 = Font.system(size: 20, weight: .semibold)

        static let bold12 = Font.system(size: 12, weight: .bold)
        static let bold14 = Font.system(size: 14, weight: .bold)
        static let bold16 = Font.system(size: 16, weight: .bold)
        static let bold20 = Font.system(size: 20, weight: .bold)
        static let bold24 = Font.system(size: 24, weight: .bold)
        static let bold30 = Font.system(size: 30, weight: .bold)
        static let bold36 = Font.system(size: 36, weight: .bold)
        static let bold40 = Font.system(size: 40, weight: .bold)
        static let bold60 = Font.system(size: 60, weight: .bold)
    }

    enum Images {
        // Icons
        static let iconArrow = Image("icon-arrow")
        static let iconBack = Image("icon-back")
        static let iconPopularity = Image("icon-popularity")
        static let iconSearch = Image("icon-search")
        static let iconSettings = Image("icon-settings")

        // Logos
        static let appdevLogoWhite = Image("appdev-logo-white")
        static let appdevWordmark = Image("appdev-wordmark")
        static let courseGrabLogo = Image("coursegrab-logo")
        static let courseGrabReadme = Image("coursegrab-readme")
    }

    enum Padding {
        static let screenHorizontal: CGFloat = 20
        static let cardInset: CGFloat = 18
        static let sectionSpacing: CGFloat = 24
        static let cellVertical: CGFloat = 6
    }

}
