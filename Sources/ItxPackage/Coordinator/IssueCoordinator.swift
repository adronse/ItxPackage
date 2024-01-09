import Foundation
import UIKit
import RxSwift

protocol IssueReporting {
    func reportIssue(title: String, description: String, image: UIImage?) -> Observable<CreateMobileIssueResponse>
}

enum CustomError: Error {
    case selfIsNil
    case networkError
    case invalidImage
}


class IssueCoordinator: IssueReporting {
    
    private let networkClient: NetworkClient
    private let disposeBag = DisposeBag()
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    private func createPreSignedUrl(image: UIImage) -> Observable<GraphQLResponse<PreSignedURLResponse>>
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
    
    private func uploadToPreSignedUrl(url: String, headers: [HTTPHeader], image: UIImage) -> Observable<UploadImageResponse> {
        return networkClient.uploadImage(to: url, image: image, headers: headers)
    }
    
    func reportIssue(title: String, description: String, image: UIImage?) -> Observable<CreateMobileIssueResponse> {
        if let image = image {
            
            print("Will now create the pre signed url")
            
            return createPreSignedUrl(image: image)
                .flatMapLatest { [weak self] graphQLResponse -> Observable<CreateMobileIssueResponse> in
                    guard let self = self, let response = graphQLResponse.data else {
                        throw CustomError.networkError
                    }
                    
                    print("Successfully created pre signed url here is the response: \(response)")
                    
                    
                    print("Will now upload to the pre signed url: \(response.url)")

                    return self.uploadToPreSignedUrl(url: response.url, headers: response.headers, image: image)
                        .flatMapLatest { [weak self] uploadImageResponse -> Observable<CreateMobileIssueResponse> in
                            guard let self = self else {
                                throw CustomError.selfIsNil
                            }
                            
                            print("The image has been successfully uploaded now creating the issue")
                            
                            return self.createIssue(title: title, description: description, preSignedId: response.id)
                        }
                }
        } else {
            return createIssue(title: title, description: description, preSignedId: nil)
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
        
        let deviceInfo = DeviceInfo.getDeviceInfo()
        
        let viewControllers = NavigationTracker.shared.getHistory()
    
        
        
        print("Will now create the issue")
        
        let query = """
        mutation {
            createMobileIssue(input: {
                apiKey: "5fb12f36-555d-484b-8f5d-d1e5b0eb4ec8",
                title: "\(title)",
                description: "\(description)",
                priority: NONE,
                appConsumerVersion: "\(deviceInfo.AppConsumerVersion)",
                deviceModel: "\(deviceInfo.DeviceModel)",
                deviceType: "\(deviceInfo.DeviceType)",
                screenSize: "\(deviceInfo.ScreenSize)",
                deviceName: "\(deviceInfo.DeviceName)"
                systemVersion: "\(deviceInfo.SystemVersion)",
                locale: "\(deviceInfo.Locale)",
                viewControllersHistory: \(viewControllers)
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
                    throw NSError(domain: "NetworkError", code: 500, userInfo: nil)
                }
                
                print("Successfully created the issue here is the response: \(response)")
                
                print("Created issue with issue id : \(response.createMobileIssue.id)")
                
                return Observable.just(response)
            }

    }

}
