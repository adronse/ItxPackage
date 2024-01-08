//
//  File.swift
//  
//
//  Created by Adrien Ronse on 21/12/2023.
//

import Foundation
import UIKit

extension UIImageView {

    func convertToJPEG(compressionQuality: CGFloat = 1.0) -> Data? {
        return self.image?.jpegData(compressionQuality: compressionQuality)
    }
    
    func convertToPNG() -> Data? {
        return self.image?.pngData()
    }
}

