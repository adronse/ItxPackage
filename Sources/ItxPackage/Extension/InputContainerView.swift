//
//  File.swift
//  
//
//  Created by Adrien Ronse on 18/12/2023.
//


import Foundation
import UIKit

public enum InputContainerDirection {
    case row
    case column
}

public final class InputContainerView<Title: UIView, Input: UIView>: UIControl {
    public let title: Title
    public let input: Input
    
    
    public override var isFirstResponder: Bool {
        return input.isFirstResponder
    }
    
    public init(title: Title, input: Input, direction: InputContainerDirection) {
        self.title = title
        self.input = input
        super.init(frame: .zero)
        [title, input].forEach(addSubview)
        
        backgroundColor = .white
        layer.cornerRadius = 8
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = .zero
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 3
        
        addGestureRecognizer(UITapGestureRecognizer().onChange(do: { [weak self] _ in
            self?.input.becomeFirstResponder()
        }))
        
        switch direction {
        case .column:
            title.snp.makeConstraints { make in
                make.top.equalTo(snp.top).offset(8)
                make.leading.equalTo(snp.leading).offset(8)
                make.trailing.equalTo(snp.trailing).offset(-8)
            }
            
            input.snp.makeConstraints { make in
                make.top.equalTo(title.snp.bottom).offset(8 / 2)
                make.leading.trailing.equalTo(title)
                make.bottom.equalTo(snp.bottom).offset(-8)
            }
        case .row:
            title.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.leading.equalToSuperview().offset(8)
            }
            
            input.snp.makeConstraints { make in
                make.top.equalTo(snp.top).offset(8 * 1.5)
                make.bottom.equalTo(snp.bottom).offset(-8 * 1.5)
                make.trailing.equalTo(snp.trailing).offset(-8)
                make.leading.greaterThanOrEqualTo(title.snp.trailing).offset(10)
            }
        }
        
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public static func make<Input: UIView>(title: String, input: Input, direction: InputContainerDirection = .column) -> InputContainerView<UILabel, Input> {
        let titleView = UILabel()
            .with(\.text, value: title)
 
        return InputContainerView<UILabel, Input>(title: titleView, input: input, direction: direction)
    }
}


