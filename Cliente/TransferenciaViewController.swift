//
//  TransferenciaViewController.swift
//  Cliente
//
//  Created by Everton Luiz Pascke on 14/09/17.
//  Copyright © 2017 Wasys. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialButtons

class TransferenciaViewController: CheqfastViewController {

    @IBOutlet weak var bancoLabel: UILabel!
    @IBOutlet weak var nomeLabel: UILabel!
    @IBOutlet weak var valorLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var cpfCnpjLabel: UILabel!
    @IBOutlet weak var agenciaContaLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var adicionarButton: UIBarButtonItem!
    @IBOutlet weak var confirmarButton: MDCRaisedButton!
    
    var id: Int?
    
    fileprivate var current: FavorecidoModel?
    fileprivate var transferencia: TransferenciaModel?
    
    fileprivate var favorecidos = [FavorecidoModel]()
    
    fileprivate var isValid: Bool {
        if let transferencia = self.transferencia {
            var valid = true
            var valor = transferencia.valor!
            for favorecido in favorecidos {
                valor -= favorecido.valor!
            }
            if valor < 0 {
                valid = false
                showMessage(content: TextUtils.localized(forKey: "Message.TransferenciaInvalida"), theme: .info)
            } else if valor > 0 {
                if (valor - transferencia.custo!) <= 0 {
                    valid = false
                    showMessage(content: TextUtils.localized(forKey: "Message.TransferenciaInvalida"), theme: .info)
                }
            }
            return valid
        }
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepare()
        iniciar()
    }
    
    @IBAction func onConfirmarTapped() {
        if isValid {
            DispatchQueue.main.async {
                let alert = UIAlertController(
                    title: TextUtils.localized(forKey: "Label.Aprovar"),
                    message: TextUtils.localized(forKey: "Message.AprovarProcesso"),
                    preferredStyle: UIAlertControllerStyle.actionSheet
                )
                alert.addAction(UIAlertAction(
                    title: TextUtils.localized(forKey: "Label.Sim"),
                    style: UIAlertActionStyle.default,
                    handler: { (action: UIAlertAction!) in
                        self.aprovar()
                }
                ))
                alert.addAction(UIAlertAction(
                    title: TextUtils.localized(forKey: "Label.Nao"),
                    style: UIAlertActionStyle.cancel,
                    handler: nil
                ))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func unwindToTransferencia(segue: UIStoryboardSegue) {
        if let controller = segue.source as? FavorecidoViewController {
            self.current = nil
            let favorecido = controller.favorecido!
            let contains = favorecidos.contains { return $0 === favorecido }
            if !contains {
                favorecidos.append(favorecido)
            }
            calcular()
            tableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "Segue.Favorecido" {
                let controller = segue.destination as! FavorecidoViewController
                controller.transferencia = self.transferencia
                if sender is UIBarButtonItem {
                    current = nil
                }
                controller.favorecido = current
            }
        }
    }
}

// MARK: Custom
extension TransferenciaViewController {
    
    fileprivate func prepare() {
        prepareTableView()
    }
    
    fileprivate func prepareTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = true
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.tableFooterView = UIView()
        tableView.register(UINib(nibName: FavorecidoTableViewCell.nibName, bundle: nil), forCellReuseIdentifier: FavorecidoTableViewCell.reusableCellIdentifier)
    }
    
    fileprivate func iniciar() {
        if let id = self.id {
            startAsyncObter(id)
        }
    }
    
    fileprivate func popular() {
        if let transferencia = self.transferencia {
            if let custo = transferencia.custo {
                let format = TextUtils.localized(forKey: "Message.CustoTransferencia")
                let value = String(format: format, NumberUtils.format(custo)!)
                ViewUtils.text(value, for: messageLabel)
            }
            if let principal = transferencia.principal {
                ViewUtils.text(principal.nomeTitular, for: nomeLabel)
                ViewUtils.text(principal.cpfCnpj, for: cpfCnpjLabel)
                ViewUtils.text(principal.banco, for: bancoLabel)
                ViewUtils.text("\(principal.agencia ?? "")/\(principal.conta ?? "")", for: agenciaContaLabel)
                calcular()
            }
        }
    }
    
    fileprivate func calcular() {
        if let transferencia = self.transferencia {
            var custo: Double = 0
            var valor = transferencia.valor!
            for favorecido in favorecidos {
                custo += transferencia.custo!
                valor -= favorecido.valor!
                favorecido.custo = transferencia.custo
                favorecido.valorTransferencia = favorecido.valor! - favorecido.custo!
            }
            let principal = transferencia.principal!
            principal.valor = valor;
            if valor > 0 {
                custo += transferencia.custo!
                principal.valorTransferencia = valor - transferencia.custo!
            } else {
                principal.valorTransferencia = valor
            }
            ViewUtils.text((transferencia.valor! - custo), for: totalLabel)
            ViewUtils.text(principal.valorTransferencia, for: valorLabel)
        }
    }
    
    fileprivate func aprovar() {
        
    }
}

// MARK: Async completed methods
extension TransferenciaViewController {
    
    fileprivate func obterDidCompleted(_ model: TransferenciaModel) {
        transferencia = model
        popular()
    }
}

// MARK: Async methods
extension TransferenciaViewController {
    
    fileprivate func startAsyncObter(_ id: Int) {
        showActivityIndicator()
        let observable = TransferenciaService.Async.obter(id)
        prepare(for: observable)
            .subscribe(
                onNext: { model in
                    self.obterDidCompleted(model)
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

// MARK: UITableViewDelegate
extension TransferenciaViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return FavorecidoTableViewCell.height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        current = favorecidos[indexPath.row]
        let cell = tableView.cellForRow(at: indexPath)
        performSegue(withIdentifier: "Segue.Favorecido", sender: cell)
    }
}

// MARK: UITableViewDataSource
extension TransferenciaViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorecidos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FavorecidoTableViewCell.reusableCellIdentifier, for: indexPath) as! FavorecidoTableViewCell
        let favorecido = favorecidos[indexPath.row]
        cell.popular(favorecido)
        return cell
    }
}
