//
//  MailComposerView.swift
//  CourseGrab
//
//  Created by jiwon jeong on 3/28/26.
//

import MessageUI
import SwiftUI

struct MailComposerView: UIViewControllerRepresentable {

    // MARK: - Properties

    let recipient: String
    let subject: String
    @Environment(\.dismiss) private var dismiss

    // MARK: - UIViewControllerRepresentable

    func makeUIViewController(context: Context) -> MFMailComposeViewController {
        let vc = MFMailComposeViewController()
        vc.mailComposeDelegate = context.coordinator
        vc.setToRecipients([recipient])
        vc.setSubject(subject)
        return vc
    }

    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(dismiss: dismiss)
    }

    // MARK: - Coordinator

    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        let dismiss: DismissAction
        init(dismiss: DismissAction) { self.dismiss = dismiss }

        func mailComposeController(
            _ controller: MFMailComposeViewController,
            didFinishWith result: MFMailComposeResult,
            error: Error?
        ) {
            dismiss()
        }
    }

}
