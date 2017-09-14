//
//  MeusDadosViewController.swift
//  Cliente
//
//  Created by Everton Luiz Pascke on 10/09/17.
//  Copyright © 2017 Wasys. All rights reserved.
//

import UIKit

class MeusDadosViewController: DrawerViewController {

    @IBOutlet weak var tableView: UITableView!
    
    fileprivate var grupos = [CampoGrupoModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepare()
        obterAsync()
    }
}

extension MeusDadosViewController {
    
    fileprivate func prepare() {
        prepareTableView()
    }
    
    fileprivate func prepareTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
        tableView.separatorStyle = .singleLine
        tableView.tableFooterView = UIView()
        tableView.register(UINib(nibName: TableHeaderView.nibName, bundle: nil), forHeaderFooterViewReuseIdentifier: TableHeaderView.reusableCellIdentifier)
    }
    
    fileprivate func popular(_ model: ProcessoModel) {
        if let gruposCampos = model.gruposCampos {
            grupos = gruposCampos
            tableView.reloadData()
        }
    }
}

// MARK: UITableViewDelegate
extension MeusDadosViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let grupo = grupos[section]
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: TableHeaderView.reusableCellIdentifier) as! TableHeaderView
        header.prepare(grupo.nome)
        return header
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
extension MeusDadosViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.grupos.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return grupos[section].campos?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReadonlyTableViewCell", for: indexPath) as! ReadonlyTableViewCell
        let campo = grupos[indexPath.section].campos![indexPath.row]
        cell.prepare(campo)
        return cell
    }
}

// MARK: Async did completed method
extension MeusDadosViewController {
    
    fileprivate func obterDidComplete(_ model: ProcessoModel) {
        popular(model)
    }
}

// MARK: Async method
extension MeusDadosViewController {
    
    fileprivate func obterAsync() {
        showActivityIndicator()
        let observable = ClienteService.Async.obter()
        prepare(for: observable)
            .subscribe(
                onNext: { model in
                    self.obterDidComplete(model)
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
