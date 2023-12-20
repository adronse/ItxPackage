// Sources/MySwiftPackage/MySwiftPackage.swift

import UIKit
import SnapKit
import CoreMotion


class PopupViewController: UIViewController {
    
    private let imageView: UIImageView
    
    private let reportButtonData = [
        ("Report a bug", "Something in the app is broken or doesn't work as expected", "ladybug"),
        ("Suggest an improvement", "New ideas or desired enhancements for this app", "megaphone")
    ]
    
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
        .with(\.font, value: .systemFont(ofSize: 18))
    
    
    
    lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("Cancel", for: .normal)
        button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .singleLine
        return tableView
    }()
    
    
    
    @objc func closeButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear
        modalPresentationStyle = .fullScreen
        
        view.addSubview(popupView)
        
        
        popupView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(330)
            make.height.equalTo(280)
        }
        
        // Customize the appearance of the popup view
        configurePopupView()
    }
    
    func configurePopupView() {
        popupView.addSubview(popupTitle)
        popupView.addSubview(cancelButton)
        
        tableView.register(ReportButtonCell.self, forCellReuseIdentifier: "ReportButtonCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isScrollEnabled = false
        tableView.backgroundColor = .clear
        
        
        view.backgroundColor = .clear
        modalPresentationStyle = .fullScreen
        
        popupView.addSubview(tableView)
        
        
        popupTitle.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(5)
            make.leading.equalTo(popupView.snp.leading).offset(10)
        }
        
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(popupTitle.snp.bottom).offset(50)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(cancelButton.snp.top).inset(5)
        }
        
        
        cancelButton.snp.makeConstraints { make in
            make.centerX.equalTo(popupView.snp.centerX)
            make.bottom.equalTo(popupView.snp.bottom).inset(10)
        }
    }
}


class ReportButtonCell: UITableViewCell {
    
    func configure(title: String, description: String, iconName: String) {
        backgroundColor = .clear
        
        let image: UIImageView = {
            let icon = UIImageView()
            if #available(iOS 13.0, *) {
                icon.image = UIImage(systemName: iconName)
            }
            icon.contentMode = .scaleAspectFit // Set content mode to scale aspect fit
            return icon
        }()
        
        lazy var titleLabel = UILabel()
            .with(\.text, value: title)
            .with(\.textColor, value: UIColor.from(hex: "#bbbcbd"))
            .with(\.font, value: .systemFont(ofSize: 16, weight: .bold))
        
        lazy var descLabel = UILabel()
            .with(\.text, value: description)
            .with(\.textColor, value: UIColor.from(hex: "#bbbcbd"))
            .with(\.numberOfLines, value: 0)
            .with(\.font, value: .systemFont(ofSize: 12, weight: .light))
        
        addSubview(image)
        addSubview(titleLabel)
        addSubview(descLabel)
        
        image.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(5)
            make.top.equalToSuperview().offset(5)
            make.bottom.lessThanOrEqualToSuperview().offset(-5)
            make.width.equalTo(image.snp.height) // Set a fixed aspect ratio
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(image.snp.trailing).offset(5)
            make.trailing.equalToSuperview().inset(5)
            make.top.equalToSuperview().offset(5)
        }
        
        descLabel.snp.makeConstraints { make in
            make.leading.equalTo(image.snp.trailing).offset(5)
            make.trailing.equalToSuperview().inset(5)
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.bottom.lessThanOrEqualToSuperview().offset(-5)
        }
    }
}




extension PopupViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reportButtonData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReportButtonCell", for: indexPath) as! ReportButtonCell
        
        let (title, description, iconName) = reportButtonData[indexPath.row]
        cell.configure(title: title, description: description, iconName: iconName)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Handle cell selection if needed
        print("Selected row at index: \(indexPath.row)")
        
        // For example, if the user clicks on the first cell, present a new view controller
        if indexPath.row == 0 {
            let controller = IssueCreationViewController(image: self.imageView, viewControllerTitle: "Report bug")
            present(controller, animated: true, completion: nil)
        }
        
        if indexPath.row == 1 {
            let controller = IssueCreationViewController(image: self.imageView, viewControllerTitle: "Report bug")
            present(controller, animated: true, completion: nil)
        }
    }
}



public struct MySwiftPackage {
    public static var apiKey: String?
    public static var currentEvent: IterationXEvent?

    public init(apiKey: String, event: IterationXEvent) {
        guard MySwiftPackage.isGUID(apiKey) else {
            fatalError("Invalid API key. Please provide a valid GUID.")
        }

        // Your package initialization and configuration logic here based on the event type

        MySwiftPackage.apiKey = apiKey
        MySwiftPackage.currentEvent = event

        // Call the method to set up event detection based on the provided event type
        MySwiftPackage.dispatchEvent(event: event)
    }

    private static func dispatchEvent(event: IterationXEvent) {
        if event == .screenshot {
            let _ = NotificationCenter.default.addObserver(
                forName: UIApplication.userDidTakeScreenshotNotification,
                object: nil,
                queue: .main
            ) { _ in
                ScreenshotObserver.detectScreenshot()
            }
        }
    }

    private static func isGUID(_ apiKey: String) -> Bool {
        return apiKey.count == 36
    }
}

public enum IterationXEvent {
    case screenshot
}

public class ScreenshotObserver {

    static weak var delegate: ScreenshotObserverDelegate?

    @objc static func detectScreenshot() {
        if let keyWindow = UIApplication.shared.windows.first(where: { $0.isKeyWindow }),
           let topViewController = keyWindow.rootViewController?.itx_visibleViewController,
           let screenshot = captureScreen(view: topViewController.view) {
            if let jpegData = screenshot.jpegData(compressionQuality: 1.0) {
                print("Captured screenshot with size: \(jpegData.count) bytes")
            }

            delegate?.didDetectScreenshot(image: screenshot)
        }
    }

    static func captureScreen(view: UIView) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, 0.0)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let screenshot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return screenshot
    }
}


protocol ScreenshotObserverDelegate: AnyObject {
    func didDetectScreenshot(image: UIImage)
}

// Extension to find the top-most visible view controller
extension UIViewController {
    var itx_visibleViewController: UIViewController? {
        if let navigationController = self as? UINavigationController {
            return navigationController.visibleViewController?.itx_visibleViewController
        } else if let tabBarController = self as? UITabBarController {
            return tabBarController.selectedViewController?.itx_visibleViewController
        } else {
            if let presentedViewController = presentedViewController {
                return presentedViewController.itx_visibleViewController
            } else {
                return self
            }
        }
    }
}






