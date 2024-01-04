import UIKit

public enum IterationXEvent {
    case screenshot
    case shake
}

public class IterationX {
    public static let shared = IterationX()
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
                print("Calling handle screenshot class")
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


