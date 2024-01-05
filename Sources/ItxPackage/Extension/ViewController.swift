//
//  File.swift
//  
//
//  Created by Adrien Ronse on 04/01/2024.
//

import Foundation
import UIKit

extension UIApplication {
    var topMostViewController: UIViewController? {
        return self.windows.filter {$0.isKeyWindow}.first?.rootViewController?.topMostViewController
    }
}

extension UIViewController {
    var topMostViewController: UIViewController {
        return presentedViewController?.topMostViewController ?? self
    }
}


extension UIViewController {
    @objc func _tracked_viewWillAppear(_ animated: Bool) {
        print("Tracked this screen:----- \(type(of: self))")
        _tracked_viewWillAppear(animated)
    }
    
    static func swizzle() {
        let originalSelector = #selector(UIViewController.viewDidLoad)
        let swizzledSelector = #selector(UIViewController._tracked_viewWillAppear(_:))
        let originalMethod = class_getInstanceMethod(UIViewController.self, originalSelector)
        let swizzledMethod = class_getInstanceMethod(UIViewController.self, swizzledSelector)
        method_exchangeImplementations(originalMethod!, swizzledMethod!)
    }
}
