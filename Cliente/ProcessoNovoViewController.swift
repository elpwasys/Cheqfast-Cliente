//
//  ProcessoNovoViewController.swift
//  Cliente
//
//  Created by Everton Luiz Pascke on 10/09/17.
//  Copyright © 2017 Wasys. All rights reserved.
//

import UIKit

import Floaty
import MaterialComponents
import IRLDocumentScanner

class ProcessoNovoViewController: DrawerViewController {

    @IBOutlet weak var tableView: UITableView!
    
    fileprivate var paths = [String]()
    fileprivate var model: ProcessoModel?
    
    // FLOATING ACTION BUTTONS
    fileprivate var menuFloatButton: Floaty!
    fileprivate var capturarFloatButton: FloatyItem!
    fileprivate var finalizarFloatButton: FloatyItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepare()
        startAsyncObter()
    }
}

extension ProcessoNovoViewController {
    
    fileprivate func prepare() {
        prepareTable()
        prepareFloatButtons()
    }
    
    fileprivate func excluir(_ indexPath: IndexPath) {
        paths.remove(at: indexPath.row)
        tableView.reloadData()
    }
    
    fileprivate func iniciar(_ model: ProcessoModel) {
        self.model = model
        self.menuFloatButton.isHidden = false
        self.menuFloatButton.open()
    }
    
    fileprivate func adicionar(_ image: UIImage) {
        if let newImage = image.rotated(by: Measurement(value: 90.0, unit: .degrees), options: [.flipOnVerticalAxis, .flipOnHorizontalAxis]) {
            if let data = UIImageJPEGRepresentation(newImage, 0.8) {
                let manager = FileManager.default
                let url = ImageService.Directory.temporario.url
                if !manager.fileExists(atPath: url.path) {
                    do {
                        try manager.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
                    } catch {
                        print(error.localizedDescription)
                        return
                    }
                }
                let date = Date()
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyyMMdd_HHmmss'.jpg'"
                let name = formatter.string(from: date)
                let fileURL = url.appendingPathComponent(name)
                do {
                    try data.write(to: fileURL)
                    paths.append(fileURL.path)
                    tableView.reloadData()
                } catch {
                    print(error.localizedDescription)
                    return
                }
            }
        }
    }
    
    fileprivate func prepareTable() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = true
        tableView.separatorStyle = .singleLine
        tableView.tableFooterView = UIView()
        tableView.register(UINib(nibName: ChequeTableViewCell.nibName, bundle: nil), forCellReuseIdentifier: ChequeTableViewCell.reusableCellIdentifier)
    }
    
    fileprivate func prepareFloatButtons() {
        if menuFloatButton == nil {
            menuFloatButton = Floaty()
            menuFloatButton.isHidden = true
            menuFloatButton.plusColor = UIColor.white
            menuFloatButton.buttonColor = MDCPalette.red.tint500
            menuFloatButton.overlayColor = UIColor.white.withAlphaComponent(0.7)
            menuFloatButton.animationSpeed = 0.05
            // CAPTURAR
            capturarFloatButton = FloatyItem()
            capturarFloatButton.icon = Icon.photoCameraWhite18pt
            capturarFloatButton.buttonColor = MDCPalette.blue.tint500
            capturarFloatButton.title = TextUtils.localized(forKey: "Label.Capturar")
            capturarFloatButton.handler = { item in
                self.onCapturarTapped()
            }
            menuFloatButton.addItem(item: capturarFloatButton)
            // FINALIZAR
            finalizarFloatButton = FloatyItem()
            finalizarFloatButton.icon = Icon.checkWhite18pt
            finalizarFloatButton.buttonColor = MDCPalette.green.tint500
            finalizarFloatButton.title = TextUtils.localized(forKey: "Label.Finalizar")
            finalizarFloatButton.handler = { item in
                self.onFinalizarTapped()
            }
            menuFloatButton.addItem(item: finalizarFloatButton)
            // COMMONS SETTINGS ITEMS
            for item in menuFloatButton.items {
                //item.isHidden = true
                item.titleColor = UIColor.black
                item.titleShadowColor = UIColor.white.withAlphaComponent(0)
            }
            self.view.addSubview(menuFloatButton)
        }
    }
    
    fileprivate func onCapturarTapped() {
        self.presentScannerViewController()
    }
    
    fileprivate func onFinalizarTapped() {
        if paths.isEmpty {
            let content = TextUtils.localized(forKey: "Message.ErroFinalizarCaptura")
            showMessage(content: content, theme: .warning)
        } else if let grupos = model?.gruposCampos {
            let dialogTransitionController = MDCDialogTransitionController()
            let controller = UIStoryboard.viewController("Menu", identifier: "Scene.Finalizacao") as! FinalizacaoViewController
            controller.grupos = grupos
            controller.delegate = self
            controller.modalPresentationStyle = .custom
            controller.transitioningDelegate = dialogTransitionController
            present(controller, animated: true, completion: nil)
        }
    }
    
    fileprivate func presentScannerViewController() {
        let scanner = IRLScannerViewController.cameraView(withDefaultType: .normal, defaultDetectorType: .accuracy, with: self)
        scanner.showControls = true
        scanner.detectionOverlayColor = Color.primary
        scanner.showAutoFocusWhiteRectangle = true
        self.present(scanner, animated: true, completion: nil)
    }
}

