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
        
        
        @objc static func didTapCancelButton()
        {
            
        }
        
        
        @objc static func detectScreenshot() {
            // Create SendIssueBox view
            lazy var sendIssueBox = UIView()
                .with(\.backgroundColor, value: UIColor.from(hex: "#41403F", alpha: 1))
                .with(\.layer.cornerRadius, value: 8)
            
            lazy var titleLabel = UILabel()
                .with(\.text, value: "Need help ?")
                .with(\.textColor, value: .white)
            
            lazy var separator = UIView.separator(color: UIColor.from(hex: "#B5B8BE"))
            
            
            let reportBugButton = UIButton(type: .system)
            reportBugButton.setTitle("Report a bug", for: .normal)
            reportBugButton.setTitleColor(UIColor.white, for: .normal)

            let reportBugDescriptionLabel = UILabel()
                .with(\.text, value: "Something in the app is broken or doesn't work as expected")
                .with(\.textColor, value: UIColor.gray)
                .with(\.numberOfLines, value: 0) // Allow multiline text

            // Create separator for the first row
            let separator1 = UIView.separator(color: UIColor.gray)
            

            // Retrieve the top-most view controller
            if let topViewController = UIApplication.shared.keyWindow?.rootViewController {
                // Add SendIssueBox to the top view controller's view
                topViewController.view.addSubview(sendIssueBox)
                
                
                sendIssueBox.addSubview(titleLabel)
                sendIssueBox.addSubview(separator)
                
                sendIssueBox.snp.makeConstraints { make in
                    make.centerX.equalToSuperview()
                    make.centerY.equalToSuperview()
                    make.width.equalTo(300)
                    make.height.equalTo(200)
                }

                titleLabel.snp.makeConstraints { make in
                    make.leading.equalTo(sendIssueBox.snp.leadingMargin).offset(10)
                    make.top.equalTo(sendIssueBox.snp.topMargin).offset(50)
                }

                separator.snp.makeConstraints { make in
                    make.centerX.equalTo(sendIssueBox)
                    make.top.equalTo(titleLabel.snp.bottomMargin).offset(10) // Adjust the offset as needed
                }
                
                // Add buttons and separator to the sendIssueBox
                sendIssueBox.addSubview(reportBugButton)
                sendIssueBox.addSubview(reportBugDescriptionLabel)
                sendIssueBox.addSubview(separator1)

                // Position the buttons and separator for the first row
                reportBugButton.snp.makeConstraints { make in
                    make.top.equalTo(separator.snp.bottom).offset(20) // Adjust the offset as needed
                    make.leading.equalTo(sendIssueBox.snp.leadingMargin).offset(10) // Adjust the offset as needed
                }

                reportBugDescriptionLabel.snp.makeConstraints { make in
                    make.top.equalTo(reportBugButton.snp.bottom).offset(5) // Adjust the offset as needed
                    make.leading.trailing.equalTo(sendIssueBox).inset(10)
                }

                separator1.snp.makeConstraints { make in
                    make.top.equalTo(reportBugDescriptionLabel.snp.bottom).offset(20) // Adjust the offset as needed
                    make.leading.trailing.equalTo(sendIssueBox)
                    make.height.equalTo(1)
                }
            }
        }
    }
}
