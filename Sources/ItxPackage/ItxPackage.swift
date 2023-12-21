import UIKit

public class MySwiftPackage {
    public static let shared = MySwiftPackage()
    private var apiKey: String?
    private var currentEvent: IterationXEvent?

    private init() {}

    public func configure(apiKey: String, event: IterationXEvent, completion: @escaping (Bool) -> Void) {
        isValidApiKey(apiKey) { [weak self] isValid in
            guard let self = self else { return }
            if isValid {
                self.apiKey = apiKey
                self.currentEvent = event
                self.dispatchEvent(event: event)
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    private func dispatchEvent(event: IterationXEvent) {
        switch event {
        case .screenshot:
            NotificationCenter.default.addObserver(
                forName: UIApplication.userDidTakeScreenshotNotification,
                object: nil,
                queue: .main
            ) { _ in
                ScreenshotObserver.handleScreenshot()
            }
        case .shake:
            // Implement shake handling
            break
        }
    }
    
    private func isValidApiKey(_ apiKey: String, completion: @escaping (Bool) -> Void) {
        // Implement API Key validation
        completion(true)
    }
}

public enum IterationXEvent {
    case screenshot
    case shake
}

public class ScreenshotObserver {
    static weak var delegate: EventObserverDelegate?

    static func handleScreenshot() {
        guard let topViewController = UIApplication.shared.keyWindow?.rootViewController?._controller else {
            return
        }
        if let screenshot = captureScreen(view: topViewController.view) {
            delegate?.didDetectScreenshot(image: screenshot)

            DispatchQueue.main.async {
                let controller = PopupViewController(imageView: UIImageView(image: screenshot))
                controller.modalPresentationStyle = .fullScreen
                topViewController.present(controller, animated: true)
            }
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

public protocol EventObserverDelegate: AnyObject {
    func didDetectScreenshot(image: UIImage)
}

extension UIViewController {
    var _controller: UIViewController? {
        if let navigationController = self as? UINavigationController {
            return navigationController.visibleViewController?._controller
        } else if let tabBarController = self as? UITabBarController {
            return tabBarController.selectedViewController?._controller
        } else if let presented = presentedViewController {
            return presented._controller
        } else {
            return self
        }
    }
}
