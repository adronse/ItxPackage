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

    func makeGraphQLRequest<T: Decodable>(query: String) -> Observable<GraphQLResponse<T>> {
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": "\(self.apiKey)"
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
