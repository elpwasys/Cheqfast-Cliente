//
//  ProcessoDetalheViewController.swift
//  Cliente
//
//  Created by Everton Luiz Pascke on 10/09/17.
//  Copyright © 2017 Wasys. All rights reserved.
//

import UIKit
import Floaty
import MaterialComponents.MaterialPalettes

class ProcessoDetalheViewController: DrawerViewController {

    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var statusImageView: UIImageView!
    
    var id: Int?
    
    fileprivate enum Row {
        case campo(CampoModel)
        case documento(DocumentoModel)
    }
    
    fileprivate struct Section {
        let name: String
        let rows: [Row]
        init(_ name: String, _ rows: [Row]) {
            self.name = name
            self.rows = rows
        }
    }
    
    fileprivate var sections = [Section]()
    
    fileprivate var regra: ProcessoRegraModel?
    fileprivate var processo: ProcessoModel?
    fileprivate var digitalizacao: DigitalizacaoModel?
    
    // FLOATING ACTION BUTTONS
    fileprivate var menuFloatButton: Floaty!
    fileprivate var aprovarFloatButton: FloatyItem!
    fileprivate var cancelarFloatButton: FloatyItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepare()
        if let id = self.id {
            startAsyncEditar(id)
        }
    }
    
    @IBAction func onInfoTapped() {
        verificarDigitalizacao()
    }
}

extension ProcessoDetalheViewController {
    
    fileprivate func prepare() {
        prepareTopView()
        prepareTableView()
        prepareFloatButtons()
    }
    
    fileprivate func prepareTopView() {
        topView.borderBottomWith(color: MDCPalette.grey.tint300, width: 1)
    }
    
