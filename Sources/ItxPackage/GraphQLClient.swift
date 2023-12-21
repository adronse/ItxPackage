//
//  File.swift
//
//
//  Created by Adrien Ronse on 21/12/2023.
//

import Foundation

import Foundation

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
        request.addValue("Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpYXQiOjE3MDI5MTk4MDAsImlzcyI6Imh0dHBzOi8vYXBpLml0eC5jb2ZmZWUvYXV0aCIsImF1ZCI6Imh0dHBzOi8vYXBpLml0eC5jb2ZmZWUvKiovKiIsImF0aSI6NTkxODV9.llyobV3wILxSzUMZFzYogBqsLLUBfT1wa3eWro0oAOc", forHTTPHeaderField: "Authorization")
        
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
