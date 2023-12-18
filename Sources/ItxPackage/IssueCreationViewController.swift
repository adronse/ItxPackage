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
    
    
    private func configureUI()
    {

        view.addSubview(IssueCreationTitle)
        
        
        IssueCreationTitle.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
