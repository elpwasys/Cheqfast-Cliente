//
//  DateField.swift
//  Cliente
//
//  Created by Everton Luiz Pascke on 10/09/17.
//  Copyright © 2017 Wasys. All rights reserved.
//

import UIKit
import MaterialComponents

class DateField: MDCTextField {

    private let datePicker: UIDatePicker = UIDatePicker()
    
    var date: Date? {
        if let text = text, !text.isEmpty {
            return DateUtils.parse(text)
        }
        return nil
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(handle(sender:)), for: UIControlEvents.valueChanged)
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(DateField.onDonePressed))
        
        toolBar.setItems([ space, doneButton ], animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()
        
        inputView = datePicker
        rightView = UIImageView(image: Icon.event)
        rightView?.contentMode = .scaleAspectFit
        rightView?.clipsToBounds = true
        rightViewMode = .always
        
        inputAccessoryView = toolBar
        
    }
    
    @objc fileprivate func onDonePressed() {
        endEditing(true)
        text = DateUtils.format(datePicker.date, pattern: DateType.dateBr.pattern)
    }
    
    @objc fileprivate func handle(sender: UIDatePicker) {
        text = DateUtils.format(sender.date, pattern: DateType.dateBr.pattern)
    }
}
