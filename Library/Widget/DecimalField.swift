//
//  DecimalField.swift
//  Novar
//
//  Created by Everton Luiz Pascke on 19/12/16.
//  Copyright © 2016 Everton Luiz Pascke. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialTextFields

class DecimalField: MDCTextField, UITextFieldDelegate {

    var current = ""
    
    var value: Double? {
        guard let text = self.text else {
            return nil
        }
        return NumberUtils.parse(text)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        keyboardType = .numberPad
        delegate = self
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch string {
        case "0","1","2","3","4","5","6","7","8","9":
            current += string
            format()
        default:
            if string.characters.count == 0 && current.characters.count != 0 {
                current = String(current.characters.dropLast())
                format()
            }
        }
        return false
    }
    
    private func format() {
        if let number = Double(current) {
            self.text = NumberUtils.format(number / 100)
        } else {
            self.text = nil
        }
    }
}
