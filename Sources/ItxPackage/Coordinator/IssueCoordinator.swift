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
    
    func createPreSignedUrl(image: UIImage, contentType: String, completion: @escaping (Result<PreSignedUrl, Error>) -> Void) {
        let mutation = """
            mutation {
                  createPreSignedUrl(contentType: "\(contentType)", filename: "image.jpg", scope: ISSUE_ATTACHMENT) {
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
    
    func convertImageToJPEGData(image: UIImage) -> Data? {
        return image.jpegData(compressionQuality: 0.9)  // You can adjust the compression quality
    }
    
    
    func reportIssue(title: String, description: String, image: UIImage?, completion: @escaping (Result<Void, Error>) -> Void) {
        if let image = image, let _ = convertImageToJPEGData(image: image) {
            let contentType = "image/jpeg"
            
            createPreSignedUrl(image: image, contentType: contentType, completion: { [weak self] result in
                switch result {
                case .success(let response):
                    print("GraphQL Response: \(response)")
                    // Convert UUID to String and pass to createMobileIssue
                    self?.createMobileIssue(title: title, description: description, preSignedUrlId: response.id, completion: completion)
                case .failure(let error):
                    print("Error performing GraphQL query: \(error)")
                    completion(.failure(error))
                }
            })
        } else {
            // If there's no image, call createMobileIssue without a preSignedUrlId
            createMobileIssue(title: title, description: description, preSignedUrlId: nil, completion: completion)
        }
    }
    
    func createMobileIssue(title: String, description: String, preSignedUrlId: String?, completion: @escaping (Result<Void, Error>) -> Void) {
        let preSignedBlobString: String
        if let preSignedUrlId = preSignedUrlId {
            preSignedBlobString = """
            preSignedBlob: {
                preSignedUrlId: "\(preSignedUrlId)",
                type: SCREENSHOT
            }
            """
        } else {
            preSignedBlobString = ""
        }

        let mutation = """
        mutation {
            createEmptyIssue(input: {
                title: "\(title)",
                description: "\(description)"
                priority: NONE,
                projectId: "Dm4E5G",
                \(preSignedBlobString)
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

