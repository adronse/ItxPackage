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
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                let graphQLClient = GraphQLClientFactory.createClient()
                let issueCoordinator = IssueCoordinator(graphQLClient: graphQLClient)
                let issueCreationVC = IssueCreationViewController(image: self.imageView, issueReport: issueCoordinator)
                
                let navigationController = UINavigationController(rootViewController: issueCreationVC)
                
                navigationController.navigationBar.prefersLargeTitles = true
                issueCreationVC.navigationItem.title = "Report a bug"
                
                self.presentingController.present(navigationController, animated: true, completion: nil)
            }
        }
    
    func didSelectSuggestImprovement() {
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            let graphQLClient = GraphQLClientFactory.createClient()
            let issueCoordinator = IssueCoordinator(graphQLClient: graphQLClient)
            let issueCreationVC = IssueCreationViewController(image: self.imageView, issueReport: issueCoordinator)
            
            let navigationController = UINavigationController(rootViewController: issueCreationVC)
            
            navigationController.navigationBar.prefersLargeTitles = true
            issueCreationVC.navigationItem.title = "Suggest an improvement"
            
            self.presentingController.present(navigationController, animated: true, completion: nil)
        }
    }
}

