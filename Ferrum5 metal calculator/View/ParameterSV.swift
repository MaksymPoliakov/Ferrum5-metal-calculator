//
//  ParametersSV.swift
//  Ferrum5 metal calculator
//
//  Created by Maksym Poliakov on 16.10.16.
//  Copyright © 2016 Maksym Poliakov. All rights reserved.
//

import UIKit

class ParameterSV: UIStackView, UITextFieldDelegate {
    
    var title: UILabel!
    var field: UITextField!
    var parametersStackDelegate: ParametersStackDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        title = UILabel()
        field = UITextField()
        addArrangedSubview(title)
        addArrangedSubview(field)
        
        setup()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        title.alpha = 0.0
        title.textAlignment = .center
        title.font = UIFont.preferredFont(forTextStyle: .subheadline)
        field.textAlignment = .center
        field.font = UIFont.preferredFont(forTextStyle: .subheadline)
        field.keyboardType = .decimalPad

        alignment = .fill
        distribution = .fillEqually
        axis = .vertical
        spacing = 2
        
        field.delegate = self
    }
    
    func setBorder(withColor color: UIColor) {
        let border = CALayer()
        let borderHeight: CGFloat = 1.0
        border.borderColor = color.cgColor
        border.frame = CGRect(x: field.frame.width * 0.15, y: field.frame.height - 2, width: field.frame.width * 0.7, height: borderHeight)
        border.borderWidth = borderHeight
        field.layer.addSublayer(border)
        field.layer.masksToBounds = true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let newCharacters = CharacterSet(charactersIn: string)
        let isNumber = CharacterSet.decimalDigits.isSuperset(of: newCharacters as CharacterSet)
        
        if isNumber {
            return true
        } else {
            if string == "." {
                let dotsCount = field.text!.components(separatedBy: ".").count - 1
                if dotsCount == 0 {
                    return true
                } else {
                    return false
                }
            } else {
                return false
            }
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if title.alpha == 0 {
            UIView.animate(withDuration: 0.3, animations: {
                self.title.alpha = 1.0
            })
        }
        field.placeholder = ""
        field.text = ""
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        parametersStackDelegate?.appendValueToStack(textField.text, key: title.text!)
    }
}
