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
            

           lazy var SendIssueBox = UIView()
                .with(\.backgroundColor, value: .red)
            
            // Retrieve the top-most view controller to present the alert
            if let topViewController = UIApplication.shared.keyWindow?.rootViewController {
                topViewController.view.addSubview(SendIssueBox)
                
                SendIssueBox.snp.makeConstraints { make in
                    make.center.equalTo(topViewController.view)
                    make.width.height.equalTo(50)
                }
            }
        }
    }
}
