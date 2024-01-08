//
//  IssueCreationViewController.swift
//
//
//  Created by Adrien Ronse on 18/12/2023.
//

import Foundation
import UIKit
import SnapKit
import Photos

public class IssueCreationViewController: UIViewController, UIGestureRecognizerDelegate {
    
    
    private let imageView: UIImageView
    
    var delegate: IssueCreationViewControllerDelegate?
    var issueReport: IssueReporting?
    
    init(image: UIImageView, issueReport: IssueCoordinator) {
        self.imageView = image
        self.issueReport = issueReport
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // ------------------------------------------------------------------------------------------------------------ UI ------------------------------------------------------------------------------------------------ //
    
    private lazy var leftBarButtonItem: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "\u{274C}", style: .plain, target: self, action: #selector(didTapCancel))
        return button
    }()
    
    
    private lazy var rightBarButtonItem: UIBarButtonItem = {
        if #available(iOS 13.0, *) {
            let image = UIImage(systemName: "paperplane.fill", withConfiguration: UIImage.SymbolConfiguration(weight: .regular))
            
            let button = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(didTapSendButton))
            return button
        } else {
            
        }
        return UIBarButtonItem()
    }()
    
    
    private lazy var issueTitleFieldHeader = UILabel()
        .with(\.text, value: "Title")
        .with(\.textColor, value: UIColor.from(hex: "#4a4a4d"))
    
    private lazy var issueTitleField = UITextField()
        .with(\.placeholder, value: "Your issue title")
        .with(\.isUserInteractionEnabled, value: true)
    
    private lazy var separator = UIView.separator(color: .gray)
    
    private lazy var issueDescriptionFieldHeader = UILabel()
        .with(\.textColor, value: UIColor.from(hex: "#4a4a4d"))
        .with(\.text, value: "Description")
    
    private lazy var issueDescriptionField = UITextField()
        .with(\.placeholder, value: "Describe your issue")
        .with(\.isUserInteractionEnabled, value: true)
    
    
    private let addPictureButton: UIButton = {
        let button = UIButton()
        if #available(iOS 13.0, *) {
            let largeConfig = UIImage.SymbolConfiguration(pointSize: 35, weight: .bold)
            let pencilImage = UIImage(systemName: "photo.on.rectangle", withConfiguration: largeConfig)?.withTintColor(.white, renderingMode: .alwaysOriginal)
            button.setImage(pencilImage, for: .normal)
            button.addTarget(self, action: #selector(didTapAddPictureButton), for: .touchUpInside)
        }
        return button
    }()
    
    private let addPictureLabel: UILabel = {
        let label = UILabel()
        label.text = "Select file from gallery"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    //------------------------------------------------------------------------------------------------------------ UI ------------------------------------------------------------------------------------------------ //
    
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.from(hex: "#292A2F")
        configureUI()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        
        let tapGestureOnImageBox = UITapGestureRecognizer(target: self, action: #selector(handleImageBoxTap))
        tapGestureOnImageBox.delegate = self
        imageBox.addGestureRecognizer(tapGestureOnImageBox)
    }
    
    private func configureUI() {
        setupNavigationBar()
        setupForm()
    }
    
    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = leftBarButtonItem
        navigationItem.rightBarButtonItem = rightBarButtonItem
        navigationItem.title = "Report a bug"
    }
    
    private func setupForm()
    {
        view.addSubview(issueTitleFieldHeader)
        view.addSubview(issueTitleField)
        view.addSubview(separator)
        view.addSubview(issueDescriptionFieldHeader)
        view.addSubview(issueDescriptionField)
        
        issueTitleFieldHeader.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
        
        issueTitleField.snp.makeConstraints { make in
            make.top.equalTo(issueTitleFieldHeader.snp.bottom).offset(10)
            make.left.right.equalTo(issueTitleFieldHeader)
        }
        
        separator.snp.makeConstraints { make in
            make.top.equalTo(issueTitleField.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(5)
            make.right.equalToSuperview().offset(-5)
            make.height.equalTo(1)
        }
        
        issueDescriptionFieldHeader.snp.makeConstraints { make in
            make.top.equalTo(separator.snp.bottom).offset(20)
            make.left.right.equalTo(issueTitleFieldHeader)
        }
        
        issueDescriptionField.snp.makeConstraints { make in
            make.top.equalTo(issueDescriptionFieldHeader.snp.bottom).offset(10)
            make.left.right.equalTo(issueDescriptionFieldHeader)
        }
        
        view.addSubview(imageBox)
        imageBox.addSubview(imageView)
        
        
        imageBox.snp.makeConstraints { make in
            make.top.equalTo(issueDescriptionField.snp.bottom).offset(50)
            make.left.equalTo(issueDescriptionField)
            make.size.equalTo(40)
        }
        
        imageView.snp.makeConstraints { make     in
            make.edges.equalToSuperview()
        }
        
        view.addSubview(addPictureButton)
        view.addSubview(addPictureLabel)
        
        addPictureButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-20)
            make.leading.equalToSuperview().offset(20)
        }
        
        addPictureLabel.snp.makeConstraints { make in
            make.centerY.equalTo(addPictureButton)
            make.leading.equalTo(addPictureButton.snp.trailing).offset(10)
        }
    }

    
    @objc private func handleTap() {
        view.endEditing(true)
    }
    
    @objc private func didTapCancel()
    {
        self.delegate?.didTapCross()
    }
    
    
    private lazy var imageBox = UIView()
        .with(\.layer.cornerRadius, value: 5)
        .with(\.layer.masksToBounds, value: true)
    
    @objc private func didTapSendButton() {
        guard let title = issueTitleField.text, let description = issueDescriptionField.text, let image = imageView.image else { return }
        
        issueReport?.reportIssue(title: title, description: description, image: image) { result in
            switch result {
            case .success:
                self.delegate?.didCreateIssue()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    // UITextFieldDelegate method to dismiss keyboard on return key
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc private func handleImageBoxTap() {
        guard let image = imageView.image else {
            return
        }
        
        let drawOnImageViewController = DrawOnImageViewController(image: image)
        drawOnImageViewController.modalPresentationStyle = .fullScreen
        
        
        drawOnImageViewController.didFinishDrawing = { [weak self] modifiedImage in
            self?.imageView.image = modifiedImage
        }
        
        let navigationController = UINavigationController(rootViewController: drawOnImageViewController)
        navigationController.modalPresentationStyle = .fullScreen
        
        present(navigationController, animated: true, completion: nil)
    }
}

extension IssueCreationViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @objc public func didTapAddPictureButton() {
        // Check if the photo library is available
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else { return }

        // Create and configure the image picker
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self

        // Present the image picker
        present(imagePicker, animated: true)
    }

    // UIImagePickerControllerDelegate method
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Extract the image from the info dictionary
        if let selectedImage = info[.originalImage] as? UIImage {
            // Update your imageView with the selected image
            imageView.image = selectedImage
        }

        // Dismiss the picker
        picker.dismiss(animated: true)
    }

    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled
        picker.dismiss(animated: true)
    }
}
