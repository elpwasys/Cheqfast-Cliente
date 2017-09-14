//
//  FinalizacaoViewController.swift
//  Cliente
//
//  Created by Everton Luiz Pascke on 12/09/17.
//  Copyright © 2017 Wasys. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialPalettes

protocol FinalizacaoViewControllerDelegate {
    
    func onFecharTapped(_ controller: FinalizacaoViewController)
    func onConfirmarTapped(_ controller: FinalizacaoViewController, grupos: [CampoGrupoModel])
}

class FinalizacaoViewController: CheqfastViewController {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var fecharButton: UIButton!
    @IBOutlet weak var confirmarButton: UIButton!
    
    var grupos = [CampoGrupoModel]()
    var delegate: FinalizacaoViewControllerDelegate?
    
    fileprivate var isValid: Bool {
        var valid = true
        for (section, grupo) in grupos.enumerated() {
            if let campos = grupo.campos {
                for (row, _) in campos.enumerated() {
                    let indexPath = IndexPath(row: row, section: section)
                    if let cell = tableView.cellForRow(at: indexPath) as? CampoTableViewCell {
                        if !cell.isValid {
                            valid = false
                        }
                    }
                }
            }
        }
        return valid
    }
    
    fileprivate var values: [CampoGrupoModel] {
        var values = [CampoGrupoModel]()
        for (section, grupo) in self.grupos.enumerated() {
            if let campos = grupo.campos {
                let value = CampoGrupoModel()
                value.id = grupo.id
                value.nome = grupo.nome
                for (row, campo) in campos.enumerated() {
                    let indexPath = IndexPath(row: row, section: section)
                    if let cell = tableView.cellForRow(at: indexPath) as? CampoTableViewCell {
                        let model = CampoModel()
                        model.id = campo.id
                        model.tipo = campo.tipo
                        model.nome = campo.nome
                        model.isObrigatorio = campo.isObrigatorio
                        model.dica = campo.dica
                        model.opcoes = campo.opcoes
                        model.tamanhoMinimo = campo.tamanhoMinimo
                        model.tamanhoMaximo = campo.tamanhoMaximo
                        model.valor = cell.value
                        value.add(model)
                    }
                }
                values.append(value)
            }
        }
        return values
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        preapare()
    }
    
    @IBAction func onFecharTapped() {
        if let delegate = self.delegate {
            delegate.onFecharTapped(self)
        }
    }
    
    @IBAction func onConfirmarTapped() {
        if isValid {
            if let delegate = self.delegate {
                delegate.onConfirmarTapped(self, grupos: values)
            }
        }
    }
}

// MARK: Custom
extension FinalizacaoViewController {
    
    fileprivate func preapare() {
        prepareTopView()
        prepareTableView()
        prepareBottomView()
    }
    
    fileprivate func prepareTopView() {
        ShadowUtils.applyBottom(topView)
    }
    
    fileprivate func prepareTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        tableView.register(UINib(nibName: TextFieldTableViewCell.nibName, bundle: nil), forCellReuseIdentifier: TextFieldTableViewCell.reusableCellIdentifier)
        tableView.register(UINib(nibName: DecimalFieldTableViewCell.nibName, bundle: nil), forCellReuseIdentifier: DecimalFieldTableViewCell.reusableCellIdentifier)
        tableView.register(UINib(nibName: TableHeaderView.nibName, bundle: nil), forHeaderFooterViewReuseIdentifier: TableHeaderView.reusableCellIdentifier)
    }
    
    fileprivate func prepareBottomView() {
        bottomView.borderTopWith(color: MDCPalette.grey.tint300, width: 1)
    }
    
    fileprivate func get(by indexPath: IndexPath) -> CampoModel {
        return grupos[indexPath.section].campos![indexPath.row]
    }
}

// MARK: UITableViewDelegate
extension FinalizacaoViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let grupo = grupos[section]
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: TableHeaderView.reusableCellIdentifier) as! TableHeaderView
        header.prepare(grupo.nome)
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let campo = get(by: indexPath)
        if campo.tipo == .moeda {
            return DecimalFieldTableViewCell.height
        }
        return TextFieldTableViewCell.height
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return TableHeaderView.height
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let header = view as? TableHeaderView {
            header.contentView.backgroundColor = UIColor.white
        }
    }
}

// MARK: UITableViewDataSource
extension FinalizacaoViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.grupos.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return grupos[section].campos?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let campo = get(by: indexPath)
        var identifier = TextFieldTableViewCell.reusableCellIdentifier
        if campo.tipo == .moeda {
            identifier = DecimalFieldTableViewCell.reusableCellIdentifier
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! CampoTableViewCell
        cell.prepare(campo)
        return cell
    }
}
