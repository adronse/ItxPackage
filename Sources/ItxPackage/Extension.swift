//
//  File.swift
//  
//
//  Created by Adrien Ronse on 15/12/2023.
//

import Foundation
import UIKit

public protocol WithSupport {
    
}

public extension WithSupport where Self: AnyObject {
    @discardableResult
    func with<V>(_ kp: ReferenceWritableKeyPath<Self, V>, value: V) -> Self {
        self[keyPath: kp] = value
        return self
    }
}

extension NSObject: WithSupport {}
