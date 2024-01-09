import Foundation
import UIKit
import RxSwift

protocol IssueReporting {
    func reportIssue(title: String, description: String, image: UIImage?) -> Observable<Void>
}

class IssueCoordinator: IssueReporting {
    private let networkClient: NetworkClient
    private let disposeBag = DisposeBag()
    
    init(networkCli: NetworkClient) {
        self.networkClient = networkCli
    }
    
    
    func reportIssue(title: String, description: String, image: UIImage?) -> Observable<Void> {
        if let image = image, let _ = convertImageToJPEGData(image: image) {
            let contentType = "image/jpeg"
            
            
            print("Creating pre signed url")
            
            return createPreSignedUrl(image: image, contentType: contentType)
                .flatMap { [weak self] preSignedUrl -> Observable<String?> in
                    guard let self = self else {
                        print("self is nil")
                        return Observable.just(nil)
                    }
                    
                    print("Uploading image to pre signed url")
                    
                    return self.networkClient.uploadImageToPreSignedUrl(data: preSignedUrl, image: image)
                        .map { _ in preSignedUrl.id }
                        .catchAndReturn(nil)
                }
                .flatMap { [weak self] preSignedUrlId -> Observable<Void> in
                    guard let self = self else {
                        print("self is nil")
                        return Observable.empty()
                    }
                    
                    print("Creating mobile issue")
                    return self.createMobileIssue(title: title, description: description, preSignedUrlId: preSignedUrlId)
                }
        } else {
            return createMobileIssue(title: title, description: description, preSignedUrlId: nil)
        }
    }
    
    func createPreSignedUrl(image: UIImage, contentType: String) -> Observable<PreSignedUrl> {
        return Observable.create { observer in
            let mutation =
                            """
                            mutation {
                                  createPreSignedUrl(contentType: "\(contentType)", filename: "image.jpg", scope: ISSUE_ATTACHMENT) {
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
            
            self.networkClient.performRequest(query: mutation, method: .POST)
                .subscribe(onNext: { (response: GraphQLResponse<CreatePreSignedUrlResponse>) in
                    guard let preSignedUrl = response.data?.createPreSignedUrl else {
                        return
                    }
                    observer.onNext(preSignedUrl)
                    observer.onCompleted()
                }, onError: { error in
                    print("Error creating pre signed url: \(error)")
                    observer.onError(error)
                })
                .disposed(by: self.disposeBag)
            
            return Disposables.create()
        }
    }
    
    func createMobileIssue(title: String, description: String, preSignedUrlId: String?) -> Observable<Void> {
        return Observable.create { observer in
            
            let preSignedBlobString: String
            
            if let preSignedUrlId = preSignedUrlId {
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
            
            let viewControllerHistoryArray = "[\(viewControllers.map { "\"\($0)\"" }.joined(separator: ","))]"
            
            let mutation = """
            mutation {
                createMobileIssue(input: {
                    apiKey: "5fb12f36-555d-484b-8f5d-d1e5b0eb4ec8",
                    title: "\(title)",
                    description: "\(description)"
                    priority: NONE,
                    appConsumerVersion: "\(deviceInfo.AppConsumerVersion)",
                    deviceModel: "\(deviceInfo.DeviceModel)",
                    deviceType: "\(deviceInfo.DeviceType)",
                    screenSize: "\(deviceInfo.ScreenSize)",
                    deviceName: "\(deviceInfo.DeviceName)"
                    systemVersion: "\(deviceInfo.SystemVersion)",
                    locale: "\(deviceInfo.Locale)",
                    viewControllersHistory: \(viewControllerHistoryArray)
                    \(preSignedBlobString)
                }) {
                    id
                    preview {
                        url
                    }
                }
            }
            """
            
            print("Creating mobile issue")
            
            self.networkClient.performRequest(query: mutation, method: .POST)
                .subscribe(onNext: { (response: GraphQLResponse<CreateMobileIssueResponse>) in
                    observer.onNext(())
                    observer.onCompleted()
                }, onError: { error in
                    observer.onError(error)
                })
                .disposed(by: self.disposeBag)
            
            return Disposables.create()
        }
    }
    
    
    func convertImageToJPEGData(image: UIImage) -> Data? {
        return image.jpegData(compressionQuality: 0.9)
    }
}
