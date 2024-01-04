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

    var delegate: PopupViewControllerDelegate?

    
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
        view.addSubview(formView)
        formView.addSubview(issueTitleFieldHeader)
        formView.addSubview(issueTitleField)
        formView.addSubview(separator)
        formView.addSubview(issueDescriptionFieldHeader)
        formView.addSubview(issueDescriptionField)
        
        formView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }

        issueTitleFieldHeader.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        }
        
        issueTitleField.snp.makeConstraints { make in
            make.top.equalTo(issueTitleFieldHeader.snp.bottom).offset(10)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        }
        
        separator.snp.makeConstraints { make in
            make.top.equalTo(issueTitleField.snp.bottom).offset(10)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(1)
        }
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
    
    private lazy var formView = UIView()
        .with(\.isUserInteractionEnabled, value: true)
    
    private lazy var issueTitleFieldHeader = UILabel()
        .with(\.text, value: "Issue title")
    
    private lazy var issueTitleField = UITextField()
        .with(\.placeholder, value: "Your issue title")
    
    private lazy var separator = UIView.separator(color: .gray)
    
    private lazy var issueDescriptionFieldHeader = UILabel()
        .with(\.text, value: "Issue title")
    
    private lazy var issueDescriptionField = UITextField()
        .with(\.placeholder, value: "Your issue description")
    
    //------------------------------------------------------------------------------------------------------------ UI ------------------------------------------------------------------------------------------------ //

    
    @objc private func handleTap() {
        view.endEditing(true)
    }
    
    @objc private func didTapCancel()
    {
        self.delegate?.didTapCross()
    }
    
    
    private lazy var imageBox: UIView = {
        let box = UIView()
        return box
    }()
    
    @objc private func didTapSendButton() {
//        guard let title = issueTitleInput.text, let description = descriptionFieldInput.text else { return }
    
//        issueReport?.reportIssue(title: title, description: description, image: imageView.image) { result in
            
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
