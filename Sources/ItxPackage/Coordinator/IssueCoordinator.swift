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
    
    
    func uploadImageToPreSignedUrl(image: UIImage, preSignedUrl: String, headers: [Header], completion: @escaping (Result<Void, Error>) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.9) else {
            completion(.failure(URLError(.badURL)))
            return
        }
        
        guard let url = URL(string: preSignedUrl) else {
            completion(.failure(URLError(.badURL)))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        headers.forEach { header in
            request.setValue(header.value, forHTTPHeaderField: header.key)
        }
        
        let task = URLSession.shared.uploadTask(with: request, from: imageData) { _, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode else {
                completion(.failure(URLError(.badServerResponse)))
                return
            }

            completion(.success(()))
        }
        task.resume()
    }
    
    func createPreSignedUrl(image: UIImage, contentType: String, completion: @escaping (Result<PreSignedUrl, Error>) -> Void) {
        let mutation = 
            """
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
            
            self.graphQLClient.unpackQueryResult(result) { (result: Result<CreatePreSignedUrlResponse, Error>) in
                switch result {
                case .success(let response):
                    let preSignedUrl = response.createPreSignedUrl
                    self.uploadImageToPreSignedUrl(image: image, preSignedUrl: preSignedUrl.url, headers: preSignedUrl.headers) { uploadResult in
                        switch uploadResult {
                        case .success():
                            completion(.success(preSignedUrl))
                        case .failure(let error):
                            completion(.failure(error))
                        }
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    func convertImageToJPEGData(image: UIImage) -> Data? {
        return image.jpegData(compressionQuality: 0.9)
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
            createMobileIssue(input: {
                apiKey: "5fb12f36-555d-484b-8f5d-d1e5b0eb4ec8",
                title: "\(title)",
                description: "\(description)"
                priority: NONE
                \(preSignedBlobString)
            }) {
                id
                preview {
                    url
                }
            }
        }
        """

        graphQLClient.performMutation(mutation: mutation) { result in
            switch result {
            case .success(let response):
                print("GraphQL Response: \(response)")
                IterationX.shared.setFlowActive(false)
                completion(.success(()))
            case .failure(let error):
                print("Error performing GraphQL query: \(error)")
                completion(.failure(error))
            }
        }
    }

}

