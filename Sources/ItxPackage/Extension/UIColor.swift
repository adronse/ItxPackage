//
//  File.swift
//  
//
//  Created by Adrien Ronse on 18/12/2023.
//

import Foundation
import UIKit

public extension UIColor {
    static func from(hex: UInt64, alpha: CGFloat = 1) -> UIColor {
        let r = CGFloat((hex & 0xFF0000) >> 16)
        let g = CGFloat((hex & 0x00FF00) >> 8)
        let b = CGFloat((hex & 0x0000FF))
        return UIColor(red: r / 255, green: g / 255, blue: b / 255, alpha: alpha)
    }

    static func from(hex: String, alpha: CGFloat = 1) -> UIColor {
        var intValue: UInt64 = 0
        Scanner(string: hex.replacingOccurrences(of: "#", with: "")).scanHexInt64(&intValue)
        return from(hex: intValue, alpha: alpha)
    }
    
    func toImage(_ size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        setFill()
        UIRectFill(CGRect(origin: CGPoint.zero, size: size))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
      }
}
