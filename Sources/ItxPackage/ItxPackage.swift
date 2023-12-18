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
        self.view.backgroundColor = UIColor.from(hex: "#323232")
        
        lazy var titleLabel = UILabel()
            .with(\.text, value: "Need help ?")
            .with(\.textColor, value: .white)
        
        lazy var separator = UIView.separator(color: UIColor.from(hex: "#B5B8BE"))
        
        
        let reportBugButton = UIButton(type: .system)
//            reportBugButton.addTarget(self, action: #selector(didTapReportBugButton), for: .touchUpInside)
        
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
        
        
        self.view.addSubview(titleLabel)
        self.view.addSubview(separator)
        
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.view.snp.leadingMargin).offset(10)
            make.top.equalTo(self.view.snp.topMargin).offset(10)
        }
        
        separator.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottomMargin).offset(10) // Adjust the offset as needed
        }
        
        
        self.view.addSubview(reportBugButton)
        reportBugButton.addSubview(reportBugTitleLabel)
        reportBugButton.addSubview(reportBugDescriptionLabel)
        self.view.addSubview(separator1)
        
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
        
        self.view.addSubview(suggestImprovementButton)
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
        
        self.view.addSubview(cancelButton)
        cancelButton.snp.makeConstraints { make in
            make.top.equalTo(suggestImprovementDescription.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(20)
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


