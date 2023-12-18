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


import UIKit

class DummyController: UIViewController {

    // Your UI elements go here

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set modal presentation style
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve

        // Configure appearance
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 10

        // Add UI elements to the view hierarchy and configure constraints
        // For simplicity, I'm adding a UILabel and a Close button as an example
        let titleLabel = UILabel()
        titleLabel.text = "Custom Alert"
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)

        let closeButton = UIButton(type: .system)
        closeButton.setTitle("Close", for: .normal)
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(closeButton)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            closeButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            closeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }

    @objc func closeButtonTapped() {
        dismiss(animated: true, completion: nil)
        // Handle other actions if needed
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
        // Retrieve the top-most visible view controller
        if let topViewController = UIApplication.shared.keyWindow?.rootViewController?.itx_visibleViewController {
            if let screenshot = captureScreen(view: topViewController.view) {
                // Do something with the screenshot, e.g., save it, display it, etc.
                // For now, let's print the image data size
                if let jpegData = screenshot.jpegData(compressionQuality: 1.0) {
                    print("Captured screenshot with size: \(jpegData.count) bytes")
                }

                // Create and present the DummyController
                let controller = DummyController()

                topViewController.present(controller, animated: true)
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


extension UIViewController {
    var itx_visibleViewController: UIViewController? {
        if let navigationController = self as? UINavigationController {
            return navigationController.visibleViewController
        }
        if let tabBarController = self as? UITabBarController {
            return tabBarController.selectedViewController
        }
        if let presentedViewController = presentedViewController {
            return presentedViewController.itx_visibleViewController
        }
        return self
    }
}


