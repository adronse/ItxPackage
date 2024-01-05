import UIKit

public enum IterationXEvent {
    case screenshot
}

import UIKit

extension UIViewController {
    
    @objc func itx_tracked_viewWillAppear(_ animated: Bool) {
        
        
        
        print("IterationX tracking this screen: \(type(of: self))")
        
        if self is UIViewController {
            itx_tracked_viewWillAppear(animated)
        }
        // Call the original viewWillAppear
    }
    
    static func itx_enableSwizzling() {
        let originalSelector = #selector(UIViewController.viewWillAppear(_:))
        let swizzledSelector = #selector(UIViewController.itx_tracked_viewWillAppear(_:))
        
        guard let originalMethod = class_getInstanceMethod(UIViewController.self, originalSelector),
              let swizzledMethod = class_getInstanceMethod(UIViewController.self, swizzledSelector) else {
            return
        }
        
        method_exchangeImplementations(originalMethod, swizzledMethod)
    }
}


public class IterationX {
    public static let shared = IterationX()
    private var apiKey: String?
    private var currentEvent: IterationXEvent?
    private var isFlowActive: Bool = false
    
    private init() {}
    
    
    public func setFlowActive(_ isActive: Bool) {
        isFlowActive = isActive
    }
    
    public func getFlowActive() -> Bool {
        return isFlowActive
    }
    
    
    public func configure(apiKey: String, event: IterationXEvent) -> Void {
        self.currentEvent = event
        self.dispatchEvent(event: event)
    }
    
    static var didDetectScreenshotCoordinator: DidDetectScreenshotCoordinator?
    
    public static func initializeScreenshotHandling() {
        didDetectScreenshotCoordinator = DidDetectScreenshotCoordinator()
        ScreenshotObserver.delegate = didDetectScreenshotCoordinator
    }
    
    public static func enableViewControllerTracking()
    {
        UIViewController.itx_enableSwizzling()
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
        }
    }
    
    private func isValidApiKey(_ apiKey: String, completion: @escaping (Bool) -> Void) {
        // Implement API Key validation
        completion(true)
    }
    
    public func getApiKey() -> String {
        return apiKey ?? ""
    }
}


