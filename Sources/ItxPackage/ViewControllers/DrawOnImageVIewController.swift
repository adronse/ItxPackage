import Foundation
import UIKit

import UIKit

protocol ColorPickerViewDelegate: AnyObject {
    func colorDidChange(to color: UIColor)
}

class ColorPickerView: UIView {
    
    weak var delegate: ColorPickerViewDelegate?
    let colorIndicator = UIView(frame: CGRect(x: -25, y: 0, width: 50, height: 50))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupView()
    }
    
    private func setupView() {
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
        colorIndicator.layer.cornerRadius = colorIndicator.frame.width / 2
        colorIndicator.layer.borderColor = UIColor.white.cgColor
        colorIndicator.layer.borderWidth = 2
        colorIndicator.layer.masksToBounds = true
        colorIndicator.isHidden = true // Initially hidden
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let context = UIGraphicsGetCurrentContext()
        let colors = [UIColor.red.cgColor, UIColor.orange.cgColor, UIColor.yellow.cgColor, UIColor.green.cgColor, UIColor.blue.cgColor, UIColor.purple.cgColor]
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let colorLocations: [CGFloat] = [0.0, 0.17, 0.34, 0.51, 0.68, 0.85]
        let gradient = CGGradient(colorsSpace: colorSpace, colors: colors as CFArray, locations: colorLocations)
        let startPoint = CGPoint.zero
        let endPoint = CGPoint(x: 0, y: self.bounds.height)
        context?.drawLinearGradient(gradient!, start: startPoint, end: endPoint, options: [])
    }
    
    private func getColor(at point: CGPoint) -> UIColor {
        let adjustedYPos = self.bounds.height - max(min(point.y, self.bounds.height), 0)
        let proportion = adjustedYPos / self.bounds.height
        let gradientColors: [UIColor] = [.red, .orange, .yellow, .green, .blue, .purple]
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let colorLocations: [CGFloat] = [0.0, 0.17, 0.34, 0.51, 0.68, 0.85]
        guard let gradient = CGGradient(colorsSpace: colorSpace, colors: gradientColors.map { $0.cgColor } as CFArray, locations: colorLocations) else {
            return .black // Fallback color
        }
        
        let start = CGPoint(x: self.bounds.midX, y: 0)
        let end = CGPoint(x: self.bounds.midX, y: self.bounds.height)
        let context = CGContext(data: nil, width: 1, height: Int(self.bounds.height), bitsPerComponent: 8, bytesPerRow: 4, space: colorSpace, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!
        context.drawLinearGradient(gradient, start: start, end: end, options: [])
        guard let data = context.data else { return .black }
        
        let offset = Int(proportion * self.bounds.height) * 4
        let r = data.load(fromByteOffset: offset, as: UInt8.self)
        let g = data.load(fromByteOffset: offset+1, as: UInt8.self)
        let b = data.load(fromByteOffset: offset+2, as: UInt8.self)
        let a = data.load(fromByteOffset: offset+3, as: UInt8.self)
        
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(a) / 255.0)
    }
    
    func showColorIndicator(at point: CGPoint) {
        colorIndicator.isHidden = false
        colorIndicator.alpha = 1
        updateIndicatorPosition(at: point)
    }
    
    func hideColorIndicator() {
        UIView.animate(withDuration: 0.2, animations: {
            self.colorIndicator.alpha = 0
        }, completion: { _ in
            self.colorIndicator.isHidden = true
        })
    }
    
    func updateIndicatorPosition(at point: CGPoint) {
        let yPos = max(0, min(point.y, self.bounds.height))
        let color = self.getColor(at: CGPoint(x: self.bounds.midX, y: yPos))
        delegate?.colorDidChange(to: color)
        colorIndicator.backgroundColor = color
        
        if let _ = self.superview {
            let indicatorCenterX = self.frame.minX - (colorIndicator.frame.width / 2)
            let indicatorCenterY = self.frame.minY + yPos
            colorIndicator.center = CGPoint(x: indicatorCenterX, y: indicatorCenterY)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard let point = touches.first?.location(in: self) else { return }
        showColorIndicator(at: point)
        updateIndicatorPosition(at: point)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        guard let point = touches.first?.location(in: self) else { return }
        updateIndicatorPosition(at: point)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        hideColorIndicator()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        hideColorIndicator()
    }
    
}


