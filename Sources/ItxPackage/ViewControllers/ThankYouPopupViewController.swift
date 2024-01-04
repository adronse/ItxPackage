//
//  File.swift
//  
//
//  Created by Adrien Ronse on 04/01/2024.
//

import UIKit
import SnapKit


class ThankYouPopupViewController: UIViewController {

    private lazy var popupView = UIView()
        .with(\.backgroundColor, value: UIColor.from(hex: "#333333"))
        .with(\.layer.cornerRadius, value: 10)
        .with(\.layer.masksToBounds, value: true)
    
    private lazy var checkMarkIcon = UIImageView()
        .with(\.image, value: UIImage(named: "checkMarkIcon"))
        .with(\.contentMode, value: .scaleAspectFit)
    
    private lazy var thankYouLabel = UILabel()
        .with(\.text, value: "Thank you")
    
    private lazy var descriptionLabel = UILabel()
        .with(\.text, value: "Your issue has been sent to Iteration X")

    override func viewDidLoad() {
        super.viewDidLoad()
        setupPopupView()
    }

    private func setupPopupView() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5) // Semi-transparent background
        view.addSubview(popupView)

        popupView.addSubview(checkMarkIcon)
        popupView.addSubview(thankYouLabel)
        popupView.addSubview(descriptionLabel)

        popupView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8) // 80% of screen width
            make.height.equalTo(popupView.snp.width) // half the width for height
        }

        checkMarkIcon.snp.makeConstraints { make in
            make.top.equalTo(popupView.snp.top).offset(20)
            make.centerX.equalToSuperview()
            make.size.equalTo(60) // Assuming a square icon
        }

        thankYouLabel.snp.makeConstraints { make in
            make.top.equalTo(checkMarkIcon.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }

        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(thankYouLabel.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(popupView.snp.bottom).offset(-20) // Padding at the bottom
        }

        thankYouLabel.font = UIFont.boldSystemFont(ofSize: 18)
        descriptionLabel.font = UIFont.systemFont(ofSize: 14)
        descriptionLabel.textColor = .darkGray
        descriptionLabel.numberOfLines = 0 // Allow label to wrap
        descriptionLabel.textAlignment = .center
    }


}
