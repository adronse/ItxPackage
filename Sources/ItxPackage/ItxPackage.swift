// Sources/MySwiftPackage/MySwiftPackage.swift

import UIKit
import SnapKit

public struct MySwiftPackage {
    
    public init() {
        let _ = NotificationCenter.default.addObserver(
            forName: UIApplication.userDidTakeScreenshotNotification,
            object: nil,
            queue: .main
        ) { _ in
            ScreenshotObserver.detectScreenshot()
        }
    }
    

    public class ScreenshotObserver {
        @objc static func detectScreenshot() {
            // Create SendIssueBox view
            let sendIssueBox = UIView()
                .with(\.backgroundColor, value: .red)
                .with(\.translatesAutoresizingMaskIntoConstraints, value: false)

            // Create title input field
            let titleTextField = UITextField()
                // ... (Previous code)

            // Create description input field
            let descriptionTextField = UITextField()
                // ... (Previous code)

            // Create Send button
            let cancelButton = UIButton
                .primary(text: "Cancel")
                .with(\.backgroundColor, value: .red)
                .with(\.tintColor, value: .white)

            // Create Send button
            let sendButton = UIButton
                .primary(text: "Send")
                .with(\.backgroundColor, value: .green)
                .with(\.tintColor, value: .white)

            // Retrieve the top-most view controller
            if let topViewController = UIApplication.shared.keyWindow?.rootViewController {
                // Add SendIssueBox to the top view controller's view
                topViewController.view.addSubview(sendIssueBox)

                // Add title and description text fields to SendIssueBox
                sendIssueBox.addSubview(titleTextField)
                sendIssueBox.addSubview(descriptionTextField)
                sendIssueBox.addSubview(cancelButton)
                sendIssueBox.addSubview(sendButton)

                // Set up constraints for SendIssueBox
                sendIssueBox.snp.makeConstraints { make in
                    make.centerX.equalToSuperview()
                    make.centerY.equalToSuperview()
                    make.width.equalTo(300) // Adjust the width as needed
                    make.height.equalTo(250) // Adjust the height as needed
                }

                // Set up constraints for titleTextField
                titleTextField.snp.makeConstraints { make in
                    make.top.equalTo(sendIssueBox).offset(20)
                    make.leading.trailing.equalTo(sendIssueBox).inset(20)
                    make.height.equalTo(30)
                }

                // Set up constraints for descriptionTextField
                descriptionTextField.snp.makeConstraints { make in
                    make.top.equalTo(titleTextField.snp.bottom).offset(10)
                    make.leading.trailing.equalTo(sendIssueBox).inset(20)
                    make.height.equalTo(30)
                }

                // Set up constraints for Cancel button
                cancelButton.snp.makeConstraints { make in
                    make.bottom.equalTo(sendIssueBox).offset(-20)
                    make.leading.equalTo(sendIssueBox).offset(20)
                    make.width.equalTo(100)
                    make.height.equalTo(40)
                }

                // Set up constraints for Send button
                sendButton.snp.makeConstraints { make in
                    make.bottom.equalTo(sendIssueBox).offset(-20)
                    make.trailing.equalTo(sendIssueBox).offset(-20)
                    make.width.equalTo(100)
                    make.height.equalTo(40)
                }
            }
        }
    }
}
