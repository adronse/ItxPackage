import Foundation
import UIKit

class DrawOnImageViewController: UIViewController {

    private let imageView: UIImageView
    private let drawingView: UIView
    private var path: UIBezierPath?
    private var startPoint: CGPoint?
    private var panGesture = UIPanGestureRecognizer()
    private var currentBezierPath = UIBezierPath()
    private var shapeLayers: [CAShapeLayer] = []
    private let clearButton: UIButton = {
        let button = UIButton()
        button.setTitle("Clear", for: .normal)
        button.backgroundColor = .red
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
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
        setupClearButton()
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
            self.shapeLayers.append(shapeLayer)
        })
    }

    private func setupClearButton() {
        clearButton.addTarget(self, action: #selector(clearDrawing), for: .touchUpInside)
        view.addSubview(clearButton)

        clearButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
            make.centerX.equalToSuperview()
            make.width.equalTo(100)
            make.height.equalTo(50)
        }
    }

    @objc private func clearDrawing() {
        shapeLayers.forEach { $0.removeFromSuperlayer() }
        shapeLayers.removeAll()
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
