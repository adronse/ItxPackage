import Foundation
import UIKit
import RxSwift

protocol IssueReporting {
    func reportIssue(title: String, description: String, image: UIImage) -> Observable<CreateMobileIssueResponse>
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
    
    func createPreSignedUrl(image: UIImage) -> Observable<GraphQLResponse<CreatePreSignedUrlResponse>>
    {
        
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
        
        return networkClient.makeGraphQLRequest(query: query)
    }
    
    func reportIssue(title: String, description: String, image: UIImage) -> Observable<CreateMobileIssueResponse> {
        
        let preSignedUrlObservable: Observable<GraphQLResponse<CreatePreSignedUrlResponse>> = createPreSignedUrl(image: image)
        
        return preSignedUrlObservable
            .flatMap { preSignedUrlResponse -> Observable<CreateMobileIssueResponse> in
                guard let preSignedUrl = preSignedUrlResponse.data else {
                    return Observable.error(CustomError.selfIsNil)
                }
                
                let preSignedId = preSignedUrl.createPreSignedUrl.id
                
                let preSignedUrlString = preSignedUrl.createPreSignedUrl.url
                
                let headers = preSignedUrl.createPreSignedUrl.headers
                
                let imageData = image.jpegData(compressionQuality: 0.9)!
                
                self.networkClient.uploadImage(to: preSignedUrlString, image: image, headers: headers)
                    .subscribe(onNext: { _ in
                        self.createIssue(title: title, description: description, preSignedId: preSignedId)
                            .subscribe(onNext: { _ in
                                print("Issue created")
                            }, onError: { error in
                                print(error)
                            })
                            .disposed(by: self.disposeBag)
                    }, onError: { error in
                        print(error)
                    })
                    .disposed(by: self.disposeBag)
                
                return Observable.empty()
            }
    }
    
    private func createIssue(title: String, description: String, preSignedId: String?) -> Observable<CreateMobileIssueResponse> {
        
        let preSignedBlobString: String
        
        
        if let preSignedUrlId = preSignedId {
            preSignedBlobString = """
                    preSignedBlob: {
                        preSignedUrlId: "\(preSignedUrlId)",
                        type: SCREENSHOT
                    }
                    """
        } else {
            preSignedBlobString = ""
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
                \(preSignedBlobString)
            }) {
                id
                preview {
                    url
                }
            }
        }
        """
        
        let requestObservable: Observable<GraphQLResponse<CreateMobileIssueResponse>> = self.networkClient.makeGraphQLRequest(query: query)
        
        return requestObservable
            .flatMap { graphQLResponse -> Observable<CreateMobileIssueResponse> in
                guard let response = graphQLResponse.data else {
                    // Handle error scenario, perhaps throw a custom error
                    throw NSError(domain: "NetworkError", code: 500, userInfo: nil)
                }
                return Observable.just(response)
            }
    }
    
}

