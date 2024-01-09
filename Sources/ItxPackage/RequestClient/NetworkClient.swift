import Foundation
import RxSwift
import RxAlamofire
import Alamofire
import UIKit

struct GraphQLResponse<T: Decodable>: Decodable {
    let data: T?
    let errors: [GraphQLErrorDetail]?
}

struct GraphQLErrorDetail: Decodable {
    let message: String
}

protocol INetworkClient {
    func performRequest<T: Decodable>(query: String, method: HTTPMethod) -> Observable<T>
    func uploadImageToPreSignedUrl(data: PreSignedUrl, image: UIImage) -> Observable<Bool>
}

class NetworkClient : INetworkClient {
    
    private let disposeBag = DisposeBag()
    private let url: URL
    private let apiKey: String
    private let scheduler: SerialDispatchQueueScheduler

    init(url: URL, apiKey: String) {
        self.url = url
        self.apiKey = apiKey
        self.scheduler = SerialDispatchQueueScheduler(qos: .default)
    }
    
    func uploadImageToPreSignedUrl(data: PreSignedUrl, image: UIImage) -> Observable<Bool>
    {
        
        print("Performing request to create pre signed url")
        
        return Observable.create { observer in
            guard let imageData = image.jpegData(compressionQuality: 0.9) else {
                observer.onError(URLError(.badURL))
                print("Unable to create image data")
                return Disposables.create()
            }
            
            guard let url = URL(string: data.url) else {
                observer.onError(URLError(.badURL))
                print("Unable to create url")
                return Disposables.create()
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "PUT"
            data.headers.forEach { header in
                request.setValue(header.value, forHTTPHeaderField: header.key)
            }
            
            print("Image Data Size: \(imageData.count)")
            print("Pre-Signed URL: \(data.url)")

            
            
            let task = URLSession.shared.uploadTask(with: request, from: imageData) { _, response, error in
                if let error = error {
                    observer.onError(error)
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode else {
                    print("Unexpected response status code")
                    observer.onError(URLError(.badServerResponse))
                    return
                }
                
                observer.onNext((true))
                observer.onCompleted()
            }
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        }
    }

    func performRequest<T: Decodable>(query: String, method: HTTPMethod) -> Observable<T> {
        let requestBody = ["mutation": query]
        
        return Observable.create { [weak self] observer in
            guard let self = self,
                  let httpBody = try? JSONSerialization.data(withJSONObject: requestBody, options: []) else {
                observer.onError(GraphQLError.serializationError)
                return Disposables.create()
            }

            let request = self.createRequest(method: method, httpBody: httpBody)
            
            
            print(requestBody)
            

            RxAlamofire.requestData(request)
                .observe(on: self.scheduler)
                .subscribe(onNext: { (response, data) in
                    self.handleResponse(data: data, observer: observer)
                }, onError: { error in
                    print("Error: \(error)")
                    observer.onError(error)
                })
                .disposed(by: self.disposeBag)

            return Disposables.create()
        }
    }

    public func createRequest(method: HTTPMethod, httpBody: Data) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.httpBody = httpBody
        request.setValue(apiKey, forHTTPHeaderField: "X-Project-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        print("Request URL: \(request.url?.absoluteString ?? "Invalid URL")")
        print("Request Headers: \(request.allHTTPHeaderFields ?? [:])")
        print("Request Body: \(String(data: request.httpBody ?? Data(), encoding: .utf8) ?? "")")

        
        return request
    }

    private func handleResponse<T: Decodable>(data: Data, observer: AnyObserver<T>) {
        do {
            let graphQLResponse = try JSONDecoder().decode(GraphQLResponse<T>.self, from: data)
            if let data = graphQLResponse.data {
                observer.onNext(data)
                print("Response: \(data)")
                observer.onCompleted()
            } else if let errors = graphQLResponse.errors {
                print(errors)
                observer.onError(GraphQLError.custom("GraphQL Errors: \(errors)"))
            } else {
                observer.onError(GraphQLError.noData)
            }
        } catch {
            observer.onError(error)
        }
    }
}

enum GraphQLError: Error {
    case serializationError
    case noData
    case custom(String)
}

enum HTTPMethod: String {
    case POST
    case GET
    case PUT
}
