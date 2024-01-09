//
//  File.swift
//  
//
//  Created by Adrien Ronse on 04/01/2024.
//

import Foundation


struct CreatePreSignedUrlResponse: Decodable {
    let createPreSignedUrl: PreSignedURLResponse
}

struct PreSignedURLResponse: Decodable {
    let url: String
    let id: String
    let headers: [HTTPHeader]
    let expiresAt: String
}

struct HTTPHeader: Decodable {
    let key: String
    let value: String
}
