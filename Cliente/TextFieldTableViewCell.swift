//
//  TextFieldTableViewCell.swift
//  Cliente
//
//  Created by Everton Luiz Pascke on 12/09/17.
//  Copyright © 2017 Wasys. All rights reserved.
//

import UIKit

class TextFieldTableViewCell: CampoTableViewCell {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var detail: UILabel!
    
    @IBOutlet weak var divider: UIView!
    @IBOutlet weak var textField: UITextField!
    
    fileprivate var campo: CampoModel?
    
    override var value: String? {
        return textField.text
    }
    
    override var isEnabled: Bool {
        didSet {
            if textField != nil {
                textField.isEnabled = isEnabled
            }
        }
    }
    
    override var isValid: Bool {
        if let campo = self.campo, let name = TextUtils.capitalize(campo.nome) {
            clear()
            let value = textField.text
            if TextUtils.isBlank(value) {
                let messageText = TextUtils.localized(forKey: "Label.CampoObrigatorio")
                detail.text = "\(name) \(messageText)"
            }
            let length = value?.characters.count ?? 0
            if let minLength = campo.tamanhoMinimo, length < minLength {
                let messageText = TextUtils.localized(forKey: "Message.CampoInvalidoMinLength")
                detail.text = "\(name) \(messageText) \(minLength)"
            }
            if let maxLength = campo.tamanhoMaximo, length > maxLength {
                let messageText = TextUtils.localized(forKey: "Message.CampoInvalidoMaxLength")
                detail.text = "\(name) \(messageText) \(maxLength)"
            }
            if TextUtils.isNotBlank(detail.text) {
                label.textColor = errorColor
                detail.textColor = errorColor
                divider.backgroundColor = errorColor
                return false
            }
        } else {
            return false
        }
        return true
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepare(_ model: CampoModel) {
        self.clear()
        self.campo = model
        let nome = TextUtils.capitalize(model.nome)
        textField.isEnabled = isEnabled
        //textField.placeholder = nome
        ViewUtils.text(nome, for: label)
        ViewUtils.text(model.valor, for: textField)
        if model.tipo == .inteiro {
            textField.keyboardType = .numberPad
        } else if model.tipo == .email {
            textField.keyboardType = .emailAddress
        } else {
            textField.keyboardType = .default
        }
    }
}


extension TextFieldTableViewCell {
    
    static var height: CGFloat {
        return 87
    }
    
    static var nibName: String {
        return "\(TextFieldTableViewCell.self)"
    }
    
    static var reusableCellIdentifier: String {
        return "\(TextFieldTableViewCell.self)"
    }
    
    fileprivate func clear() {
        detail.text = nil
        label.textColor = normalColor
        detail.textColor = UIColor.clear
        divider.backgroundColor = normalColor
    }
}
