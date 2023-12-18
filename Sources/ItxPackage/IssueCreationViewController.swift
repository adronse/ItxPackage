//
//  File.swift
//
//
//  Created by Adrien Ronse on 18/12/2023.
//

import Foundation
import UIKit
import Photos

public class IssueCreationViewController: UIViewController {

    public override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Report a bug"
        self.view.backgroundColor = UIColor.from(hex: "#292A2F")
        configureUI()
        displayLatestScreenshot()
    }
    
    private lazy var emailFieldTitle: UILabel = {
        let label = UILabel()
        label.text = "Email"
        label.textColor = UIColor.from(hex: "#454547")
        return label
    }()
    
    private lazy var emailField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "john.doe@iterationx.io"
        textField.textColor = .white
        return textField
    }()
    
    private lazy var screenshotImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private func configureUI() {
        view.addSubview(emailFieldTitle)
        view.addSubview(emailField)
        view.addSubview(screenshotImageView)
        
        emailFieldTitle.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(60)
            make.leading.trailing.equalToSuperview().inset(5)
            make.height.equalTo(40)
        }
        
        emailField.snp.makeConstraints { make in
            make.top.equalTo(emailFieldTitle.snp.bottom).offset(5)
            make.leading.trailing.equalToSuperview().inset(5)
            make.height.equalTo(40)
        }
        
        screenshotImageView.snp.makeConstraints { make in
            make.top.equalTo(emailField.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(5)
            make.bottom.equalToSuperview().inset(10)
        }
    }
    
    private func displayLatestScreenshot() {
        // Fetch the latest screenshot from the photo library
        if let latestScreenshot = fetchLatestScreenshot() {
            screenshotImageView.image = latestScreenshot
        }
    }

    private func fetchLatestScreenshot() -> UIImage? {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        let fetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)

        guard let latestAsset = fetchResult.firstObject else {
            return nil
        }

        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = true

        var latestScreenshot: UIImage?

        PHImageManager.default().requestImage(for: latestAsset, targetSize: CGSize(width: 200, height: 200), contentMode: .aspectFit, options: requestOptions) { (image, _) in
            latestScreenshot = image
        }

        return latestScreenshot
    }
}
