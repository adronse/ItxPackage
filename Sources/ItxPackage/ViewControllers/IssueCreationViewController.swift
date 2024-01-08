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

import UIKit
import SnapKit

class AddPictureView: UIView {
    
    private let stackView = UIStackView()
    var onAddPictureTapped: (() -> Void)?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private lazy var addPicture: UIImageView = {
        if #available(iOS 13.0, *) {
            let imageView = UIImageView(image: UIImage(systemName: "photo.on.rectangle", withConfiguration: UIImage.SymbolConfiguration(weight: .medium)))
            imageView.isUserInteractionEnabled = true
            imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addPictureButtonTapped)))
            return imageView
        }
        return UIImageView()
    }()
    
    private lazy var label = UILabel()
        .with(\.text, value: "Add a picture")
        .with(\.font, value: .systemFont(ofSize: 16, weight: .medium))
    
    private func setupView() {
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.spacing = 8
        
        
        stackView.addArrangedSubview(addPicture)
        stackView.addArrangedSubview(label)
        addSubview(stackView)
        
        addPicture.contentMode = .scaleAspectFit
        
        label.textColor = .white
        
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapView))
        self.addGestureRecognizer(tapGesture)
    }
    
    @objc private func addPictureButtonTapped() {
        onAddPictureTapped?()
    }
    
    @objc private func didTapView() {
        onAddPictureTapped?()
    }
    
}



public class IssueCreationViewController: UIViewController, UIGestureRecognizerDelegate {
    
    
    private let imageView: UIImageView
    private let addPictureView = AddPictureView()
    
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
        
        addPictureView.onAddPictureTapped = { [weak self] in
            self?.didTapAddPictureButton()
        }
        
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
        
        view.addSubview(addPictureView)
        
        addPictureView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-40)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(50)
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
        if let selectedImage = info[.originalImage] as? UIImage {

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
