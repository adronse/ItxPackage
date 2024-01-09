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

struct PreSignedURLResponse: Decodable {
    let url: String
    let id: String
    let headers: [HTTPHeader]
    let expiresAt: String
}

struct HTTPHeader: Decodable {
    let key: String
    let value: String
}

struct CreateMobileIssueData: Decodable {
    let createMobileIssue: CreateMobileIssueResponse
}

struct CreateMobileIssueResponse: Decodable {
    let id: String
}

struct CreateMobileIssuePreviewResponse: Decodable
{
    let url: String
}

class NetworkClient {
    private let disposeBag = DisposeBag()
    private let url: URL
    private let apiKey: String
    private let scheduler: SerialDispatchQueueScheduler
    
    init(url: URL, apiKey: String) {
        self.url = url
        self.apiKey = apiKey
        self.scheduler = SerialDispatchQueueScheduler(qos: .default)
    }
    
    func getPreSignedURL() -> Observable<GraphQLResponse<PreSignedURLResponse>> {
        let query = """
            mutation {
                createPreSignedUrl(
                    contentType: "image/jpeg",
                    filename: "image.jpg",
                    scope: ISSUE_ATTACHMENT
                ) {
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
        
        return makeGraphQLRequest(query: query)
    }
    
    
    func uploadImage(to preSignedURL: String, image: UIImage, headers: [HTTPHeader]) -> Observable<UploadImageResponse> {
        return Observable.create { observer in
            guard let imageData = image.jpegData(compressionQuality: 0.9) else {
                observer.onError(URLError(.badURL))
                return Disposables.create()
            }
            
            guard let url = URL(string: preSignedURL) else {
                observer.onError(URLError(.badURL))
                return Disposables.create()
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "PUT"
            headers.forEach { header in
                request.setValue(header.value, forHTTPHeaderField: header.key)
            }
            
            let task = URLSession.shared.uploadTask(with: request, from: imageData) { _, response, error in
                if let error = error {
                    observer.onError(error)
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode else {
                    observer.onError(URLError(.badServerResponse))
                    return
                }
                
                observer.onNext(UploadImageResponse())
                observer.onCompleted()
            }
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
    
    
    func makeGraphQLRequest<T: Decodable>(query: String) -> Observable<GraphQLResponse<T>> {
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "X-Project-API-Key": "194a6378-45a4-4bb1-b11b-fa17d9defa7c"
        ]
        
        let requestBody: [String: Any] = [
            "query": query
        ]
        
        return RxAlamofire
            .requestData(.post, self.url, parameters: requestBody, encoding: JSONEncoding.default, headers: headers)
            .observe(on: scheduler)
            .flatMap { response, data -> Observable<GraphQLResponse<T>> in
                guard response.statusCode == 200 else {
                    throw NSError(domain: "NetworkError", code: response.statusCode, userInfo: nil)
                }
                do {
                    let decodedResponse = try JSONDecoder().decode(GraphQLResponse<T>.self, from: data)
                    return Observable.just(decodedResponse)
                } catch let error {
                    throw error
                }
            }
            .catch { error in
                return Observable.error(error)
            }
    }
}
