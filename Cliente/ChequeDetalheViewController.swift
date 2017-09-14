//
//  ChequeDetalheViewController.swift
//  Cliente
//
//  Created by Everton Luiz Pascke on 14/09/17.
//  Copyright © 2017 Wasys. All rights reserved.
//

import UIKit
import Floaty
import Kingfisher
import IRLDocumentScanner
import MaterialComponents.MaterialDialogs
import MaterialComponents.MaterialPalettes

class ChequeDetalheViewController: CheqfastViewController {

    @IBOutlet weak var nomeLabel: UILabel!
    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var documentoLabel: UILabel!
    @IBOutlet weak var statusImageView: UIImageView!
    
    @IBOutlet weak var chequeAtualView: UIView!
    @IBOutlet weak var chequeOutroView: UIView!
    
    @IBOutlet weak var chequeAtualImageView: UIImageView!
    @IBOutlet weak var chequeOutroImageView: UIImageView!
    
    @IBOutlet weak var infoButton: UIButton!
    @IBOutlet weak var substituirButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // FLOATING ACTION BUTTONS
    fileprivate var menuFloatButton: Floaty!
    fileprivate var capturarFloatButton: FloatyItem!
    fileprivate var justificarFloatButton: FloatyItem!
    
    
    var id: Int?
    fileprivate var path: String?
    fileprivate var documento: DocumentoModel?
    fileprivate var digitalizacao: DigitalizacaoModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepare()
        if let id = self.id {
            startAsyncObter(id)
        }
    }
    
    @IBAction func onInfoTapped() {
        verificarDigitalizacao()
    }

    @IBAction func onSubstituirTapped() {
        DispatchQueue.main.async {
            let alert = UIAlertController(
                title: TextUtils.localized(forKey: "Label.Substituir"),
                message: TextUtils.localized(forKey: "Message.SubstituirCheque"),
                preferredStyle: UIAlertControllerStyle.actionSheet
            )
            alert.addAction(UIAlertAction(
                title: TextUtils.localized(forKey: "Label.Sim"),
                style: UIAlertActionStyle.default,
                handler: { (action: UIAlertAction!) in
                    self.substituir()
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

// MARK: Common
extension ChequeDetalheViewController {
    
    fileprivate func prepare() {
        infoButton.isHidden = true
        prepareChequeView()
        prepareFloatButtons()
    }
    
    fileprivate func prepareChequeView() {
        chequeAtualView.isHidden = true
        chequeAtualView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onChequeAtualTapped)))
        chequeOutroView.isHidden = true
        chequeOutroView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onChequeOutroTapped)))
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
            capturarFloatButton.buttonColor = MDCPalette.green.tint500
            capturarFloatButton.title = TextUtils.localized(forKey: "Label.Substituir")
            capturarFloatButton.handler = { item in
                self.onCapturarTapped()
            }
            menuFloatButton.addItem(item: capturarFloatButton)
            // JUSTIFICAR
            justificarFloatButton = FloatyItem()
            justificarFloatButton.icon = Icon.undoWhite18pt
            justificarFloatButton.buttonColor = MDCPalette.blue.tint500
            justificarFloatButton.title = TextUtils.localized(forKey: "Label.Justificar")
            justificarFloatButton.handler = { item in
                self.onJustificarTapped()
            }
            menuFloatButton.addItem(item: justificarFloatButton)
            // COMMONS SETTINGS ITEMS
            for item in menuFloatButton.items {
                item.titleColor = UIColor.black
                item.titleShadowColor = UIColor.white.withAlphaComponent(0)
            }
            hideMenu()
            self.view.addSubview(menuFloatButton)
        }
    }
    
    @objc fileprivate func onChequeAtualTapped() {
        if chequeAtualImageView.image != nil {
            openImageViewer(chequeAtualImageView)
        }
    }
    
    @objc fileprivate func onChequeOutroTapped() {
        if chequeOutroImageView.image != nil {
            openImageViewer(chequeOutroImageView)
        }
    }
    
    fileprivate func openImageViewer(_ imageView: UIImageView) {
        let imageViewer = ImageViewer(senderView: imageView, backgroundColor: UIColor.white)
        self.present(imageViewer, animated: true, completion: nil)
    }
    
    fileprivate func onCapturarTapped() {
        presentScannerViewController()
    }
    
    fileprivate func onJustificarTapped() {
        if let documento = self.documento {
            let view = revealViewController().view!
            let dialog = PendenciaDialogView.create(model: documento, view: view)
            dialog.completionHandler = { aswner, text in
                dialog.hide()
                if aswner, let justificativa = text {
                    self.justificar(documento.id!, justificativa)
                }
            }
            dialog.show()
        }
    }
    
    fileprivate func hideMenu() {
        menuFloatButton.isHidden = true
        for item in menuFloatButton.items {
            item.isHidden = true
        }
    }
    
    fileprivate func enableReplace() {
        if let path = self.path {
            chequeOutroImageView.image = UIImage(contentsOfFile: path)
            chequeOutroView.isHidden = false
        }
    }
    
    fileprivate func verificarDigitalizacao() {
        if let id = self.id {
            startAsyncVerificarDigitalizacao(id)
        }
    }
    
    fileprivate func popular() {
        if let documento = self.documento {
            infoButton.isHidden = false
            statusImageView.image = documento.status.icon
            ViewUtils.text(documento.dataDigitalizacao, for: dataLabel)
            ViewUtils.text(documento.nome, for: nomeLabel)
            ViewUtils.text(documento.status.label, for: statusLabel)
            if let cheque = documento.cheque {
                ViewUtils.text(cheque.cpfCnpj, for: documentoLabel)
            } else {
                ViewUtils.text(nil, for: documentoLabel)
            }
            if let imagem = documento.imagens?.first {
                chequeAtualView.isHidden = false
                if let url = URL(string: "\(Config.baseURL)\(imagem.caminho!)") {
                    activityIndicator.startAnimating()
                    chequeAtualImageView.kf.setImage(with: url) { _, _, _, _ in
                        self.activityIndicator.stopAnimating()
                    }
                }
            }
            if documento.justificavel || documento.digitalizavel {
                menuFloatButton.isHidden = false
                capturarFloatButton.isHidden = !documento.digitalizavel
                justificarFloatButton.isHidden = !documento.justificavel
            }
        }
    }
    
    fileprivate func justificar(_ id: Int, _ justificativa: String) {
        let model = JustificativaModel(id, justificativa)
        startAsyncJustificar(model)
    }
    
    fileprivate func presentScannerViewController() {
        let scanner = IRLScannerViewController.cameraView(withDefaultType: .normal, defaultDetectorType: .accuracy, with: self)
        scanner.showControls = true
        scanner.detectionOverlayColor = Color.primary
        scanner.showAutoFocusWhiteRectangle = true
        self.present(scanner, animated: true, completion: nil)
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
                    self.path = fileURL.path
                    self.enableReplace()
                } catch {
                    print(error.localizedDescription)
                    return
                }
            }
        }
    }
    
    fileprivate func substituir() {
        if let id = self.id, let path = self.path {
            let upload = UploadModel(path)
            startAsyncSubstituir(id, upload: upload)
        }
    }
    
    fileprivate func digitalizar() {
        if let id = self.id {
            startAsyncDigitalizar(id)
        }
    }
}

