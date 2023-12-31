//
//  AppCoordinator.swift
//
//
//  Created by Adrien Ronse on 04/01/2024.
//

import Foundation
import UIKit

public protocol Coordinator {
    func start()
}

public class ScreenshotCoordinator: Coordinator {
    private var iterationX: IterationX
    private var presentingController: UIViewController
    private var imageView: UIImageView
    
    public init(iterationX: IterationX, presentingController: UIViewController, imageView: UIImageView) {
        self.iterationX = iterationX
        self.presentingController = presentingController
        self.imageView = imageView
    }
    
    public func start() {
        let popupViewController = PopupViewController(imageView: imageView)
        popupViewController.delegate = self
        presentingController.present(popupViewController, animated: true, completion: nil)
    }
}


extension ScreenshotCoordinator: PopupViewControllerDelegate {
    func didSelectReportBug() {
        DispatchQueue.main.async {
            let networkClient = GraphQLClientFactory.createClient()
            let issueCoordinator = IssueCoordinator(networkClient: networkClient)
            let issueCreationVC = IssueCreationViewController(image: self.imageView, issueReport: issueCoordinator)
            
            issueCreationVC.delegate = self
            
            let navigationController = UINavigationController(rootViewController: issueCreationVC)
            
            navigationController.modalPresentationStyle = .fullScreen
            
            self.presentingController.present(navigationController, animated: true, completion: nil)
        }
    }
    
    func didSelectSuggestImprovement() {
        DispatchQueue.main.async {
            let networkClient = GraphQLClientFactory.createClient()
            let issueCoordinator = IssueCoordinator(networkClient: networkClient)
            let issueCreationVC = IssueCreationViewController(image: self.imageView, issueReport: issueCoordinator)
            
            
            issueCreationVC.delegate = self
            
            let navigationController = UINavigationController(rootViewController: issueCreationVC)
            
            self.presentingController.present(navigationController, animated: true, completion: nil)
        }
    }
}

extension ScreenshotCoordinator: IssueCreationViewControllerDelegate {
    
    
    func isCreatingIssue() {
        DispatchQueue.main.async {
            let loadingVC = LoadingViewController()
            loadingVC.modalPresentationStyle = .overFullScreen
            self.presentingController.present(loadingVC, animated: true)
        }
    }
    
    
    func didCreateIssue() {
        DispatchQueue.main.async {
            self.presentingController.dismiss(animated: true) {
                let thankYouVC = ThankYouPopupViewController()
                self.presentingController.present(thankYouVC, animated: true)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    thankYouVC.dismiss(animated: true)
                }
            }
        }
    }
    
    func didTapCross() {
        DispatchQueue.main.async {
            self.presentingController.dismiss(animated: true)
        }
        IterationX.shared.setFlowActive(false)
    }
}

