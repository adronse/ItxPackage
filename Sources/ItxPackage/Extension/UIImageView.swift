//
//  File.swift
//  
//
//  Created by Adrien Ronse on 21/12/2023.
//

import Foundation
import UIKit

extension UIImageView {

    // Function to convert to JPEG
    func convertToJPEG(compressionQuality: CGFloat = 1.0) -> Data? {
        return self.image?.jpegData(compressionQuality: compressionQuality)
    }

    // Function to convert to PNG
    func convertToPNG() -> Data? {
        return self.image?.pngData()
    }
}

