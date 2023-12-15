// Sources/MySwiftPackage/MySwiftPackage.swift

import UIKit

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
            let alertController = UIAlertController(title: "Woow screenshot bro", message: "screenshot", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .cancel))
            
            // Retrieve the top-most view controller to present the alert
            if let topViewController = UIApplication.shared.keyWindow?.rootViewController {
                topViewController.present(alertController, animated: true, completion: nil)
            }
        }
    }
}
