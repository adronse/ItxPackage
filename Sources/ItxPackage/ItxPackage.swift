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

class ReportButton: UIView
{
    
    private let title: String
    private let reportButtonDescription: String
    private let systemNameIcon: String
    
    // Designated initializer
    init(title: String, reportButtonDescription: String, systemNameIcon: String) {
        self.title = title
        self.reportButtonDescription = reportButtonDescription
        self.systemNameIcon = systemNameIcon
        super.init(frame: .zero) // You can set the frame here or customize it as needed
        setupUI()
        setupGesture()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupGesture()
    {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTap))
        addGestureRecognizer(tapGesture)
        isUserInteractionEnabled = true
    }
    
    private func setupUI() {
        
        let buttonView = UIView()
    
        addSubview(buttonView)
  
        
        let image: UIImageView = {
            let icon = UIImageView()
            if #available(iOS 13.0, *) {
                icon.image = UIImage(systemName: systemNameIcon)
            }
            return icon
        }()
        
        
        lazy var titleLabel = UILabel()
            .with(\.text, value: title)
            .with(\.textColor, value: UIColor.from(hex: "#bbbcbd"))
            .with(\.font, value: .systemFont(ofSize: 16))
    
        
        lazy var descLabel = UILabel()
            .with(\.text, value: reportButtonDescription)
            .with(\.textColor, value: UIColor.from(hex: "#bbbcbd"))
            .with(\.numberOfLines, value: 2)
            .with(\.font, value: .systemFont(ofSize: 12))
        
    
        buttonView.addSubview(titleLabel)
        buttonView.addSubview(descLabel)
        buttonView.addSubview(image)
        
        buttonView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(40)
        }
        
        image.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(5)
            make.top.equalTo(buttonView.snp.top).offset(5)
            
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(image.snp.trailing)
            make.top.equalTo(buttonView.snp.top).offset(5)
        }
        
        descLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel).offset(5)
            make.top.equalTo(titleLabel.snp.bottom)
            make.bottom.lessThanOrEqualTo(buttonView.snp.bottom).offset(-5) // Ensure bottom space
        }
    }
    
    @objc private func didTap()
    {
        
    }
}


class DummyController: UIViewController {
    
    
    private let imageView: UIImageView
    
    
    init(imageView: UIImageView) {
        self.imageView = imageView
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    let popupView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.from(hex: "#333333")
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    lazy var popupTitle = UILabel()
        .with(\.text, value: "Need help?")
        .with(\.textColor, value: UIColor.from(hex: "#dedfe0"))
        .with(\.font, value: .systemFont(ofSize: 12))
    
    
    lazy var separator1 = UIView.separator(color: .white)
    
    lazy var separator2 = UIView.separator(color: .white)
    
    lazy var reportBugButton = ReportButton(title: "Report a bug", reportButtonDescription: "Something in the app is broken or doesn't work as expected", systemNameIcon: "ladybug")
    
    lazy var proposeEnhancementButton = ReportButton(title: "Suggest an improvement", reportButtonDescription: "New ideas or desired enhancements for this app", systemNameIcon: "megaphone")

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set the background color (optional)
        view.backgroundColor = .clear

        // Add the popup view to the view hierarchy
        view.addSubview(popupView)

        
        popupView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(330)
            make.height.equalTo(300)
        }
        
        // Customize the appearance of the popup view
        configurePopupView()
    }

    func configurePopupView() {
        popupView.addSubview(popupTitle)
        popupView.addSubview(separator1)
        popupView.addSubview(reportBugButton)
        popupView.addSubview(proposeEnhancementButton)
        popupView.addSubview(separator2)
    
        
        popupTitle.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalTo(popupView.snp.leading).offset(5)
        }
        
        separator1.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
            make.top.equalTo(popupTitle.snp.bottom).offset(50)
        }
        
        reportBugButton.snp.makeConstraints { make in
            make.leading.trailing.equalTo(popupView).offset(5)
            make.top.equalTo(separator1.snp.bottom).offset(2)
        }
        
        separator2.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
            make.top.equalTo(reportBugButton.snp.bottom).offset(50)
        }
        
        proposeEnhancementButton.snp.makeConstraints { make in
            make.top.equalTo(separator2.snp.bottom).offset(2)
            make.leading.trailing.equalTo(popupView).offset(5)
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
                let controller = DummyController(imageView: UIImageView(image: screenshot))

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


