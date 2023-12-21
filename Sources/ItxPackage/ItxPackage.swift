// Sources/MySwiftPackage/MySwiftPackage.swift

import UIKit
import SnapKit
import CoreMotion


public enum IterationXEvent {
    case screenshot
    case shake
}


public struct MySwiftPackage {
    public static var apiKey: String?
    public static var currentEvent: IterationXEvent?
    
    public init(apiKey: String, event: IterationXEvent) {
        guard MySwiftPackage.isGUID(apiKey) else {
            fatalError("Invalid API key. Please provide a valid GUID.")
        }
        
        MySwiftPackage.apiKey = apiKey
        MySwiftPackage.currentEvent = event
        
        MySwiftPackage.dispatchEvent(event: event)
    
        
    }
    
    private static func dispatchEvent(event: IterationXEvent) {
        if event == .screenshot {
            let _ = NotificationCenter.default.addObserver(
                forName: UIApplication.userDidTakeScreenshotNotification,
                object: nil,
                queue: .main
            ) { _ in
                EventObserver.detectScreenshot()
            }
        }
    }
    
    private static func isGUID(_ apiKey: String) -> Bool {
        
        let client = GraphQLClient(url: URL(string: "https://api.itx.coffee/graphql")!)
        
        let query = """
        {
            __typename
        }
        """
        
        client.performQuery(query: query) { result in
            switch result {
            case .success(let response):
                print("GraphQL Response: \(response)")
            case .failure(let error):
                print("Error performing GraphQL query: \(error)")
            }
        }
        
        return apiKey.count == 36
    }
}

public class EventObserver {
    static weak var delegate: EventObserverDelegate?
    
    @objc static func detectScreenshot() {
        if let keyWindow = UIApplication.shared.windows.first(where: { $0.isKeyWindow }),
           let topViewController = keyWindow.rootViewController?.itx_visibleViewController,
           let screenshot = captureScreen(view: topViewController.view) {
            if let jpegData = screenshot.jpegData(compressionQuality: 1.0) {
                print("Captured screenshot with size: \(jpegData.count) bytes")
            }
            
            delegate?.didDetectScreenshot(image: screenshot)
            
            
            let controller = PopupViewController(imageView: UIImageView(image: screenshot))
            controller.modalPresentationStyle = .fullScreen
            topViewController.present(controller, animated: true)
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


protocol EventObserverDelegate: AnyObject {
    func didDetectScreenshot(image: UIImage)
}

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






