import Foundation
import RxSwift
import RxAlamofire
import Alamofire

struct GraphQLResponse<T: Decodable>: Decodable {
    let data: T?
    let errors: [GraphQLErrorDetail]?
}

struct GraphQLErrorDetail: Decodable {
    let message: String
}

class GraphQLClient {
    private let disposeBag = DisposeBag()
    private let url: URL
    private let apiKey: String
    private let scheduler: SerialDispatchQueueScheduler

    init(url: URL, apiKey: String) {
        self.url = url
        self.apiKey = apiKey
        self.scheduler = SerialDispatchQueueScheduler(qos: .default)
    }

    func performRequest<T: Decodable>(query: String, method: HTTPMethod) -> Observable<T> {
        let requestBody = ["query": query]
        
        return Observable.create { [weak self] observer in
            guard let self = self,
                  let httpBody = try? JSONSerialization.data(withJSONObject: requestBody, options: []) else {
                observer.onError(GraphQLError.serializationError)
                return Disposables.create()
            }

            let request = self.createRequest(method: method, httpBody: httpBody)

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

    private func createRequest(method: HTTPMethod, httpBody: Data) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.httpBody = httpBody
        request.setValue(apiKey, forHTTPHeaderField: "X-Project-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }

    private func handleResponse<T: Decodable>(data: Data, observer: AnyObserver<T>) {
        do {
            let graphQLResponse = try JSONDecoder().decode(GraphQLResponse<T>.self, from: data)
            if let data = graphQLResponse.data {
                observer.onNext(data)
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
