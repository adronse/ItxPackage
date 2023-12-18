//
//  File.swift
//  
//
//  Created by Adrien Ronse on 15/12/2023.
//

import Foundation
import UIKit

public extension UIButton {
    static func primary(text: String? = nil) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(text, for: .normal)
        button.setTitleColor(.white, for: [])
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        
        return button
    }
    
}


