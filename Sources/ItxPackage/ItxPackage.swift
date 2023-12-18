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

import UIKit

class DummyController: UIViewController {

    let popupView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    lazy var popupTitle = UILabel()
        .with(\.text, value: "Need help?")
        .with(\.textColor, value: UIColor.from(hex: "#dedfe0"))
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set the background color (optional)
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)

        // Add the popup view to the view hierarchy
        view.addSubview(popupView)

        
        popupView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(300)
            make.height.equalTo(150)
        }
        
        // Customize the appearance of the popup view
        configurePopupView()
    }

    func configurePopupView() {
        popupView.addSubview(popupTitle)
        
        popupTitle.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalTo(popupView.snp.leading).offset(5)
        }
    }

    @objc func closeButtonTapped() {
        dismiss(animated: true, completion: nil)
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


