//
//  IssueCreationViewController.swift
//
//
//  Created by Adrien Ronse on 18/12/2023.
//

import Foundation
import UIKit
import SnapKit


class FullScreenImageViewController: UIViewController {
    
    private let imageView: UIImageView
    private let drawingView: UIView
    private var path: UIBezierPath?
    private var startPoint: CGPoint?
    private var panGesture = UIPanGestureRecognizer()
    private var currentBezierPath = UIBezierPath()
    var didFinishDrawing: ((UIImage) -> Void)?

    
    init(image: UIImage) {
        self.imageView = UIImageView(image: image)
        self.drawingView = UIView()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        addGestures()
    }
    
    private func configureUI()
    {
        view.backgroundColor = .black
        
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        
        drawingView.backgroundColor = .clear
        drawingView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(drawingView)
        
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        drawingView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.height.equalTo(imageView)
        }
    }
    
    private func addGestures()
    {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tapGesture)
        
        view.addGestureRecognizer(panGesture.onChange { gesture in
            let point = gesture.location(in: self.view)
            
            let shapeLayer = CAShapeLayer()
            shapeLayer.strokeColor = UIColor.red.cgColor
            shapeLayer.lineWidth = 5
            shapeLayer.fillColor = UIColor.clear.cgColor
            
            switch gesture.state {
            case .began:
                self.currentBezierPath = UIBezierPath()
                self.currentBezierPath.move(to: point)
            case .changed:
                self.currentBezierPath.addLine(to: point)
            default:
                break
            }
            shapeLayer.path = self.currentBezierPath.cgPath
            self.view.layer.addSublayer(shapeLayer)
        })
    }
    
    @objc private func handleTap() {
        guard imageView.image != nil else {
            dismiss(animated: true, completion: nil)
            return
        }
        
        let renderer = UIGraphicsImageRenderer(size: view.bounds.size)
        let imageWithDrawing = renderer.image { context in
            view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        }
        
        didFinishDrawing?(imageWithDrawing)
        dismiss(animated: true, completion: nil)
    }
    
}


public class IssueCreationViewController: UIViewController, UIGestureRecognizerDelegate {
    
    
    private let imageView: UIImageView
    var issueReport: IssueReporting?
    
    init(image: UIImageView, issueReport: IssueCoordinator) {
        self.imageView = image
        self.issueReport = issueReport
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
    
    @objc private func handleTap() {
        view.endEditing(true)
    }
    
    @objc private func didTapSendButton() {
        guard let title = issueTitleInput.text, let description = descriptionFieldInput.text else { return }
        

        
        issueReport?.reportIssue(title: title, description: description, image: imageView.image) { result in
            
        }
    }
    
    private lazy var issueTitleHeader: UILabel = {
        let label = UILabel()
        label.text = "Issue"
        label.textColor = .white
        return label
    }()
    
    private lazy var issueTitleInput: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Issue title"
        textField.textColor = .white
        return textField
    }()
    
    lazy var separator = UIView.separator(color: .white)
    
    private lazy var descriptionFieldTitle: UILabel = {
        let label = UILabel()
        label.text = "Description"
        label.textColor = .white
        return label
    }()
    
    private lazy var descriptionFieldInput: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Please be as detailed as possible. What did you expect and what happened instead?"
        textField.textColor = .white
        return textField
    }()
    
    
    private lazy var imageBox: UIView = {
        let box = UIView()
        return box
    }()
    
    
    private lazy var sendButton: UIButton = {
        let button = UIButton()
        button.setTitle("Send issue", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(didTapSendButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var leftBarButtonItem: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "\u{274C}", style: .plain, target: self, action: nil)
        return button
    }()
    
    
    private lazy var rightBarButtonItem: UIBarButtonItem = {
        if #available(iOS 13.0, *) {
            let image = UIImage(systemName: "paperplane.fill", withConfiguration: UIImage.SymbolConfiguration(weight: .regular))
            
            let button = UIBarButtonItem(image: image, style: .plain, target: self, action: nil)
            return button
        } else {
            // Fallback on earlier versions
        }
        return UIBarButtonItem()
    }()

    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = leftBarButtonItem
        navigationItem.rightBarButtonItem = rightBarButtonItem
        navigationItem.titleView?.snp.makeConstraints { make in
            make.center.equalTo(self.view)
            
        }
    }
    
    private func configureUI() {
        
        setupNavigationBar()
        
//        view.addSubview(issueTitleHeader)
//        view.addSubview(issueTitleInput)
//        view.addSubview(imageBox)
//        imageBox.addSubview(imageView)
//        view.addSubview(separator)
//        view.addSubview(descriptionFieldTitle)
//        view.addSubview(descriptionFieldInput)
//        view.addSubview(sendButton)
//
//        issueTitleHeader.snp.makeConstraints { make in
//            make.top.equalToSuperview().offset(60)
//            make.leading.trailing.equalToSuperview().inset(2)
//            make.height.equalTo(40)
//        }
//
//        issueTitleInput.snp.makeConstraints { make in
//            make.top.equalTo(issueTitleHeader.snp.bottom).offset(2)
//            make.leading.trailing.equalToSuperview().inset(5)
//            make.height.equalTo(40)
//        }
//
//        separator.snp.makeConstraints { make in
//            make.top.equalTo(issueTitleInput.snp.bottom).offset(2)
//            make.height.equalTo(1)
//            make.leading.trailing.equalToSuperview().inset(5)
//        }
//
//        descriptionFieldTitle.snp.makeConstraints { make in
//            make.top.equalTo(separator.snp.bottom).offset(5)
//            make.leading.trailing.equalToSuperview().inset(5)
//            make.height.equalTo(40)
//        }
//
//        descriptionFieldInput.snp.makeConstraints { make in
//            make.top.equalTo(descriptionFieldTitle.snp.bottom).offset(2)
//            make.leading.trailing.equalToSuperview().inset(5)
//            make.height.equalTo(40)
//        }
//
//        imageBox.snp.makeConstraints { make in
//            make.top.equalTo(descriptionFieldInput.snp.bottom).offset(30)
//            make.leading.equalTo(descriptionFieldInput)
//            make.size.equalTo(40)
//        }
//
//        imageView.snp.makeConstraints { make in
//            make.edges.equalToSuperview()
//        }
//
//        sendButton.snp.makeConstraints { make in
//            make.bottom.equalToSuperview().inset(20)
//            make.leading.trailing.equalToSuperview().offset(10)
//            make.height.equalTo(30)
//        }
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
        
        let fullScreenImageViewController = FullScreenImageViewController(image: image)
        fullScreenImageViewController.modalPresentationStyle = .fullScreen
        
        fullScreenImageViewController.didFinishDrawing = { [weak self] modifiedImage in
            self?.imageView.image = modifiedImage
        }
        
        present(fullScreenImageViewController, animated: true, completion: nil)
    }
}
