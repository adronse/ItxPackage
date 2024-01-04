//
//  IssueCoordinator.swift
//
//
//  Created by Adrien Ronse on 04/01/2024.
//

import Foundation
import UIKit

protocol IssueReporting {
    func reportIssue(title: String, description: String, image: UIImage?, completion: @escaping (Result<Void, Error>) -> Void)
}

class IssueCoordinator: IssueReporting {
    let graphQLClient: GraphQLClient
    
    init(graphQLClient: GraphQLClient) {
        self.graphQLClient = graphQLClient
    }
    
    func createPreSignedUrl(completion: @escaping (Result<PreSignedUrl, Error>) -> Void) {
        let mutation = """
        mutation {
              createPreSignedUrl(contentType: "image/jpg", filename: "toto", scope: ISSUE_ATTACHMENT) {
                url
                id
                headers {
                  key
                  value
                }
                expiresAt
              }
        }
        """
        
        graphQLClient.performMutation(mutation: mutation) { [weak self] result in
            guard let self = self else { return }
            
            graphQLClient.unpackQueryResult(result) { (result: Result<CreatePreSignedUrlResponse, Error>) in
                switch result {
                case .success(let response):
                    print(response.createPreSignedUrl)
                    completion(.success(response.createPreSignedUrl))
                case .failure(let error):
                    print(error)
                    completion(.failure(error))
                }
            }
        }
    }
    
    
    
    func reportIssue(title: String, description: String, image: UIImage?, completion: @escaping (Result<Void, Error>) -> Void) {
        
        if (image != nil) {
            createPreSignedUrl(completion: { result in
                switch result {
                case .success(let response):
                    print("GraphQL Response: \(response)")
                    completion(.success(()))
                case .failure(let error):
                    print("Error performing GraphQL query: \(error)")
                    completion(.failure(error))
                }
            })
            
        }
        
        
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

