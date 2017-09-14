//
//  ProcessoPesquisaViewController.swift
//  Cliente
//
//  Created by Everton Luiz Pascke on 10/09/17.
//  Copyright © 2017 Wasys. All rights reserved.
//

import UIKit

class ProcessoPesquisaViewController: DrawerViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var pagingToolbar: UIToolbar!
    @IBOutlet weak var nextButton: UIBarButtonItem!
    @IBOutlet weak var statusButton: UIBarButtonItem!
    @IBOutlet weak var previousButton: UIBarButtonItem!
    
    var status: ProcessoModel.Status?
    
    fileprivate var rows = [ProcessoModel]()
    fileprivate var statusLabel = UILabel()
    
    fileprivate var pesquisaModel: PesquisaModel!
    fileprivate var processoPagingModel: ProcessoPagingModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepare()
        restart()
    }

    @IBAction func onSearchTapped(_ sender: UIBarButtonItem) {
        openFiltroDialog()
    }
    
    @IBAction func onRefreshTapped(_ sender: UIBarButtonItem) {
        filtrarAsync()
    }
    
    @IBAction func onNextTapped(_ sender: UIBarButtonItem) {
        pesquisaModel.page = pesquisaModel.page + 1
        filtrarAsync()
    }
    
    @IBAction func onPreviousTapped(_ sender: UIBarButtonItem) {
        pesquisaModel.page = pesquisaModel.page - 1
        filtrarAsync()
    }
}

extension ProcessoPesquisaViewController {
    
    fileprivate func prepare() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        preparePagingToolbar()
    }
    
    fileprivate func restart() {
        pesquisaModel = PesquisaModel()
        pesquisaModel.page = 0
        if let status = self.status {
            pesquisaModel.filtro = FiltroModel()
            pesquisaModel.filtro?.status = status
        }
        filtrarAsync()
    }
    
    fileprivate func preparePagingToolbar() {
        ShadowUtils.applyTop(pagingToolbar)
        statusLabel.sizeToFit()
        statusLabel.font = statusLabel.font.withSize(14.0)
        statusLabel.textAlignment = .center
        statusLabel.textColor = UIColor.white
        statusButton.customView = statusLabel
    }

    fileprivate func atualizar(_ model: ProcessoPagingModel) {
        
        self.processoPagingModel = model
        
        if model.hasNext() {
            nextButton.isEnabled = true
        } else {
            nextButton.isEnabled = false
        }
        if model.hasPrevious() {
            previousButton.isEnabled = true
        } else {
            previousButton.isEnabled = false
        }
        
        if model.qtde > 0 {
            statusLabel.text = "\(model.page + 1) / \(model.qtde)"
        } else {
            statusLabel.text = TextUtils.localized(forKey: "Message.SemRegistrosExibir")
        }
        
        statusLabel.sizeToFit()
        
        if let records = self.processoPagingModel?.records {
            rows = records
        } else {
            rows = []
        }
        self.tableView.reloadData()
    }
    
    fileprivate func openFiltroDialog() {
        let dialog = FiltroDialogView.create(filtro: pesquisaModel.filtro, view: revealViewController().view)
        dialog.completionHandler = { filtro in
            dialog.hide()
            self.pesquisaModel.page = 0
            self.pesquisaModel.filtro = filtro
            self.filtrarAsync()
        }
        dialog.show()
    }
}

// MARK: UITableViewDelegate
extension ProcessoPesquisaViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = rows[indexPath.row]
        let controller = UIStoryboard.viewController("Menu", identifier: "Scene.Processo.Detalhe") as! ProcessoDetalheViewController
        controller.id = model.id!
        controller.isLeftMenu = false
        navigationController?.pushViewController(controller, animated: true)
    }
}

// MARK: UITableViewDataSource
extension ProcessoPesquisaViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProcessoTableViewCell", for: indexPath) as! ProcessoTableViewCell
        let model = rows[indexPath.row]
        cell.populate(model)
        return cell
    }
}

// MARK: Asynchronous Methods
extension ProcessoPesquisaViewController {
    
    fileprivate func filtrarAsync() {
        showActivityIndicator()
        let observable = PesquisaService.Async.filtrar(model: self.pesquisaModel)
        prepare(for: observable)
            .subscribe(
                onNext: { model in
                    self.filtrarDidComplete(model)
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

// MARK: Asynchronous Completed Methods
extension ProcessoPesquisaViewController {
    
    fileprivate func filtrarDidComplete(_ model: ProcessoPagingModel) {
        self.atualizar(model)
    }
}
