import Foundation
import UIKit


class ColorPickerView: UIView {
    
    var colorChangedBlock: ((UIColor) -> Void)?
    private let colorIndicator = UIView(frame: CGRect(x: -25, y: 0, width: 50, height: 50))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupView()
    }
    
    private func setupView() {
        self.addSubview(colorIndicator)
        colorIndicator.layer.cornerRadius = colorIndicator.frame.width / 2
        colorIndicator.layer.borderColor = UIColor.white.cgColor
        colorIndicator.layer.borderWidth = 2
        colorIndicator.layer.masksToBounds = true
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.selectColor(touches: touches)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.selectColor(touches: touches)
    }
    
    private func selectColor(touches: Set<UITouch>) {
        if let touch = touches.first {
            let point = touch.location(in: self)
            let color = self.getColor(at: point)
            self.colorChangedBlock?(color)
            self.moveIndicator(to: point.y)
            colorIndicator.backgroundColor = color
        }
    }
    
    private func moveIndicator(to yPos: CGFloat) {
        UIView.animate(withDuration: 0.1) {
            let minY = self.colorIndicator.frame.height / 2
            let maxY = self.bounds.height - minY

            let clampedYPos = min(max(yPos, minY), maxY)
            
            self.colorIndicator.center.y = clampedYPos
        }
    }
    
    private func getColor(at point: CGPoint) -> UIColor {
        let sortedColors: [UIColor] = [.red, .orange, .yellow, .green, .blue, .purple]

        let adjustedYPos = max(min(point.y, self.bounds.height), 0)
        let proportion = adjustedYPos / self.bounds.height

        let colorIndex = min(max(Int(proportion * CGFloat(sortedColors.count)), 0), sortedColors.count - 1)
        return sortedColors[colorIndex]
    }
}



class DrawOnImageViewController: UIViewController {
    
    private let imageView: UIImageView
    private let drawingView: UIView
    private var currentBezierPath = UIBezierPath()
    private var shapeLayers: [CAShapeLayer] = []
    private var selectedColor: UIColor = .black // Default drawing color
    private let colorPicker = ColorPickerView()
    
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
        setupColorPicker()
        setupNavigationBar()
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
        colorPicker.colorChangedBlock = { [weak self] color in
            self?.selectedColor = color
        }
        
        view.addSubview(colorPicker)
        
        colorPicker.layer.cornerRadius = 5
        
        colorPicker.snp.makeConstraints { make in
            make.width.equalTo(20)
            make.height.equalTo(200)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-30)
        }
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



