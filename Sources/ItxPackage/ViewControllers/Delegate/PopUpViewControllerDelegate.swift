//
//  File.swift
//  
//
//  Created by Adrien Ronse on 04/01/2024.
//

import Foundation


protocol PopupViewControllerDelegate: AnyObject {
    func didSelectReportBug()
    func didSelectSuggestImprovement()
}
