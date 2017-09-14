//
//  ConsultaViewController.swift
//  Cliente
//
//  Created by Everton Luiz Pascke on 10/09/17.
//  Copyright © 2017 Wasys. All rights reserved.
//

import UIKit
import MaterialComponents

class ConsultaViewController: DrawerViewController {

    @IBOutlet weak var modoSwitch: UISwitch!
    @IBOutlet weak var cpfCnpjTextField: MDCTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func onModoChange(_ sender: UISwitch) {
        var key = "Label.CPF"
        if sender.isOn {
            key = "Label.CNPJ"
        }
        cpfCnpjTextField.placeholder = TextUtils.localized(forKey: key)
    }
}
