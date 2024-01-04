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
    
    private lazy var checkMarkIcon = UIImageView()
        .with(\.contentMode, value: .scaleAspectFit)
        .with(\.backgroundColor, value: UIColor.from(hex: "#333333"))
    
    private lazy var thankYouLabel = UILabel()
        .with(\.text, value: "Thank you")
    
    private lazy var descriptionLabel = UILabel()
        .with(\.text, value: "Your issue has been sent to Iteration X")

    override func viewDidLoad() {
        super.viewDidLoad()
        setupPopupView()
    }

    private func setupPopupView() {
        view.addSubview(popupView)
        
        if #available(iOS 13.0, *) {
            checkMarkIcon.image = UIImage(systemName: "checkmark.circle", withConfiguration: UIImage.SymbolConfiguration(weight: .regular))
        } else {
            // Fallback on earlier versions
        }
        
        popupView.addSubview(checkMarkIcon)
        popupView.addSubview(thankYouLabel)
        popupView.addSubview(descriptionLabel)
        
        popupView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(80)
        }
        
        checkMarkIcon.snp.makeConstraints { make in
            make.centerX.equalTo(popupView.center.x)
            make.top.equalTo(popupView.snp.top).offset(5)
        }
        
        thankYouLabel.snp.makeConstraints { make in
            make.centerX.equalTo(popupView.snp.centerX)
            make.top.equalTo(checkMarkIcon.snp.bottom).offset(5)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.centerX.equalTo(popupView.snp.centerX)
            make.top.equalTo(thankYouLabel.snp.bottom).offset(5)
        }
    }
}
