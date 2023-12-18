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
                .with(\.backgroundColor, value: .darkGray)
                .with(\.translatesAutoresizingMaskIntoConstraints, value: false)
            
            lazy var titleLabel = UILabel()
                .with(\.text, value: "Need help ?")
                .with(\.textColor, value: .white)
            
            lazy var separator = UIView.separator(color: .darkGray)

            // Retrieve the top-most view controller
            if let topViewController = UIApplication.shared.keyWindow?.rootViewController {
                // Add SendIssueBox to the top view controller's view
                topViewController.view.addSubview(sendIssueBox)
                
                
                sendIssueBox.addSubview(titleLabel)
                sendIssueBox.addSubview(separator)
                
                sendIssueBox.snp.makeConstraints { make in
                    make.center.equalToSuperview()
                }

                titleLabel.snp.makeConstraints { make in
                    make.centerX.equalTo(sendIssueBox)
                    make.top.equalTo(sendIssueBox.snp.topMargin).offset(50)
                }

                separator.snp.makeConstraints { make in
                    make.centerX.equalTo(sendIssueBox)
                    make.top.equalTo(titleLabel.snp.bottomMargin).offset(10) // Adjust the offset as needed
                }
            }
        }
    }
}