// MARK: IRLScannerViewControllerDelegate
extension ChequeDetalheViewController: IRLScannerViewControllerDelegate {
    
    func didCancel(_ cameraView: IRLScannerViewController) {
        cameraView.dismiss(animated: true, completion: nil)
    }
    
    func pageSnapped(_ image: UIImage, from cameraView: IRLScannerViewController) {
        cameraView.dismiss(animated: true) {
            self.adicionar(image)
        }
    }
}

// MARK: Async Methods
extension ChequeDetalheViewController {
    
    fileprivate func obterDidCompleted(_ model: DocumentoModel) {
        documento = model
        popular()
    }
    
    fileprivate func justificarDidCompleted(_ model: ResultModel) {
        let content = TextUtils.localized(forKey: "Message.JustificativaSucesso")
        showMessage(content: content, theme: .success)
        navigationController?.popViewController(animated: true)
    }
    
    fileprivate func substituirDidCompleted(_ model: DigitalizacaoModel) {
        let content = TextUtils.localized(forKey: "Message.DocumentoEnviadoSucesso")
        showMessage(content: content, theme: .success)
        navigationController?.popViewController(animated: true)
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

// MARK: Async Methods
extension ChequeDetalheViewController {
    
    fileprivate func startAsyncObter(_ id: Int) {
        showActivityIndicator()
        let observable = DocumentoService.Async.obter(id)
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
    
    fileprivate func startAsyncVerificarDigitalizacao(_ id: Int) {
        let referencia = "\(id)"
        let observable = DigitalizacaoService.Async.getBy(referencia: referencia, tipo: .documento)
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
    
    fileprivate func startAsyncSubstituir(_ id: Int, upload: UploadModel) {
        showActivityIndicator()
        let observable = DocumentoService.Async.substituir(id, upload: upload)
        prepare(for: observable)
            .subscribe(
                onNext: { model in
                    self.substituirDidCompleted(model)
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
    
    fileprivate func startAsyncDigitalizar(_ id: Int) {
        let referencia = "\(id)"
        let observable = DigitalizacaoService.Async.digitalizar(tipo: .documento, referencia: referencia)
        prepare(for: observable).subscribe(
            onNext: {
                self.digitalizarDidCompleted()
            },
            onError: { error in
                self.handle(error)
            }
        ).addDisposableTo(disposableBag)
    }
    
    fileprivate func startAsyncJustificar(_ model: JustificativaModel) {
        self.showActivityIndicator()
        let observable = DocumentoService.Async.justificar(model)
        prepare(for: observable).subscribe(
            onNext: { model in
                self.justificarDidCompleted(model)
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
