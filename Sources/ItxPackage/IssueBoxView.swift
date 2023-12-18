//
//  File.swift
//
//
//  Created by Adrien Ronse on 18/12/2023.
//

import Foundation
import UIKit

public class IssueBoxView: UIView {
    
    public init() {
        super.init(frame: .zero)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc func didTapReportBugButton()
    {
        let controller = IssueCreationViewController()
        
        
        let navigationController = UINavigationController()
        navigationController.pushViewController(controller, animated: true)
        self.window?.rootViewController?.present(navigationController, animated: true)
        
    }
    
    
    private func setupViews()
    {
        
        self.backgroundColor = UIColor.from(hex: "#323232")
        
        lazy var titleLabel = UILabel()
            .with(\.text, value: "Need help ?")
            .with(\.textColor, value: .white)
        
        lazy var separator = UIView.separator(color: UIColor.from(hex: "#B5B8BE"))
        
        
        let reportBugButton = UIButton(type: .system)
            reportBugButton.addTarget(self, action: #selector(didTapReportBugButton), for: .touchUpInside)
        
        let reportBugTitleLabel = UILabel()
            .with(\.text, value: "Report a bug")
            .with(\.textColor, value: UIColor.white)
        
        let reportBugDescriptionLabel = UILabel()
            .with(\.text, value: "Something in the app is broken or doesn't work as expected")
            .with(\.textColor, value: UIColor.gray)
            .with(\.numberOfLines, value: 0) // Allow multiline text
        
        let separator1 = UIView.separator(color: UIColor.gray)
        
        // Create buttons for the second row ("Suggest an improvement")
        let suggestImprovementButton = UIButton(type: .system)
        // suggestImprovementButton.addTarget(self, action: #selector(suggestImprovementButtonTapped), for: .touchUpInside)
        
        let suggestImprovementTitle = UILabel()
            .with(\.text, value: "Suggest an improvement")
            .with(\.textColor, value: UIColor.white)
        
        let suggestImprovementDescription = UILabel()
            .with(\.text, value: "New ideas or desired enhancements for this app")
            .with(\.textColor, value: UIColor.gray)
            .with(\.numberOfLines, value: 0) // Allow multiline text
        
        let cancelButton = UIButton(type: .system)
        
        
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.setTitleColor(UIColor.white, for: .normal)
        
        
        self.addSubview(titleLabel)
        self.addSubview(separator)
        
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.snp.leadingMargin).offset(10)
            make.top.equalTo(self.snp.topMargin).offset(10)
        }
        
        separator.snp.makeConstraints { make in
            make.centerX.equalTo(self)
            make.top.equalTo(titleLabel.snp.bottomMargin).offset(10) // Adjust the offset as needed
        }
        
        
        self.addSubview(reportBugButton)
        reportBugButton.addSubview(reportBugTitleLabel)
        reportBugButton.addSubview(reportBugDescriptionLabel)
        self.addSubview(separator1)
        
        reportBugButton.snp.makeConstraints { make in
            make.top.equalTo(separator.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(separator1.snp.bottom)
        }
        
        reportBugTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(reportBugButton).offset(10)
            make.leading.equalTo(reportBugButton).offset(10)
        }
        
        reportBugDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(reportBugTitleLabel.snp.bottom).offset(5)
            make.leading.trailing.equalTo(reportBugButton).inset(10)
        }
        
        separator1.snp.makeConstraints { make in
            make.top.equalTo(reportBugDescriptionLabel.snp.bottom).offset(20)
            make.leading.trailing.equalTo(reportBugButton)
            make.height.equalTo(1)
        }
        
        self.addSubview(suggestImprovementButton)
        suggestImprovementButton.addSubview(suggestImprovementTitle)
        suggestImprovementButton.addSubview(suggestImprovementDescription)
        
        suggestImprovementButton.snp.makeConstraints { make in
            make.top.equalTo(separator1.snp.bottom)
            make.leading.trailing.equalToSuperview()
        }
        
        suggestImprovementTitle.snp.makeConstraints { make in
            make.top.equalTo(suggestImprovementButton).offset(10)
            make.leading.equalTo(suggestImprovementButton).offset(10)
        }
        
        suggestImprovementDescription.snp.makeConstraints { make in
            make.top.equalTo(suggestImprovementTitle.snp.bottom).offset(5)
            make.leading.trailing.equalTo(suggestImprovementButton).inset(10)
        }
        
        self.addSubview(cancelButton)
        cancelButton.snp.makeConstraints { make in
            make.top.equalTo(suggestImprovementDescription.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(20)
        }
        
    }
}
