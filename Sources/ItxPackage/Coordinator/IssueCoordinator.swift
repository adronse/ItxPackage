//
//  File.swift
//
//
//  Created by Adrien Ronse on 04/01/2024.
//

import Foundation

protocol IssueReporting {
    func reportIssue(title: String, description: String, completion: @escaping (Result<Void, Error>) -> Void)
}


class IssueCoordinator: IssueReporting {
    
    
    let graphQLClient: GraphQLClient
    
    init(graphQLClient: GraphQLClient) {
        self.graphQLClient = graphQLClient
    }
    
    func reportIssue(title: String, description: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let mutation = """
        mutation {
          createMobileIssue(input: {
            apiKey: "5fb12f36-555d-484b-8f5d-d1e5b0eb4ec8",
            title: "\(title)",
            description: "\(description)"
            priority: NONE
          }) {
            id
          }
        }
        """
        
        graphQLClient.performMutation(mutation: mutation) { result in
            switch result {
            case .success(let response):
                print("GraphQL Response: \(response)")
                completion(.success(()))
            case .failure(let error):
                print("Error performing GraphQL query: \(error)")
                completion(.failure(error))
            }
        }
    }
}
