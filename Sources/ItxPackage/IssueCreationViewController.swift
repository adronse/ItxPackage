//
//  File.swift
//  
//
//  Created by Adrien Ronse on 18/12/2023.
//

import Foundation
import UIKit

public class IssueCreationViewController : UIViewController
{
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Report a bug"
        self.view.backgroundColor = UIColor.from(hex: "#292A2F")
        configureUI()
    }
    
    
    private lazy var IssueCreationTitle = UILabel()
        .with(\.text, value: "cool mec")
        .with(\.textColor, value: UIColor.from(hex: "#11590D"))
    
    
    
    private lazy var emailFieldTitle = UILabel()
        .with(\.text, value: "Email")
        .with(\.textColor, value: UIColor.from(hex: "#454547"))
    
    private lazy var emailField = UITextField()
        .with(\.placeholder, value: "john.doe@iterationx.io")
        .with(\.textColor, value: .white)

    
    
    private func configureUI()
    {

        view.addSubview(emailFieldTitle)
        view.addSubview(emailField)
        
        emailFieldTitle.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(60)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(40)
        }
        
        emailFieldTitle.snp.makeConstraints { make in
            make.top.equalTo(emailFieldTitle.snp.bottom).offset(5)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(40)
        }
            
    }
}