// MARK: IRLScannerViewControllerDelegate
extension ProcessoNovoViewController: IRLScannerViewControllerDelegate {
    
    func didCancel(_ cameraView: IRLScannerViewController) {
        cameraView.dismiss(animated: true, completion: nil)
    }
    
    func pageSnapped(_ image: UIImage, from cameraView: IRLScannerViewController) {
        cameraView.dismiss(animated: true) {
            self.adicionar(image)
        }
    }
}

// MARK: UITableViewDelegate
extension ProcessoNovoViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ChequeTableViewCell.height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? ChequeTableViewCell {
            let imageViewer = ImageViewer(senderView: cell.chequeImageView, backgroundColor: UIColor.white)
            self.present(imageViewer, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let title = TextUtils.localized(forKey: "Label.Excluir")
        let deleteAction = UITableViewRowAction(style: .destructive, title: title) { rowAction, indexPath in
            self.excluir(indexPath)
        }
        return [ deleteAction ]
    }
}

// MARK: UITableViewDataSource
extension ProcessoNovoViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return paths.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ChequeTableViewCell.reusableCellIdentifier, for: indexPath) as! ChequeTableViewCell
        let path = paths[indexPath.row]
        cell.populate(path: path)
        return cell
    }
}

// MARK: FinalizacaoViewControllerDelegate
extension ProcessoNovoViewController: FinalizacaoViewControllerDelegate {
    
    func onFecharTapped(_ controller: FinalizacaoViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func onConfirmarTapped(_ controller: FinalizacaoViewController, grupos: [CampoGrupoModel]) {
        controller.dismiss(animated: true) { 
            if let model = self.model {
                model.gruposCampos = grupos
                if !self.paths.isEmpty {
                    var uploads = [UploadModel]()
                    for path in self.paths {
                        let upload = UploadModel(path)
                        uploads.append(upload)
                    }
                    model.uploads = uploads
                }
                self.startAsyncSalvar(model)
            }
        }
    }
}

// MARK: Async methods completed
extension ProcessoNovoViewController {
    
    fileprivate func asyncObterDidCompleted(_ model: ProcessoModel) {
        self.iniciar(model)
    }
    
    fileprivate func asyncSalvarDidCompleted(_ model: ProcessoModel) {
         let navigation = UIStoryboard.viewController("Menu", identifier: "Nav.Processo.Detalhe") as! UINavigationController
         let controller = navigation.viewControllers.first! as! ProcessoDetalheViewController
         controller.id = model.id!
         revealViewController().pushFrontViewController(navigation, animated: true)
         let content = TextUtils.localized(forKey: "Message.ProcessoSalvoSucesso")
         showMessage(content: content, theme: .success)
    }
}

// MARK: Async methods
extension ProcessoNovoViewController {
    
    fileprivate func startAsyncObter() {
        showActivityIndicator()
        let observable = ProcessoService.Async.obter()
        prepare(for: observable)
            .subscribe(
                onNext: { model in
                    self.asyncObterDidCompleted(model)
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
    
    fileprivate func startAsyncSalvar(_ model: ProcessoModel) {
        showActivityIndicator()
        let observable = ProcessoService.Async.salvar(model)
        prepare(for: observable)
            .subscribe(
                onNext: { model in
                    self.asyncSalvarDidCompleted(model)
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
