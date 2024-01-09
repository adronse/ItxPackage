import Foundation
import RxSwift
import RxAlamofire
import Alamofire

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

    func makeGraphQLRequest(query: String) -> Observable<Any> {
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(self.apiKey)"
        ]

        let requestBody: [String: Any] = [
            "query": query
        ]

        return RxAlamofire
            .requestData(.post, self.url, parameters: requestBody, encoding: JSONEncoding.default, headers: headers)
            .observe(on: scheduler)
            .flatMap { response, data -> Observable<Any> in
                guard response.statusCode == 200 else {
                    throw NSError(domain: "NetworkError", code: response.statusCode, userInfo: nil)
                }
                return Observable.just(try JSONSerialization.jsonObject(with: data, options: []))
            }
            .catch { error in
                return Observable.error(error)
            }
    }
}
