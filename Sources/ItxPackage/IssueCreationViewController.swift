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
    
    
    private lazy var emailField = InputContainerView.make(
        title: "Email",
        input: UITextField()
            .with(\.placeholder, value: "john.doe@iterationx.io")
            .with(\.autocorrectionType, value: UITextAutocorrectionType.no)
            .with(\.autocapitalizationType, value: UITextAutocapitalizationType.none)
            .with(\.keyboardType, value: UIKeyboardType.emailAddress)
            .with(\.textContentType, value: UITextContentType.emailAddress)
            .with(\.backgroundColor, value: .clear)
        
    )
    
    
    private func configureUI()
    {

        view.addSubview(emailField)
        
        emailField.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(60)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(40)
        }
            
    }
}
