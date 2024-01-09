//
//  File.swift
//  
//
//  Created by Adrien Ronse on 09/01/2024.
//

import Foundation

struct CreateMobileIssueResponse: Decodable {
    let createMobileIssue: IssueDetail
}

struct IssueDetail: Decodable {
    let id: String
}
