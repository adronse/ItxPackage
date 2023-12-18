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
//            reportBugButton.addTarget(self, action: #selector(reportBugButtonTapped), for: .touchUpInside)

            let reportBugTitleLabel = UILabel()
                .with(\.text, value: "Report a bug")
                .with(\.textColor, value: UIColor.white)

            let reportBugDescriptionLabel = UILabel()
                .with(\.text, value: "Something in the app is broken or doesn't work as expected")
                .with(\.textColor, value: UIColor.gray)
                .with(\.numberOfLines, value: 0) // Allow multiline text

            let separator1 = UIView.separator(color: UIColor.gray)
            
            // Create buttons for the second row ("Suggest an improvement")
            let suggestImprovementButton = UIButton(type: .system)
            // suggestImprovementButton.addTarget(self, action: #selector(suggestImprovementButtonTapped), for: .touchUpInside)
            
            let suggestImprovementTitle = UILabel()
                .with(\.text, value: "Suggest an improvement")
                .with(\.textColor, value: UIColor.white)

            let suggestImprovementDescription = UILabel()
                .with(\.text, value: "New ideas or desired enhancements for this app")
                .with(\.textColor, value: UIColor.gray)
                .with(\.numberOfLines, value: 0) // Allow multiline text
    
            let cancelButton = UIButton(type: .system)
            
            
            cancelButton.setTitle("Cancel", for: .normal)
            cancelButton.setTitleColor(UIColor.white, for: .normal)

            
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
                    make.top.equalTo(sendIssueBox.snp.topMargin).offset(10)
                }

                separator.snp.makeConstraints { make in
                    make.centerX.equalTo(sendIssueBox)
                    make.top.equalTo(titleLabel.snp.bottomMargin).offset(10) // Adjust the offset as needed
                }
                
                
                sendIssueBox.addSubview(reportBugButton)
                reportBugButton.addSubview(reportBugTitleLabel)
                reportBugButton.addSubview(reportBugDescriptionLabel)
                sendIssueBox.addSubview(separator1)
                
                reportBugButton.snp.makeConstraints { make in
                    make.top.equalTo(separator.snp.bottom)
                    make.leading.trailing.equalToSuperview()
                    make.bottom.equalTo(separator1.snp.bottom)
                }

                reportBugTitleLabel.snp.makeConstraints { make in
                    make.top.equalTo(reportBugButton).offset(10)
                    make.leading.equalTo(reportBugButton).offset(10)
                }

                reportBugDescriptionLabel.snp.makeConstraints { make in
                    make.top.equalTo(reportBugTitleLabel.snp.bottom).offset(5)
                    make.leading.trailing.equalTo(reportBugButton).inset(10)
                }

                separator1.snp.makeConstraints { make in
                    make.top.equalTo(reportBugDescriptionLabel.snp.bottom).offset(20)
                    make.leading.trailing.equalTo(reportBugButton)
                    make.height.equalTo(1)
                }
                
                sendIssueBox.addSubview(suggestImprovementButton)
                suggestImprovementButton.addSubview(suggestImprovementTitle)
                suggestImprovementButton.addSubview(suggestImprovementDescription)
                
                suggestImprovementButton.snp.makeConstraints { make in
                    make.top.equalTo(separator1.snp.bottom)
                    make.leading.trailing.equalToSuperview()
                }
                
                suggestImprovementTitle.snp.makeConstraints { make in
                    make.top.equalTo(suggestImprovementButton).offset(10)
                    make.leading.equalTo(suggestImprovementButton).offset(10)
                }
                
                suggestImprovementDescription.snp.makeConstraints { make in
                    make.top.equalTo(suggestImprovementTitle.snp.bottom).offset(5)
                    make.leading.trailing.equalTo(suggestImprovementButton).inset(10)
                }
                
                sendIssueBox.addSubview(cancelButton)
                cancelButton.snp.makeConstraints { make in
                    make.top.equalTo(suggestImprovementDescription.snp.bottom)
                    make.leading.trailing.equalToSuperview()
                    make.height.equalTo(20)
                }
                
            }
        }
    }
