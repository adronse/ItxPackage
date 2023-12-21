//
//  File.swift
//
//
//  Created by Adrien Ronse on 21/12/2023.
//

import Foundation


struct GraphQLResponse<T: Decodable>: Decodable {
    let data: T?
    let errors: [GraphQLErrorDetail]?
}

struct GraphQLErrorDetail: Decodable {
    let message: String
}

class GraphQLClient {
    private let url: URL
    private let session: URLSession
    
    init(url: URL, session: URLSession = .shared) {
        self.url = url
        self.session = session
    }
    
    func performQuery(query: String, completion: @escaping (Result<Any, Error>) -> Void) {
        let requestBody = [
            "query": query
        ]
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: requestBody, options: []) else {
            completion(.failure(GraphQLError.serializationError))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = httpBody
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(GraphQLError.noData))
                return
            }
            
            do {
                let jsonResponse = try JSONSerialization.jsonObject(with: data, options: [])
                completion(.success(jsonResponse))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    func performMutation(mutation: String, completion: @escaping (Result<Any, Error>) -> Void) {
        let requestBody = [
            "query": mutation
        ]
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: requestBody, options: []) else {
            completion(.failure(GraphQLError.serializationError))
            return
        }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.httpBody = httpBody
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(GraphQLError.noData))
                return
            }
            
            do {
                let jsonResponse = try JSONSerialization.jsonObject(with: data, options: [])
                completion(.success(jsonResponse))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
}

enum GraphQLError: Error {
    case serializationError
    case noData
}


extension GraphQLClient {
    func unpackQueryResult<T: Decodable>(_ result: Result<Any, Error>, completion: @escaping (Result<T, Error>) -> Void) {
        switch result {
        case .success(let jsonResponse):
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: jsonResponse, options: [])
                let graphQLResponse = try JSONDecoder().decode(GraphQLResponse<T>.self, from: jsonData)
                
                if let data = graphQLResponse.data {
                    completion(.success(data))
                } else if let errors = graphQLResponse.errors {
                    // Handle or propagate GraphQL errors
                } else {
                    completion(.failure(GraphQLError.serializationError))
                }
            } catch {
                completion(.failure(error))
            }
        case .failure(let error):
            completion(.failure(error))
        }
    }
}
