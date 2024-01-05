//
//  File.swift
//  
//
//  Created by Adrien Ronse on 05/01/2024.
//

import Foundation
import UIKit




public class NavigationTracker {
    public static let shared = NavigationTracker()
    private var history: [String] = []

    public func trackViewController(_ viewController: UIViewController, appeared: Bool) {
        let identifier = String(describing: type(of: viewController))
        if appeared {
            history.append(identifier)
        } else {
            // maybe history of removed view controllers
        }
    }

    public func getHistory() -> [String] {
        return history
    }
}


extension UIViewController {
    
    @objc func itx_tracked_viewWillAppear(_ animated: Bool) {
        if Bundle(for: type(of: self)) === Bundle.main && !IterationX.shared.getFlowActive() {
            NavigationTracker.shared.trackViewController(self, appeared: true)
        }
        
        itx_tracked_viewWillAppear(animated)
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
