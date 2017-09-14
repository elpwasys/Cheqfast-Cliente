//
//  DocumentoTableViewCell.swift
//  Cliente
//
//  Created by Everton Luiz Pascke on 13/09/17.
//  Copyright © 2017 Wasys. All rights reserved.
//

import UIKit

class DocumentoTableViewCell: UITableViewCell {

    @IBOutlet weak var nomeLabel: UILabel!
    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var documentoLabel: UILabel!
    @IBOutlet weak var statusImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func populate(_ model: DocumentoModel) {
        statusImageView.image = model.status.icon
        ViewUtils.text(model.dataDigitalizacao, for: dataLabel)
        ViewUtils.text(model.nome, for: nomeLabel)
        ViewUtils.text(model.status.label, for: statusLabel)
        if let cheque = model.cheque {
            ViewUtils.text(cheque.cpfCnpj, for: documentoLabel)
        } else {
            ViewUtils.text(nil, for: documentoLabel)
        }
    }
}

extension DocumentoTableViewCell {
    
    static var height: CGFloat {
        return 117
    }
    
    static var nibName: String {
        return "\(DocumentoTableViewCell.self)"
    }
    
    static var reusableCellIdentifier: String {
        return "\(DocumentoTableViewCell.self)"
    }
}
