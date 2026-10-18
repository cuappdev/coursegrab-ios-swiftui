//
//  View+ErrorAlert.swift
//  CourseGrab
//
//  Created by jiwon jeong on 10/18/26.
//

import SwiftUI

/// Presents a view model's `errorMessage` as a standard alert and clears it on dismiss.
struct ErrorAlertModifier: ViewModifier {

    // MARK: - Properties

    @Binding var message: String?

    private var isPresented: Binding<Bool> {
        Binding(
            get: { message != nil },
            set: { if !$0 { message = nil } }
        )
    }

    // MARK: - UI

    func body(content: Content) -> some View {
        content
            .alert("Something Went Wrong", isPresented: isPresented, presenting: message) { _ in
                Button("OK", role: .cancel) {}
            } message: { message in
                Text(message)
            }
    }

}

extension View {

    func errorAlert(_ message: Binding<String?>) -> some View {
        modifier(ErrorAlertModifier(message: message))
    }

}
