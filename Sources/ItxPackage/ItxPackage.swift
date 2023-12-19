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


public class ReportButton: UIView {

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

    private func setupGesture() {
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
            .with(\.font, value: .systemFont(ofSize: 16, weight: .bold))

        lazy var descLabel = UILabel()
            .with(\.text, value: reportButtonDescription)
            .with(\.textColor, value: UIColor.from(hex: "#bbbcbd"))
            .with(\.numberOfLines, value: 0)
            .with(\.font, value: .systemFont(ofSize: 12, weight: .light))

        buttonView.addSubview(titleLabel)
        buttonView.addSubview(descLabel)
        buttonView.addSubview(image)

        buttonView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
        }

        image.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(5)
            make.top.equalTo(buttonView.snp.top).offset(5)
        }

        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(image.snp.trailing).offset(5)
            make.top.equalTo(buttonView.snp.top).offset(5)
        }

        descLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().offset(5)
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
        }
    }

    @objc private func didTap() {
        // Handle tap gesture
    }
}


class DummyController: UIViewController {
    
    
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
            make.height.equalTo(300)
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
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(image.snp.trailing).offset(5)
            make.trailing.equalToSuperview().inset(5)
            make.top.equalToSuperview().offset(5)
            make.bottom.equalTo(descLabel.snp.top).inset(5)
        }
        
        descLabel.snp.makeConstraints { make in
            make.leading.equalTo(image.snp.trailing).offset(5)
            make.trailing.equalToSuperview().inset(5)
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
        }
    }
}

extension DummyController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
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
        tableView.deselectRow(at: indexPath, animated: true)
        
        // Handle cell selection, e.g., show a new view controller based on the selected report button
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
                
                controller.modalPresentationStyle = .fullScreen
                
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


