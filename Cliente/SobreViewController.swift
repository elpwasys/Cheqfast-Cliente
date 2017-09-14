//
//  SobreViewController.swift
//  Cliente
//
//  Created by Everton Luiz Pascke on 07/09/17.
//  Copyright © 2017 Wasys. All rights reserved.
//

import UIKit

class SobreViewController: DrawerViewController {

    @IBOutlet weak var versaoLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepare()
    }
}


extension SobreViewController {
    
    fileprivate func prepare() {
        ViewUtils.text(Device.appVersion, for: versaoLabel)
    }
}
