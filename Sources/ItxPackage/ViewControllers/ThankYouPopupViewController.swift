//
//  File.swift
//  
//
//  Created by Adrien Ronse on 04/01/2024.
//

import UIKit
import SnapKit

class ThankYouPopupViewController: UIViewController {
    
    let popupView = UIView()
    let checkmarkImageView = UIImageView()
    let thankYouLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupPopupView()
        setupCheckmarkImageView()
        setupThankYouLabel()
    }

    private func setupPopupView() {
        view.addSubview(popupView)
        popupView.backgroundColor = .white
        popupView.layer.cornerRadius = 12
        popupView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(240)
            make.height.equalTo(140)
        }
    }

    private func setupCheckmarkImageView() {
        popupView.addSubview(checkmarkImageView)
        if #available(iOS 13.0, *) {
            checkmarkImageView.image = UIImage(systemName: "checkmark.circle", withConfiguration: UIImage.SymbolConfiguration(weight: .regular))
        } else {
        }
        checkmarkImageView.contentMode = .scaleAspectFit
        checkmarkImageView.snp.makeConstraints { make in
            make.top.equalTo(popupView.snp.top).offset(20)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(40)
        }
    }

    private func setupThankYouLabel() {
        popupView.addSubview(thankYouLabel)
        thankYouLabel.text = "Thank You"
        thankYouLabel.textAlignment = .center
        thankYouLabel.font = UIFont.boldSystemFont(ofSize: 18)
        thankYouLabel.snp.makeConstraints { make in
            make.top.equalTo(checkmarkImageView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.left.right.equalToSuperview().inset(20)
        }
    }
}
