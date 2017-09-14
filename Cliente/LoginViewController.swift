//
//  LoginViewController.swift
//  Cliente
//
//  Created by Everton Luiz Pascke on 07/09/17.
//  Copyright © 2017 Wasys. All rights reserved.
//

import UIKit
import MaterialComponents

class LoginViewController: CheqfastViewController {

    @IBOutlet weak var emailTextField: MDCTextField!
    @IBOutlet weak var senhaTextField: MDCTextField!
    
    @IBOutlet weak var entrarButton: MDCRaisedButton!
    
    fileprivate var isValid: Bool {
        return TextUtils.isNotBlank(emailTextField.text)
            && TextUtils.isNotBlank(senhaTextField.text)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepare()
        emailTextField.becomeFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    @IBAction func editingDidEnd() {
        entrarButton.isEnabled = isValid
    }
    
    @IBAction func editingDidBegin() {
        entrarButton.isEnabled = true
    }

    @IBAction func onEntrarTapped() {
        entrar()
    }
}

// MARK: Custom
extension LoginViewController {
    
    fileprivate func prepare() {
        entrarButton.backgroundColor = Color.primary
        entrarButton.customTitleColor = UIColor.white
        entrarButton.isEnabled = isValid
    }
    
    fileprivate func entrar() {
        if isValid {
            let email = emailTextField.text!
            let senha = senhaTextField.text!
            let model = CredencialModel(login: email, senha: senha)
            autenticarAsync(model)
        }
    }
}

// MARK: Async did completed method
extension LoginViewController {
    
    fileprivate func autenticarDidComplete(_ dispositivo: Dispositivo) {
        Dispositivo.current = dispositivo
        let controller = UIStoryboard.viewController("Menu", identifier: "Scene.Reveal")
        self.present(controller, animated: true, completion: nil)
    }
}

// MARK: Async method
extension LoginViewController {
    
    fileprivate func autenticarAsync(_ model: CredencialModel) {
        showActivityIndicator()
        let observable = DispositivoService.Async.autenticar(model)
        prepare(for: observable)
            .subscribe(
                onNext: { dispositivo in
                    self.autenticarDidComplete(dispositivo)
                },
                onError: { error in
                    self.hideActivityIndicator()
                    self.handle(error)
                },
                onCompleted: {
                    self.hideActivityIndicator()
                }
            ).addDisposableTo(disposableBag)
    }
}
