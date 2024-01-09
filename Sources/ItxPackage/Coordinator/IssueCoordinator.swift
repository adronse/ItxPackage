import Foundation
import UIKit
import RxSwift

protocol IssueReporting {
    func reportIssue(title: String, description: String, image: UIImage?) -> Observable<CreateMobileIssueResponse>
}

enum CustomError: Error {
    case selfIsNil
}




class IssueCoordinator: IssueReporting {
    private let networkClient: NetworkClient
    private let disposeBag = DisposeBag()
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func reportIssue(title: String, description: String, image: UIImage?) -> Observable<CreateMobileIssueResponse> {
        return Observable.create { [weak self] observer in
            guard let self = self else {
                observer.onError(CustomError.selfIsNil)
                return Disposables.create()
            }
            
            let query = """
            mutation {
                createMobileIssue(input: {
                    apiKey: "5fb12f36-555d-484b-8f5d-d1e5b0eb4ec8",
                    title: "\(title)",
                    description: "\(description)",
                    priority: NONE,
                    appConsumerVersion: "test",
                    deviceModel: "test",
                    deviceType: "test",
                    screenSize: "test",
                    deviceName: "test",
                    systemVersion: "test",
                    locale: "test",
                }) {
                    id
                    preview {
                        url
                    }
                }
            }
            """
            
            let requestObservable: Observable<GraphQLResponse<CreateMobileIssueResponse>> = self.networkClient.makeGraphQLRequest(query: query)
            
            requestObservable
                .flatMap { graphQLResponse -> Observable<CreateMobileIssueResponse> in
                    guard let response = graphQLResponse.data else {
                        // Handle error scenario, perhaps throw a custom error
                        throw NSError(domain: "NetworkError", code: 500, userInfo: nil)
                    }
                    return Observable.just(response)
                }
                .subscribe(
                    onNext: { response in
                        observer.onNext(response)
                    },
                    onError: { error in
                        observer.onError(error)
                    },
                    onCompleted: {
                        observer.onCompleted()
                    })
                .disposed(by: self.disposeBag)
            
            return Disposables.create()
        }
    }
}

