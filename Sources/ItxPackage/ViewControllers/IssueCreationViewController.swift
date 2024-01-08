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

class ImageStackView: UIView {
    
    private let stackView = UIStackView()
    var onImageTapped: ((Int) -> Void)?
    
    var images: [UIImage] = [] {
        didSet {
            updateImages()
        }
    }
    
    public func addImage(_ image: UIImage) {
        images.append(image)
        updateImages()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 8
        
        addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapView))
        self.addGestureRecognizer(tapGesture)
    }
    
    public func updateImages() {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for (index, image) in images.enumerated() {
            let imageView = createImageView(for: image, withTag: index)
            stackView.addArrangedSubview(imageView)
        }
    }
    
    private func createImageView(for image: UIImage, withTag tag: Int) -> UIImageView {
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 2
        imageView.isUserInteractionEnabled = true
        imageView.tag = tag
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapImage)))
        
        imageView.snp.makeConstraints { make in
            make.width.height.equalTo(60)
        }
        
        // Create the cross button
        let crossButton = UIButton(type: .system)
        if #available(iOS 13.0, *) {
            crossButton.setImage(UIImage(systemName: "xmark.circle.fill", withConfiguration: UIImage.SymbolConfiguration(weight: .medium))?.withTintColor(.systemPink, renderingMode: .alwaysOriginal), for: .normal)
        }
        crossButton.tintColor = .white
        crossButton.addTarget(self, action: #selector(removeImage(_:)), for: .touchUpInside)
        crossButton.tag = tag
        
        imageView.addSubview(crossButton)
        
        crossButton.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.top)
            make.right.equalTo(imageView.snp.right)
            make.width.height.equalTo(25)
        }
        
        
        return imageView
    }
    
    @objc private func removeImage(_ sender: UIButton) {
        let tag = sender.tag
        guard images.indices.contains(tag) else { return }
        images.remove(at: tag)
        updateImages()
    }
    
    @objc private func didTapView() {
        onImageTapped?(-1)
    }
    
    @objc private func didTapImage(_ sender: UITapGestureRecognizer) {
        guard let imageView = sender.view as? UIImageView else { return }
        onImageTapped?(imageView.tag)
    }
}




public class IssueCreationViewController: UIViewController, UIGestureRecognizerDelegate {
    
    
    private let imageView: UIImageView
    private let addPictureView = AddPictureView()
    private let imageStackView = ImageStackView()
    
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
        
        
        imageStackView.addImage(self.imageView.image!)
        
        imageStackView.onImageTapped = { [weak self] index in
            guard let strongSelf = self, index >= 0, index < strongSelf.imageStackView.images.count else { return }
            let selectedImage = strongSelf.imageStackView.images[index]
            strongSelf.presentDrawOnImageViewController(with: selectedImage, index: index)
        }
        
        
        self.view.backgroundColor = UIColor.from(hex: "#292A2F")
        configureUI()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        
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
        
        
        view.addSubview(imageStackView)
        
        
        imageStackView.snp.makeConstraints { make in
            make.top.equalTo(issueDescriptionField.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(20)
            make.height.equalTo(100)
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
    
    private func presentDrawOnImageViewController(with image: UIImage, index: Int) {
        let drawOnImageViewController = DrawOnImageViewController(image: image)
        drawOnImageViewController.modalPresentationStyle = .fullScreen
        
        drawOnImageViewController.didFinishDrawing = { [weak self] modifiedImage in
            self?.imageStackView.images[index] = modifiedImage
            self?.imageStackView.updateImages()
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
        
        
        present(imagePicker, animated: true)
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage, let correctedImage = correctImageOrientation(selectedImage) {
            imageStackView.addImage(correctedImage)
        }
        picker.dismiss(animated: true)
    }
    
    func correctImageOrientation(_ img: UIImage) -> UIImage? {
        if img.imageOrientation == .down {
            return img
        }
        
        UIGraphicsBeginImageContextWithOptions(img.size, false, img.scale)
        img.draw(in: CGRect(origin: .zero, size: img.size))
        let normalizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return normalizedImage
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled
        picker.dismiss(animated: true)
    }
}
