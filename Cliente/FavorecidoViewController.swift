//
//  FavorecidoViewController.swift
//  Cliente
//
//  Created by Everton Luiz Pascke on 14/09/17.
//  Copyright © 2017 Wasys. All rights reserved.
//

import UIKit
import VMaskTextField
import MaterialComponents.MaterialButtons
import MaterialComponents.MaterialTextFields

class FavorecidoViewController: CheqfastViewController {

    @IBOutlet weak var cpfCnpjHelpLabel: UILabel!
    @IBOutlet weak var bancoPickerField: PickerField!
    @IBOutlet weak var agenciaTextField: MDCTextField!
    @IBOutlet weak var contaTextField: MDCTextField!
    @IBOutlet weak var titularTextField: MDCTextField!
    @IBOutlet weak var cpfCnpjTextField: MDCTextField!
    @IBOutlet weak var valorDecimalField: DecimalField!
    
    @IBOutlet weak var cpfCnpjSwitch: UISwitch!
    @IBOutlet weak var salvarButton: MDCRaisedButton!
    
    var favorecido: FavorecidoModel?
    var transferencia: TransferenciaModel?
    
    fileprivate var mask: String {
        if cpfCnpjSwitch.isOn {
            return "##.###.###/####-##"
        }
        return "###.###.###-##"
    }
    
    fileprivate var isValid: Bool {
        return bancoPickerField.value != nil
            && TextUtils.isNotBlank(agenciaTextField.text)
            && TextUtils.isNotBlank(contaTextField.text)
            && TextUtils.isNotBlank(titularTextField.text)
            && TextUtils.isNotBlank(cpfCnpjTextField.text)
            && valorDecimalField.value != nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepare()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let favorecido = self.favorecido {
            favorecido.banco = bancoPickerField.value?.value
            favorecido.agencia = agenciaTextField.text
            favorecido.conta = contaTextField.text
            favorecido.nomeTitular = titularTextField.text
            favorecido.cpfCnpj = cpfCnpjTextField.text
            favorecido.valor = valorDecimalField.value
        }
    }
    
    @IBAction func editingDidEnd() {
        salvarButton.isEnabled = isValid
    }
    
    @IBAction func editingDidBegin() {
        salvarButton.isEnabled = true
    }
    
    @IBAction func onCpfCpnjChange() {
        cpfCnpjTextField.text = nil
        let key: String
        if cpfCnpjSwitch.isOn {
            key = "Label.TrocarCPF"
        } else {
            key = "Label.TrocarCNPJ"
        }
        let message = TextUtils.localized(forKey: key)
        ViewUtils.text(message, for: cpfCnpjHelpLabel)
    }
}

extension FavorecidoViewController {
    
    fileprivate func prepare() {
        prepareButton()
        cpfCnpjTextField.delegate = self
        if favorecido == nil {
            favorecido = FavorecidoModel()
        }
        if let transferencia = self.transferencia {
            bancoPickerField.entries(array: transferencia.bancos)
        }
        if let banco = favorecido?.banco {
            bancoPickerField.value = Option(value: banco, label: banco)
        }
        if let cpfCnpj = favorecido?.cpfCnpj {
            if cpfCnpj.range(of: "\\d{2}.\\d{3}.\\d{3}/\\d{4}-\\d{2}", options: .regularExpression) != nil {
                cpfCnpjSwitch.isOn = true
            }
        }
        ViewUtils.text(favorecido?.agencia, for: agenciaTextField)
        ViewUtils.text(favorecido?.conta, for: contaTextField)
        ViewUtils.text(favorecido?.nomeTitular, for: titularTextField)
        ViewUtils.text(favorecido?.cpfCnpj, for: cpfCnpjTextField)
        ViewUtils.text(favorecido?.valor, for: valorDecimalField)
        salvarButton.isEnabled = isValid
    }
    
    fileprivate func prepareButton() {
        salvarButton.backgroundColor = Color.primary
        salvarButton.customTitleColor = UIColor.white
        salvarButton.isEnabled = isValid
    }
}

extension FavorecidoViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField === cpfCnpjTextField {
            return VMaskEditor.shouldChangeCharacters(in: range, replacementString: string, textField: textField, mask: mask)
        }
        return true
    }
}
