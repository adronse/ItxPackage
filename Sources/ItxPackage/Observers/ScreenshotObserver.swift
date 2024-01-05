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
        
        if IterationX.shared.getFlowActive() {
            return
        }
        
        guard let topViewController = UIApplication.shared.topMostViewController else {
            return
        }
        if let screenshot = captureScreen(view: topViewController.view) {
            let info = getDeviceInfo()
            
            print(info)
            delegate?.didDetectScreenshot(image: screenshot, from: topViewController)
        }
    }
    
    static func getDeviceInfo() -> [String: String] {
        var info = [String: String]()
        let device = UIDevice.current
        info["iOSVersion"] = device.systemVersion
        info["DeviceModel"] = device.model
        info["DeviceName"] = device.name
        info["DeviceType"] = device.localizedModel
        info["DeviceUUID"] = device.identifierForVendor?.uuidString
        info["AppVersion"] = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        return info
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
        IterationX.shared.setFlowActive(true)
    }
}
