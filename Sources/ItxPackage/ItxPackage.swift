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
                .with(\.placeholder, value: "Title")
                .with(\.borderStyle, value: .roundedRect)
                .with(\.translatesAutoresizingMaskIntoConstraints, value: false)
            
            // Create description input field
            let descriptionTextField = UITextField()
                .with(\.placeholder, value: "Description")
                .with(\.borderStyle, value: .roundedRect)
                .with(\.translatesAutoresizingMaskIntoConstraints, value: false)
            
            // Retrieve the top-most view controller
            if let topViewController = UIApplication.shared.keyWindow?.rootViewController {
                // Add SendIssueBox to the top view controller's view
                topViewController.view.addSubview(sendIssueBox)
                
                // Add title and description text fields to SendIssueBox
                sendIssueBox.addSubview(titleTextField)
                sendIssueBox.addSubview(descriptionTextField)
                
                // Set up constraints for SendIssueBox
                sendIssueBox.snp.makeConstraints { make in
                    make.centerX.equalToSuperview()
                    make.centerY.equalToSuperview()
                    make.width.equalTo(300) // Adjust the width as needed
                    make.height.equalTo(200) // Adjust the height as needed
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
            }
        }
    }
}
