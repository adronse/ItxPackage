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
        .with(\.contentMode, value: .scaleAspectFit)
    
    private lazy var thankYouLabel = UILabel()
        .with(\.text, value: "Thank you")
    
    private lazy var descriptionLabel = UILabel()
        .with(\.text, value: "Your issue has been sent to Iteration X")
        .with(\.textAlignment, value: .center)
        .with(\.numberOfLines, value: 0)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupPopupView()
    }

    private func setupPopupView() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view.addSubview(popupView)


        if #available(iOS 13.0, *) {
            checkMarkIcon.image = UIImage(systemName: "checkmark.circle", withConfiguration: UIImage.SymbolConfiguration(weight: .regular))
            checkMarkIcon.tintColor = .systemGreen
        } else {
            // Fallback on earlier versions or add a custom checkmark image
        }

        popupView.addSubview(checkMarkIcon)
        popupView.addSubview(thankYouLabel)
        popupView.addSubview(descriptionLabel)
        
        popupView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(300)
            make.height.equalTo(200)
        }
        
        checkMarkIcon.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(50)
        }
        
        thankYouLabel.snp.makeConstraints { make in
            make.top.equalTo(checkMarkIcon.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(thankYouLabel.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
        }

    }


}
