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
    
    lazy var separator = UIView.separator(color: .white)
    
    private lazy var descriptionFieldTitle: UILabel = {
        let label = UILabel()
        label.text = "Description"
        label.textColor = UIColor.from(hex: "#454547")
        return label
    }()
    
    private lazy var descriptionFieldInput: UITextField = {
        let textField = UITextField()
        textField.placeholder = "john.doe@iterationx.io"
        textField.textColor = .white
        return textField
    }()
    
    private lazy var descriptionFieldDesc: UILabel = {
        let label = UILabel()
        label.text = "Please be as detailed as possible. What did you expect and what happened instead?"
        label.textColor = UIColor.from(hex: "#454547")
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var screenshotImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private lazy var imageBox: UIView = {
        let box = UIView()
        return box
    }()
    
    
    private lazy var sendButton: UIButton = {
        let button = UIButton()
        button.setTitle("Send issue", for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    private func configureUI() {
        view.addSubview(emailFieldTitle)
        view.addSubview(emailField)
        view.addSubview(screenshotImageView)
        view.addSubview(imageBox)
        imageBox.addSubview(screenshotImageView)
        view.addSubview(separator)
        view.addSubview(descriptionFieldTitle)
        view.addSubview(descriptionFieldInput)
        view.addSubview(descriptionFieldDesc)
        view.addSubview(sendButton)
        
        emailFieldTitle.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(60)
            make.leading.trailing.equalToSuperview().inset(2)
            make.height.equalTo(40)
        }
        
        emailField.snp.makeConstraints { make in
            make.top.equalTo(emailFieldTitle.snp.bottom).offset(2)
            make.leading.trailing.equalToSuperview().inset(5)
            make.height.equalTo(40)
        }
        
        separator.snp.makeConstraints { make in
            make.top.equalTo(emailField.snp.bottom).offset(2)
            make.height.equalTo(1)
            make.leading.trailing.equalToSuperview().inset(5)
        }
        
        descriptionFieldTitle.snp.makeConstraints { make in
            make.top.equalTo(separator.snp.bottom).offset(5)
            make.leading.trailing.equalToSuperview().inset(5)
            make.height.equalTo(40)
        }
        
        descriptionFieldInput.snp.makeConstraints { make in
            make.top.equalTo(descriptionFieldTitle.snp.bottom).offset(2)
            make.leading.trailing.equalToSuperview().inset(5)
            make.height.equalTo(40)
        }
        
        descriptionFieldDesc.snp.makeConstraints { make in
            make.top.equalTo(descriptionFieldInput.snp.bottom).offset(2)
            make.leading.trailing.equalToSuperview().inset(5)
            make.height.equalTo(40)
        }
        
        imageBox.snp.makeConstraints { make in
            make.top.equalTo(descriptionFieldDesc.snp.bottom).offset(30)
            make.leading.equalTo(descriptionFieldDesc)
            make.size.equalTo(40)
        }
        
        screenshotImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        sendButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(5)
            make.leading.trailing.equalToSuperview().offset(10)
            make.height.equalTo(30)
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
