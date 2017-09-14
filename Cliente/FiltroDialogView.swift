//
//  FiltroDialogView.swift
//  Cliente
//
//  Created by Everton Luiz Pascke on 10/09/17.
//  Copyright © 2017 Wasys. All rights reserved.
//

import UIKit
import MaterialComponents

class FiltroDialogView: View {

    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var numeroTextField: MDCTextField!
    @IBOutlet weak var statusPickerField: PickerField!
    @IBOutlet weak var coletaPickerField: PickerField!
    @IBOutlet weak var dataInicioDateField: DateField!
    @IBOutlet weak var dataTerminoDateField: DateField!
    
    fileprivate var view: UIView!
    fileprivate var overlay: UIView!
    
    var completionHandler: ((FiltroModel) -> Void)?
    
    @IBAction func onLimparTapped() {
        if let completionHandler = self.completionHandler {
            let filtro = FiltroModel()
            completionHandler(filtro)
        }
    }
    
    @IBAction func onFiltrarTapped() {
        if let completionHandler = self.completionHandler {
            let filtro = FiltroModel()
            if TextUtils.isNotBlank(numeroTextField.text) {
                filtro.numero = numeroTextField.text
            }
            filtro.dataInicio = dataInicioDateField.date
            filtro.dataTermino = dataTerminoDateField.date
            if let option = statusPickerField.value {
                filtro.status = ProcessoModel.Status(rawValue: option.value)
            }
            if let option = coletaPickerField.value {
                filtro.coleta = ProcessoModel.Coleta(rawValue: option.value)
            }
            completionHandler(filtro)
        }
    }
}

extension FiltroDialogView {
    
    static func create(filtro: FiltroModel?, view: UIView) -> FiltroDialogView {
        
        let dialog = Bundle.main.loadNibNamed("FiltroDialogView", owner: view, options: nil)?.first as! FiltroDialogView
        dialog.prepare()
        
        dialog.frame.size = CGSize(width: view.frame.width - CGFloat(32), height: dialog.frame.height)
        dialog.view = view
        dialog.cornerRadius = 4
        
        let layer = dialog.layer
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        layer.shadowRadius = 4.0
        layer.shadowOpacity = 0.4
        layer.shadowPath = UIBezierPath(roundedRect: layer.bounds, cornerRadius: layer.cornerRadius).cgPath
        
        dialog.statusPickerField.entries(array: ProcessoModel.Status.values)
        dialog.coletaPickerField.entries(array: ProcessoModel.Coleta.values)
        
        if let model = filtro {
            ViewUtils.text(model.numero, for: dialog.numeroTextField)
            ViewUtils.text(model.dataInicio, for: dialog.dataInicioDateField)
            ViewUtils.text(model.dataTermino, for: dialog.dataTerminoDateField)
            if let status = model.status {
                dialog.statusPickerField.value = status
            }
            if let coleta = model.coleta {
                dialog.coletaPickerField.value = coleta
            }
        }
        
        return dialog
    }
    
    func show() {
        if overlay == nil {
            
            let size = CGSize(width: self.frame.size.width, height: self.frame.size.height + CGFloat(32))
            
            self.frame.size = size
            
            // Overlay
            overlay = UIView(frame: view.frame)
            overlay.center = view.center
            overlay.alpha = 0.5
            overlay.backgroundColor = UIColor.black
            
            let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hide))
            overlay.addGestureRecognizer(gestureRecognizer)
            
            center = overlay.center
            //
            view.addSubview(overlay)
            
            self.alpha = 0
            view.addSubview(self)
            
            let timing = UICubicTimingParameters(animationCurve: .easeIn)
            let animator = UIViewPropertyAnimator(duration: 0.25, timingParameters: timing)
            animator.addAnimations {
                self.alpha = 1
            }
            animator.startAnimation()
        }
    }
    
    func hide() {
        if overlay != nil {
            overlay.removeFromSuperview()
            overlay = nil
            self.removeFromSuperview()
        }
    }
    
    fileprivate func prepare() {
        ShadowUtils.applyBottom(topView)
    }
}
