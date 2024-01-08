import Foundation
import UIKit
import RxSwift

protocol IssueReporting {
    func reportIssue(title: String, description: String, image: UIImage?) -> Observable<Void>
}

class IssueCoordinator: IssueReporting {
    private let graphQLClient: GraphQLClient
    private let disposeBag = DisposeBag()
    
    init(graphQLClient: GraphQLClient) {
        self.graphQLClient = graphQLClient
    }
    
    func uploadImageToPreSignedUrl(image: UIImage, preSignedUrl: String, headers: [Header]) -> Observable<Void> {
        return Observable.create { observer in
            guard let imageData = image.jpegData(compressionQuality: 0.9) else {
                observer.onError(URLError(.badURL))
                return Disposables.create()
            }
            
            guard let url = URL(string: preSignedUrl) else {
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
                
                observer.onNext(())
                observer.onCompleted()
            }
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
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
            
            self.graphQLClient.performMutation(mutation: mutation)
                .flatMap { [weak self] result -> Observable<Result<PreSignedUrl, Error>> in
                    guard let self = self else { return Observable.empty() }
                    return self.graphQLClient.unpackQueryResult(result as! Observable<Any>)
                        .map { (result: Result<CreatePreSignedUrlResponse, Error>) in
                            switch result {
                            case .success(let response):
                                return .success(response.createPreSignedUrl)
                            case .failure(let error):
                                return .failure(error)
                            }
                        }
                }
                .subscribe(onNext: { response in
                    switch response {
                    case .success(let preSignedUrl):
                        self.uploadImageToPreSignedUrl(image: image, preSignedUrl: preSignedUrl.url, headers: preSignedUrl.headers)
                            .subscribe(onNext: {
                                observer.onNext(preSignedUrl)
                                observer.onCompleted()
                            }, onError: { error in
                                observer.onError(error)
                            })
                            .disposed(by: self.disposeBag)
                    case .failure(let error):
                        observer.onError(error)
                    }
                }, onError: { error in
                    observer.onError(error)
                })
                .disposed(by: self.disposeBag)
            
            return Disposables.create()
        }
    }



    
    func reportIssue(title: String, description: String, image: UIImage?) -> Observable<Void> {
        if let image = image, let _ = convertImageToJPEGData(image: image) {
            let contentType = "image/jpeg"
            
            return createPreSignedUrl(image: image, contentType: contentType)
                .flatMap { [weak self] preSignedUrl -> Observable<Void> in
                    guard let self = self else { return Observable.empty() }
                    return self.createMobileIssue(title: title, description: description, preSignedUrlId: preSignedUrl.id)
                }
        } else {
            return createMobileIssue(title: title, description: description, preSignedUrlId: nil)
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
            
            self.graphQLClient.performMutation(mutation: mutation)
                .subscribe(onNext: { response in
                    print("GraphQL Response: \(response)")
                    IterationX.shared.setFlowActive(false)
                    observer.onNext(())
                    observer.onCompleted()
                }, onError: { error in
                    print("Error performing GraphQL query: \(error)")
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
