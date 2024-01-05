import UIKit

public enum IterationXEvent {
    case screenshot
    case shake
}


public protocol IterationXCViewControllerTracking {
    func currentViewController() -> UIViewController?
}


public class ViewControllerHistoryTracker {
    public static let shared = ViewControllerHistoryTracker()
    private var history: [String] = []
    
    func recordViewController(_ viewController: UIViewController) {
        let viewControllerName = NSStringFromClass(type(of: viewController))
        history.append(viewControllerName)
    }
    
    func getHistory() -> [String] {
        return history
    }
    
    func clearHistory() {
        history.removeAll()
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
    
    public func getApiKey() -> String {
        return apiKey ?? ""
    }
}


