//
//  File.swift
//  
//
//  Created by Adrien Ronse on 04/01/2024.
//

import Foundation


protocol IssueCreationViewControllerDelegate: AnyObject {
    func didTapCross()
    func didCreateIssue()
    func didTapAddPicture()
}
