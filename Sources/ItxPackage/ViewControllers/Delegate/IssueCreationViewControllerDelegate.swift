//
//  File.swift
//  
//
//  Created by Adrien Ronse on 04/01/2024.
//

import Foundation
import UIKit

protocol IssueCreationViewControllerDelegate: AnyObject {
    func didTapCross()
    func didCreateIssue()
    func didLaunchDrawing(image: UIImage)
}
