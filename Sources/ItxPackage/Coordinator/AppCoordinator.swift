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
        let controller = IssueCreationViewController(image: imageView, viewControllerTitle: "Report Bug")
        presentingController.present(controller, animated: true, completion: nil)
    }

    func didSelectSuggestImprovement() {
        let controller = IssueCreationViewController(image: imageView, viewControllerTitle: "Suggest Improvement")
        presentingController.present(controller, animated: true, completion: nil)
    }
}
