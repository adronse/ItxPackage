//
//  File.swift
//  
//
//  Created by Adrien Ronse on 04/01/2024.
//

import Foundation


class GraphQLClientFactory {
    static func createClient() -> GraphQLClient {
        let url = URL(string: "https://a082-2a05-6e02-10d1-a710-3ca9-7f62-932d-97f0.ngrok-free.app/graphql")!
        let apiKey = IterationX.shared.getApiKey()
        return GraphQLClient(url: url, apiKey: apiKey)
    }
}
