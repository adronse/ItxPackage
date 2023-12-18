//
//  File.swift
//
//
//  Created by Adrien Ronse on 18/12/2023.
//

import Foundation
import UIKit
import Photos


class FullScreenImageViewController: UIViewController {
    
    private let imageView: UIImageView
    private let drawingView: UIView
    private var path: UIBezierPath?
    private var startPoint: CGPoint?
    
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
        
        view.backgroundColor = .black
        
        // Setup image view
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        
        // Setup drawing view
        drawingView.backgroundColor = .clear
        drawingView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(drawingView)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tapGesture)
        
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        drawingView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        // Setup pan gesture for drawing
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        drawingView.addGestureRecognizer(panGesture)
    }
    
    @objc private func handleTap() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func handlePan(_ gestureRecognizer: UIPanGestureRecognizer) {
        let location = gestureRecognizer.location(in: drawingView)
        
        switch gestureRecognizer.state {
        case .began:
            startDrawing(at: location)
        case .changed:
            continueDrawing(to: location)
        case .ended:
            stopDrawing()
        default:
            break
        }
    }
    
    private func startDrawing(at point: CGPoint) {
        path = UIBezierPath()
        path?.lineWidth = 5.0
        path?.lineCapStyle = .round
        path?.move(to: point)
        startPoint = point
    }
    
    private func continueDrawing(to point: CGPoint) {
        path?.addLine(to: point)
        drawPath()
    }
    
    private func stopDrawing() {
        startPoint = nil
    }
    
    private func drawPath() {
        guard let path = path else { return }
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = UIColor.white.cgColor
        shapeLayer.lineWidth = path.lineWidth
        shapeLayer.lineCap = .round
        
        drawingView.layer.addSublayer(shapeLayer)
        drawingView.setNeedsDisplay()
    }
}




public class IssueCreationViewController: UIViewController, UIGestureRecognizerDelegate {
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Report a bug"
        self.view.backgroundColor = UIColor.from(hex: "#292A2F")
        configureUI()
        displayLatestScreenshot()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        
        let tapGestureOnImageBox = UITapGestureRecognizer(target: self, action: #selector(handleImageBoxTap))
        tapGestureOnImageBox.delegate = self
        imageBox.addGestureRecognizer(tapGestureOnImageBox)
    }
    
    @objc private func handleTap() {
        // Dismiss the keyboard by resigning the first responder
        view.endEditing(true)
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
        view.addSubview(issueTitleHeader)
        view.addSubview(issueTitleInput)
        view.addSubview(screenshotImageView)
        view.addSubview(imageBox)
        imageBox.addSubview(screenshotImageView)
        view.addSubview(separator)
        view.addSubview(descriptionFieldTitle)
        view.addSubview(descriptionFieldInput)
        view.addSubview(sendButton)
        
        issueTitleHeader.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(60)
            make.leading.trailing.equalToSuperview().inset(2)
            make.height.equalTo(40)
        }
        
        issueTitleInput.snp.makeConstraints { make in
            make.top.equalTo(issueTitleHeader.snp.bottom).offset(2)
            make.leading.trailing.equalToSuperview().inset(5)
            make.height.equalTo(40)
        }
        
        separator.snp.makeConstraints { make in
            make.top.equalTo(issueTitleInput.snp.bottom).offset(2)
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
        
        imageBox.snp.makeConstraints { make in
            make.top.equalTo(descriptionFieldInput.snp.bottom).offset(30)
            make.leading.equalTo(descriptionFieldInput)
            make.size.equalTo(40)
        }
        
        screenshotImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        sendButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(20)
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
        
        let screenSize = UIScreen.main.bounds.size
        
        PHImageManager.default().requestImage(for: latestAsset, targetSize: screenSize, contentMode: .aspectFit, options: requestOptions) { (image, _) in
            latestScreenshot = image
        }
        
        return latestScreenshot
    }
    
    // UITextFieldDelegate method to dismiss keyboard on return key
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc private func handleImageBoxTap() {
        guard let image = screenshotImageView.image else {
            return
        }
        
        // Display the image in full screen
        let fullScreenImageViewController = FullScreenImageViewController(image: image)
        fullScreenImageViewController.modalPresentationStyle = .fullScreen
        present(fullScreenImageViewController, animated: true, completion: nil)
    }
}
