//
//  RecoveryViewController.swift
//  Cliente
//
//  Created by Everton Luiz Pascke on 07/09/17.
//  Copyright © 2017 Wasys. All rights reserved.
//

import UIKit
import MaterialComponents

class RecoveryViewController: CheqfastViewController {

    @IBOutlet weak var emailTextField: MDCTextField!
    @IBOutlet weak var recuperarButton: MDCRaisedButton!
    
    fileprivate var isValid: Bool {
        return TextUtils.isNotBlank(emailTextField.text)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepare()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        emailTextField.becomeFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    @IBAction func editingDidEnd() {
        recuperarButton.isEnabled = isValid
    }
    
    @IBAction func editingDidBegin() {
        recuperarButton.isEnabled = true
    }
    
    @IBAction func onRecuperarTapped() {
        recuperar()
    }
    
}

extension RecoveryViewController {
    
    fileprivate func prepare() {
        recuperarButton.backgroundColor = Color.primary
        recuperarButton.customTitleColor = UIColor.white
        recuperarButton.isEnabled = isValid
    }
    
    fileprivate func recuperar() {
        if isValid {
            let email = emailTextField.text!
            let model = RecoveryModel(email: email)
            startRecuperarAsync(model)
        }
    }
}
// MARK: Async did completed method
extension RecoveryViewController {
    
    fileprivate func recuperarDidComplete(_ model: ResultModel) {
        if model.isSuccess {
            emailTextField.text = nil
            recuperarButton.isEnabled = false
            let message = TextUtils.localized(forKey: "Message.RecuperacaoSenhaSucesso")
            showMessage(content: message)
        }
    }
}

// MARK: Async method
extension RecoveryViewController {
    
    fileprivate func startRecuperarAsync(_ model: RecoveryModel) {
        showActivityIndicator()
        let observable = DispositivoService.Async.recuperar(model)
        prepare(for: observable)
            .subscribe(
                onNext: { model in
                    self.recuperarDidComplete(model)
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
