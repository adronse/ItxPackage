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
        
        
        lazy var imageView = UIImageView()
        
        
        // Retrieve the top-most view controller
        if let topViewController = UIApplication.shared.keyWindow?.rootViewController {
            
            
            if let screenshot = captureScreen(view: topViewController.view) {
                // Do something with the screenshot, e.g., save it, display it, etc.
                // For now, let's print the image data size
                if let jpegData = screenshot.jpegData(compressionQuality: 1.0) {
                    print("Captured screenshot with size: \(jpegData.count) bytes")
                }
                
                topViewController.view.addSubview(imageView)
                imageView.image = screenshot
                
                imageView.snp.makeConstraints { make in
                    make.edges.equalToSuperview()
                }
            
            }
            
            
            
//            let issueBox = IssueBoxView()
//            topViewController.view.addSubview(issueBox)
//            
//            issueBox.snp.makeConstraints { make in
//                make.centerX.equalToSuperview()
//                make.centerY.equalToSuperview()
//                make.width.equalTo(300)
//                make.height.equalTo(250)
//                
//            }
        }
    }
    
    static func captureScreen(view: UIView) -> UIImage? {
        // Capture the screen as an image
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, 0.0)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let screenshot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return screenshot
    }
}
