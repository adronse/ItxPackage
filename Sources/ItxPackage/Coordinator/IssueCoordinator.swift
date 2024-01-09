import Foundation
import UIKit
import RxSwift

protocol IssueReporting {
    func reportIssue(title: String, description: String, image: UIImage?) -> Observable<Void>
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
    
    func reportIssue(title: String, description: String, image: UIImage?) -> Observable<Void> {
        return Observable.create { observer in
            let query = """
            mutation {
                        createMobileIssue(input: {
                            apiKey: "5fb12f36-555d-484b-8f5d-d1e5b0eb4ec8",
                            title: "\(title)",
                            description: "\(description)"
                            priority: NONE,
                            appConsumerVersion: "test",
                            deviceModel: "test",
                            deviceType: "test",
                            screenSize: "test",
                            deviceName: "test"
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
            
            self.networkClient.makeGraphQLRequest(query: query)
                .subscribe(onNext: { _ in
                    observer.onNext(())
                    observer.onCompleted()
                }, onError: { error in
                    observer.onError(error)
                })
                .disposed(by: self.disposeBag)
            
            return Disposables.create()
        }
    }

}
