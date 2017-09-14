//
//  ReadonlyTableViewCell.swift
//  Cliente
//
//  Created by Everton Luiz Pascke on 10/09/17.
//  Copyright © 2017 Wasys. All rights reserved.
//

import UIKit

class ReadonlyTableViewCell: UITableViewCell {

    @IBOutlet weak var textField: UITextField!
    
    func prepare(_ campo: CampoModel) {
        textField.text = nil
        textField.placeholder = TextUtils.capitalize(campo.nome)
        if TextUtils.isNotBlank(campo.valor) {
            textField.text = campo.valor
        }
    }
}
