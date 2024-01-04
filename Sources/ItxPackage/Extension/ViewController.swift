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
