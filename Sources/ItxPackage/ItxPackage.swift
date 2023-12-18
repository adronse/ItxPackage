// Sources/MySwiftPackage/MySwiftPackage.swift

import UIKit
import SnapKit




public class ImageViewController : UIViewController {
    
    private let imageView: UIImageView
    
    init(image: UIImage) {
        self.imageView = UIImageView(image: image)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow
        
        
        view.addSubview(imageView)
        
        imageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(40)
        }
    }
}

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

    static var imageView = UIImageView()

    @objc static func didTapCancelButton() {
        // Handle cancel button tap if needed
    }

    @objc static func detectScreenshot() {
        // Retrieve the top-most view controller
        if let topViewController = UIApplication.shared.keyWindow?.rootViewController {

            if let screenshot = captureScreen(view: topViewController.view) {
                // Do something with the screenshot, e.g., save it, display it, etc.
                // For now, let's print the image data size
                if let jpegData = screenshot.jpegData(compressionQuality: 1.0) {
                    print("Captured screenshot with size: \(jpegData.count) bytes")
                }

                // Assign the screenshot to the imageView
                imageView.image = screenshot

                // Create and push the ImageViewController
                let imageController = IssueBoxView(image: screenshot)
                if let navigationController = topViewController.navigationController {
                    navigationController.modalPresentationStyle = .formSheet
                    navigationController.pushViewController(imageController, animated: true)
                } else {
                    // If there's no navigation controller, present the ImageViewController
                    topViewController.present(imageController, animated: true, completion: nil)
                }
            }
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

