//
//  File.swift
//  
//
//  Created by Adrien Ronse on 04/01/2024.
//

import Foundation


class GraphQLClientFactory {
    static func createClient() -> NetworkClient {
        let url = URL(string: "https://fc0a-2a05-6e02-10d1-a710-470-6ca0-2212-8ce5.ngrok-free.app/graphql")!
        let apiKey = IterationX.shared.getApiKey()
        return NetworkClient(url: url, apiKey: apiKey)
    }
}
