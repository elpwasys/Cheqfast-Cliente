//
//  ProcessoTableViewCell.swift
//  Cliente
//
//  Created by Everton Luiz Pascke on 10/09/17.
//  Copyright © 2017 Wasys. All rights reserved.
//

import UIKit

class ProcessoTableViewCell: UITableViewCell {

    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var coletaLabel: UILabel!
    @IBOutlet weak var statusImageView: UIImageView!
    @IBOutlet weak var coletaImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func populate(_ model: ProcessoModel) {
        idLabel.text = "\(model.id ?? 0)"
        dataLabel.text = DateUtils.format(model.dataCriacao, type: .dateBr)
        statusLabel.text = model.status.label
        statusImageView.image = model.status.icon
        if let coleta = model.coleta {
            coletaLabel.text = coleta.label
            coletaImageView.image = coleta.icon
        }
    }
}
