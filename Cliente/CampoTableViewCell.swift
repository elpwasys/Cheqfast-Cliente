//
//  CampoTableViewCellProtocol.swift
//  Cetelem
//
//  Created by Everton Luiz Pascke on 11/07/17.
//  Copyright © 2017 Wasys Technology. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialPalettes

class CampoTableViewCell: UITableViewCell {

    var value: String? {
        return nil
    }
    
    var isValid: Bool {
        return true
    }
    
    var isEnabled = true
    
    var errorColor: UIColor {
        return MDCPalette.red.tint500
    }
    
    var normalColor: UIColor {
        return MDCPalette.grey.tint400
    }
    
    func prepare(_ model: CampoModel) {
        
    }
}
