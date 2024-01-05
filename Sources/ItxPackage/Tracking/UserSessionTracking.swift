//
//  File.swift
//  
//
//  Created by Adrien Ronse on 05/01/2024.
//

import Foundation
import UIKit


public protocol TrackableViewController {
    func trackAppearance()
}

public extension TrackableViewController where Self: UIViewController {
    func trackAppearance() {
        NavigationTracker.shared.trackViewController(self, appeared: true)
    }
}

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
