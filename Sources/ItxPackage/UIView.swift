//
//  File.swift
//  
//
//  Created by Adrien Ronse on 18/12/2023.
//

import Foundation
import UIKit

public extension UIView {
    static func separator(color: UIColor = UIColor.black.withAlphaComponent(0.4)) -> UIView {
        return UIView().with(\.backgroundColor, value: color)
    }
    static func separatorWhite(color: UIColor = UIColor.white.withAlphaComponent(0.4)) -> UIView {
        return UIView().with(\.backgroundColor, value: color)
    }
}

