//
//  File.swift
//
//
//  Created by Adrien Ronse on 04/01/2024.
//

import UIKit
import SnapKit


class LoadingViewController: UIViewController {

    private lazy var popupView = UIView()
        .with(\.backgroundColor, value: UIColor.from(hex: "#333333"))
        .with(\.layer.cornerRadius, value: 10)
        .with(\.layer.masksToBounds, value: true)
    
    
    private lazy var loadingIndicator = UIActivityIndicatorView()
        .with(\.style, value: .whiteLarge)
        .with(\.color, value: .white)
        .with(\.hidesWhenStopped, value: true)
    
    private lazy var descriptionLabel = UILabel()
        .with(\.text, value: "We are creating your issue...")
        .with(\.textAlignment, value: .center)
        .with(\.font, value: .systemFont(ofSize: 12, weight: .regular))
        .with(\.numberOfLines, value: 0)
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupPopupView()
    }

    private func setupPopupView() {
        view.addSubview(popupView)

        popupView.addSubview(descriptionLabel)
        popupView.addSubview(loadingIndicator)
        
        popupView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(300)
            make.height.equalTo(100)
        }
        
        loadingIndicator.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview().offset(-40)
        }

    }


}
