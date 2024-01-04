//
//  File.swift
//  
//
//  Created by Adrien Ronse on 04/01/2024.
//

import Foundation
import UIKit


public class ScreenshotObserver {
    static weak var delegate: EventObserverDelegate?

    static func handleScreenshot() {
        guard let topViewController = UIApplication.shared.topMostViewController else {
            return
        }
        if let screenshot = captureScreen(view: topViewController.view) {
            delegate?.didDetectScreenshot(image: screenshot, from: topViewController)
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
    func didDetectScreenshot(image: UIImage, from viewController: UIViewController)
}



class DidDetectScreenshotCoordinator: EventObserverDelegate {
    func didDetectScreenshot(image: UIImage, from viewController: UIViewController) {
        
        let screenshotCoordinator = ScreenshotCoordinator(iterationX: IterationX.shared, presentingController: viewController, imageView: UIImageView(image: image))
        screenshotCoordinator.start()
    }
}
