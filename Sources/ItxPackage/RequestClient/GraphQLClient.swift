import Foundation
import RxSwift

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
    private let apiKey: String
    
    init(url: URL, session: URLSession = .shared, apiKey: String) {
        self.url = url
        self.session = session
        self.apiKey = apiKey
    }
    
    func performQuery(query: String) -> Observable<Any> {
        return Observable.create { observer in
            let requestBody = [
                "query": query
            ]
            
            guard let httpBody = try? JSONSerialization.data(withJSONObject: requestBody, options: []) else {
                observer.onError(GraphQLError.serializationError)
                return Disposables.create()
            }
            
            var request = URLRequest(url: self.url)
            request.httpMethod = "POST"
            request.httpBody = httpBody
            
            request.setValue(self.apiKey, forHTTPHeaderField: "X-Project-API-Key")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let task = self.session.dataTask(with: request) { data, response, error in
                if let error = error {
                    observer.onError(error)
                    return
                }
                
                guard let data = data else {
                    observer.onError(GraphQLError.noData)
                    return
                }
                
                do {
                    let jsonResponse = try JSONSerialization.jsonObject(with: data, options: [])
                    observer.onNext(jsonResponse)
                    observer.onCompleted()
                } catch {
                    observer.onError(error)
                }
            }
            
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
    
    func performMutation(mutation: String) -> Observable<Any> {
        return Observable.create { observer in
            let requestBody = [
                "query": mutation
            ]
            
            guard let httpBody = try? JSONSerialization.data(withJSONObject: requestBody, options: []) else {
                observer.onError(GraphQLError.serializationError)
                return Disposables.create()
            }
            
            var request = URLRequest(url: self.url)
            
            request.httpMethod = "POST"
            request.httpBody = httpBody
            request.setValue("5fb12f36-555d-484b-8f5d-d1e5b0eb4ec8", forHTTPHeaderField: "X-Project-API-Key")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let task = self.session.dataTask(with: request) { data, response, error in
                if let error = error {
                    observer.onError(error)
                    return
                }
                
                guard let data = data else {
                    observer.onError(GraphQLError.noData)
                    return
                }
                
                do {
                    let jsonResponse = try JSONSerialization.jsonObject(with: data, options: [])
                    observer.onNext(jsonResponse)
                    observer.onCompleted()
                } catch {
                    observer.onError(error)
                }
            }
            
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
}

enum GraphQLError: Error {
    case serializationError
    case noData
}

extension GraphQLClient {
    func unpackQueryResult<T: Decodable>(_ result: Observable<Any>) -> Observable<Result<T, Error>> {
        return result.flatMap { jsonResponse -> Observable<Result<T, Error>> in
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: jsonResponse, options: [])
                let graphQLResponse = try JSONDecoder().decode(GraphQLResponse<T>.self, from: jsonData)
                
                if let data = graphQLResponse.data {
                    return .just(.success(data))
                } else if graphQLResponse.errors != nil {
                    // TODO: handle errors
                    return .just(.failure(GraphQLError.serializationError))
                } else {
                    return .just(.failure(GraphQLError.serializationError))
                }
            } catch {
                return .just(.failure(error))
            }
        }
    }
}
