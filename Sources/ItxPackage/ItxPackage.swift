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
            // Create and present a modal with title and description inputs
            let alertController = UIAlertController(title: "Woow screenshot bro", message: "screenshot", preferredStyle: .alert)

            // Add text fields for title and description
            alertController.addTextField { textField in
                textField.placeholder = "Title"
            }
            alertController.addTextField { textField in
                textField.placeholder = "Description"
            }

            // Add "Send" and "Cancel" buttons
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            alertController.addAction(UIAlertAction(title: "Send", style: .default) { _ in
                // Handle the "Send" button action here, if needed
                if let titleTextField = alertController.textFields?.first?.text,
                   let descriptionTextField = alertController.textFields?.last?.text {
                    // Do something with the entered title and description
                    print("Title: \(titleTextField), Description: \(descriptionTextField)")
                }
            })

            // Retrieve the top-most view controller to present the alert
            if let topViewController = UIApplication.shared.keyWindow?.rootViewController {
                topViewController.present(alertController, animated: true, completion: nil)
            }
        }
    }
}