class DrawOnImageViewController: UIViewController, ColorPickerViewDelegate {
    
    
    private let imageView: UIImageView
    private let drawingView: UIView
    private var currentBezierPath = UIBezierPath()
    private var shapeLayers: [CAShapeLayer] = []
    private var selectedColor: UIColor = .black
    private var colorPicker: ColorPickerView!
    
    var didFinishDrawing: ((UIImage) -> Void)?
    
    
    private let pencilButton: UIButton = {
        let button = UIButton()
        if #available(iOS 13.0, *) {
            let largeConfig = UIImage.SymbolConfiguration(pointSize: 35, weight: .bold) // Larger and bolder icon
            button.setImage(UIImage(systemName: "pencil.tip", withConfiguration: largeConfig), for: .normal)
            button.addTarget(self, action: #selector(toggleColorPicker), for: .touchUpInside)
        }
        return button
    }()
    
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
        setupNavigationBar()
        configureUI()
        addGestures()
        setUpPencilButton()
        setupColorPicker()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        colorPicker.layer.cornerRadius = 10
        colorPicker.layoutIfNeeded()
        
    }
    
    private func setUpPencilButton()
    {
        view.addSubview(pencilButton)
        pencilButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.centerY.equalToSuperview().multipliedBy(0.33)
        }
    }
    
    private func configureUI() {
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
    
    private func addGestures() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        drawingView.addGestureRecognizer(panGesture)
    }
    
    
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveDrawing))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Clear", style: .plain, target: self, action: #selector(clearDrawing))
    }
    
    private func setupColorPicker() {
        colorPicker = ColorPickerView()
        view.addSubview(colorPicker)
        
        colorPicker.delegate = self
        
        colorPicker.snp.makeConstraints { make in
            make.right.equalTo(pencilButton)
            make.top.equalTo(pencilButton.snp.bottom).offset(20)
            make.width.equalTo(20)
            make.height.equalTo(200)
        }
        
        view.addSubview(colorPicker.colorIndicator)
        
        colorPicker.colorIndicator.snp.makeConstraints { make in
            make.width.height.equalTo(50)
            make.centerY.equalTo(colorPicker.snp.centerY)
            make.right.equalTo(colorPicker.snp.left)
        }
    }
    
    
    func colorDidChange(to color: UIColor) {
        selectedColor = color
    }
    
    
    @objc private func toggleColorPicker() {
        colorPicker.isHidden = !colorPicker.isHidden
    }
    
    @objc private func saveDrawing()
    {
        guard imageView.image != nil else {
            dismiss(animated: true, completion: nil)
            return
        }
        
        DispatchQueue.main.async {
            self.colorPicker.isHidden = true
            
            let renderer = UIGraphicsImageRenderer(size: self.view.bounds.size)
            let imageWithDrawing = renderer.image { _ in
                self.view.drawHierarchy(in: self.view.bounds, afterScreenUpdates: true)
            }
            
            self.didFinishDrawing?(imageWithDrawing)
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        let point = gesture.location(in: drawingView)
        
        switch gesture.state {
        case .began:
            startNewPath(at: point)
        case .changed:
            continuePath(to: point)
        default:
            break
        }
    }
    
    private func startNewPath(at point: CGPoint) {
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = selectedColor.cgColor
        shapeLayer.lineWidth = 5
        shapeLayer.fillColor = UIColor.clear.cgColor
        currentBezierPath = UIBezierPath()
        currentBezierPath.move(to: point)
        shapeLayer.path = currentBezierPath.cgPath
        drawingView.layer.addSublayer(shapeLayer)
        shapeLayers.append(shapeLayer)
    }
    
    private func continuePath(to point: CGPoint) {
        currentBezierPath.addLine(to: point)
        shapeLayers.last?.path = currentBezierPath.cgPath
    }
    
    @objc private func clearDrawing() {
        shapeLayers.forEach { $0.removeFromSuperlayer() }
        shapeLayers.removeAll()
    }
    
    
}