    fileprivate func prepareTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = true
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        tableView.register(UINib(nibName: TextFieldTableViewCell.nibName, bundle: nil), forCellReuseIdentifier: TextFieldTableViewCell.reusableCellIdentifier)
        tableView.register(UINib(nibName: DocumentoTableViewCell.nibName, bundle: nil), forCellReuseIdentifier: DocumentoTableViewCell.reusableCellIdentifier)
        tableView.register(UINib(nibName: TableHeaderView.nibName, bundle: nil), forHeaderFooterViewReuseIdentifier: TableHeaderView.reusableCellIdentifier)
    }
    
    fileprivate func popular() {
        if let processo = self.processo {
            ViewUtils.text(processo.id, for: idLabel)
            ViewUtils.text(processo.status.label, for: statusLabel)
            statusImageView.image = processo.status.icon
            // GRUPO
            if let grupos = processo.gruposCampos {
                for grupo in grupos {
                    if let campos = grupo.campos {
                        var rows = [Row]()
                        for campo in campos {
                            rows.append(Row.campo(campo))
                        }
                        sections.append(Section(grupo.nome, rows))
                    }
                }
            }
            // DOCUMENTOS
            if let documentos = processo.documentos {
                var rows = [Row]()
                for documento in documentos {
                    rows.append(Row.documento(documento))
                }
                let name = TextUtils.localized(forKey: "Label.Documentos")
                sections.append(Section(name, rows))
            }
            tableView.reloadData()
            // FLOAT BUTTONS
            //hideMenu()
            /*
            if let regra = self.regra {
                aprovarFloatButton.isHidden = !regra.podeAprovar
                cancelarFloatButton.isHidden = !regra.podeCancelar
                if regra.podeAprovar || regra.podeCancelar {
                    menuFloatButton.isHidden = false
                }
            }
 */
        }
    }
    
    fileprivate func prepareFloatButtons() {
        if menuFloatButton == nil {
            menuFloatButton = Floaty()
            menuFloatButton.plusColor = UIColor.white
            menuFloatButton.buttonColor = MDCPalette.red.tint500
            menuFloatButton.overlayColor = UIColor.white.withAlphaComponent(0.7)
            menuFloatButton.animationSpeed = 0.05
            // APROVAR
            aprovarFloatButton = FloatyItem()
            aprovarFloatButton.icon = Icon.checkWhite18pt
            aprovarFloatButton.buttonColor = MDCPalette.green.tint500
            aprovarFloatButton.title = TextUtils.localized(forKey: "Label.Aprovar")
            aprovarFloatButton.handler = { item in
                self.onAprovarTapped()
            }
            menuFloatButton.addItem(item: aprovarFloatButton)
            // CANCELAR
            cancelarFloatButton = FloatyItem()
            cancelarFloatButton.icon = Icon.closeWhite18pt
            cancelarFloatButton.buttonColor = MDCPalette.blue.tint500
            cancelarFloatButton.title = TextUtils.localized(forKey: "Label.Cancelar")
            cancelarFloatButton.handler = { item in
                self.onCancelarTapped()
            }
            menuFloatButton.addItem(item: cancelarFloatButton)
            // COMMONS SETTINGS ITEMS
            for item in menuFloatButton.items {
                item.titleColor = UIColor.black
                item.titleShadowColor = UIColor.white.withAlphaComponent(0)
            }
            //hideMenu()
            self.view.addSubview(menuFloatButton)
        }
    }
    
    fileprivate func hideMenu() {
        menuFloatButton.isHidden = true
        for item in menuFloatButton.items {
            item.isHidden = true
        }
    }
    
    fileprivate func onAprovarTapped() {
        let controller = UIStoryboard.viewController("Menu", identifier: "Scene.Transferencia") as! TransferenciaViewController
        controller.id = id
        navigationController?.pushViewController(controller, animated: true)
    }
    
    fileprivate func onCancelarTapped() {
        DispatchQueue.main.async {
            let alert = UIAlertController(
                title: TextUtils.localized(forKey: "Label.Cancelar"),
                message: TextUtils.localized(forKey: "Message.ProcessoCancelar"),
                preferredStyle: UIAlertControllerStyle.actionSheet
            )
            alert.addAction(UIAlertAction(
                title: TextUtils.localized(forKey: "Label.Sim"),
                style: UIAlertActionStyle.default,
                handler: { (action: UIAlertAction!) in
                    self.cancelar()
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
    
    fileprivate func presentScene(for documento: DocumentoModel) {
        if documento.isCheque {
            let controller = UIStoryboard.viewController("Menu", identifier: "Scene.Cheque.Detalhe") as! ChequeDetalheViewController
            controller.id = documento.id
            navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    fileprivate func get(by section: Int) -> [Row] {
        return sections[section].rows
    }
    
    fileprivate func get(by indexPath: IndexPath) -> Row {
        return get(by: indexPath.section)[indexPath.row]
    }
    
    fileprivate func cancelar() {
        if let id = self.id {
            startAsyncCancelar(id)
        }
    }
    
    fileprivate func digitalizar() {
        if let id = self.id {
            startAsyncDigitalizar(id)
        }
    }
    
    fileprivate func verificarDigitalizacao() {
        if let id = self.id {
            startAsyncVerificarDigitalizacao(id)
        }
    }
}

// MARK: UITableViewDelegate
extension ProcessoDetalheViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let nome = sections[section].name
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: TableHeaderView.reusableCellIdentifier) as! TableHeaderView
        header.prepare(nome)
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let row = get(by: indexPath)
        switch row {
        case .campo(_ ):
            return TextFieldTableViewCell.height
        case .documento(_ ):
            return DocumentoTableViewCell.height
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return TableHeaderView.height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = get(by: indexPath)
        switch row {
        case .campo(_ ):
            break
        case .documento(let documento):
            if documento.isCheque {
                presentScene(for: documento)
            }
            break
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let header = view as? TableHeaderView {
            header.contentView.backgroundColor = UIColor.white
        }
    }
}

// MARK: UITableViewDataSource
extension ProcessoDetalheViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return get(by: section).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row: Row = get(by: indexPath)
        let cell: UITableViewCell
        switch row {
        case .campo(let campo):
            let campoTableViewCell = tableView.dequeueReusableCell(withIdentifier: TextFieldTableViewCell.reusableCellIdentifier, for: indexPath) as! CampoTableViewCell
            campoTableViewCell.isEnabled = false
            campoTableViewCell.isUserInteractionEnabled = false
            campoTableViewCell.selectionStyle = .none
            campoTableViewCell.prepare(campo)
            cell = campoTableViewCell
        case .documento(let documento):
            let documentoTableViewCell = tableView.dequeueReusableCell(withIdentifier: DocumentoTableViewCell.reusableCellIdentifier, for: indexPath) as! DocumentoTableViewCell
            if documento.isCheque {
                documentoTableViewCell.selectionStyle = .gray
                documentoTableViewCell.isUserInteractionEnabled = true
            } else {
                documentoTableViewCell.selectionStyle = .none
                documentoTableViewCell.isUserInteractionEnabled = false
            }
            documentoTableViewCell.populate(documento)
            cell = documentoTableViewCell
        }
        return cell
    }
}

// MARK: Asynchronous Completed Methods
extension ProcessoDetalheViewController {
    
    fileprivate func editarDidComplete(_ dataSet: DataSet<ProcessoModel, ProcessoRegraModel>) {
        regra = dataSet.meta
        processo = dataSet.data
        popular()
    }
    
    fileprivate func verificarDigitalizacaoDidCompleted(_ model: DigitalizacaoModel?) {
        self.digitalizacao = model
        if let digitalizacao = self.digitalizacao {
            let dialog = DigitalizacaoDialogView.create(model: digitalizacao, view: revealViewController().view)
            dialog.completionHandler = { answer in
                dialog.hide()
                if answer {
                    self.digitalizar()
                }
            }
            dialog.show()
        } else {
            let message = App.Message()
            message.layout = .StatusLine
            message.backgroundColor = UIColor.black
            message.foregroundColor = UIColor.white
            message.duration = .seconds(seconds: 1)
            message.content = TextUtils.localized(forKey: "Message.SemInfoDigitalizacao")
            message.show()
        }
    }
    
    fileprivate func digitalizarDidCompleted() {
        let content = TextUtils.localized(forKey: "Message.ProcessoEnviadoSucesso")
        showMessage(content: content, theme: .success)
    }
}

// MARK: Asynchronous Methods
extension ProcessoDetalheViewController {
    
    fileprivate func startAsyncCancelar(_ id: Int) {
        showActivityIndicator()
        let observable = ProcessoService.Async.cancelar(id)
        prepare(for: observable)
            .subscribe(
                onNext: { dataSet in
                    self.editarDidComplete(dataSet)
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
    
    fileprivate func startAsyncEditar(_ id: Int) {
        showActivityIndicator()
        let observable = ProcessoService.Async.editar(id)
        prepare(for: observable)
            .subscribe(
                onNext: { dataSet in
                    self.editarDidComplete(dataSet)
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
    
    fileprivate func startAsyncVerificarDigitalizacao(_ id: Int) {
        let referencia = "\(id)"
        let observable = DigitalizacaoService.Async.getBy(referencia: referencia, tipo: .tipificacao)
        prepare(for: observable)
            .subscribe(
                onNext: { model in
                    self.verificarDigitalizacaoDidCompleted(model)
                },
                onError: { error in
                    self.handle(error)
                }
            ).addDisposableTo(disposableBag)
    }
    
    fileprivate func startAsyncDigitalizar(_ id: Int) {
        let referencia = "\(id)"
        let observable = DigitalizacaoService.Async.digitalizar(tipo: .tipificacao, referencia: referencia)
        prepare(for: observable).subscribe(
            onNext: {
                self.digitalizarDidCompleted()
            },
            onError: { error in
                self.handle(error)
            }
        ).addDisposableTo(disposableBag)
    }
}
