//
//  File.swift
//
//
//  Created by Adrien Ronse on 18/12/2023.
//

import Foundation
import UIKit

public class IssueCreationViewController: UIViewController {

    public override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Report a bug"
        self.view.backgroundColor = UIColor.from(hex: "#292A2F")
        configureUI()
    }
    
    private lazy var emailFieldTitle: UILabel = {
        let label = UILabel()
        label.text = "Email"
        label.textColor = UIColor.from(hex: "#454547")
        return label
    }()
    
    private lazy var emailField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "john.doe@iterationx.io"
        textField.textColor = .white
        return textField
    }()
    
    private func configureUI() {
        view.addSubview(emailFieldTitle)
        view.addSubview(emailField)
        
        emailFieldTitle.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(60)
            make.leading.trailing.equalToSuperview().inset(5)
            make.height.equalTo(40)
        }
        
        emailField.snp.makeConstraints { make in
            make.top.equalTo(emailFieldTitle.snp.bottom).offset(5)
            make.leading.trailing.equalToSuperview().inset(5)
            make.height.equalTo(40)
        }
    }
}
