//
//  File.swift
//  
//
//  Created by Adrien Ronse on 04/01/2024.
//

import Foundation


class GraphQLClientFactory {
    static func createClient() -> NetworkClient {
        let url = URL(string: "https://d436-2a05-6e02-10d1-a710-9883-6646-34d1-1b66.ngrok-free.app/graphql")!
        let apiKey = IterationX.shared.getApiKey()
        return NetworkClient(url: url, apiKey: apiKey)
    }
}
