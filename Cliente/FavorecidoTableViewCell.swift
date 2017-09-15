//
//  FavorecidoTableViewCell.swift
//  Cliente
//
//  Created by Everton Luiz Pascke on 15/09/17.
//  Copyright © 2017 Wasys. All rights reserved.
//

import UIKit

class FavorecidoTableViewCell: UITableViewCell {

    @IBOutlet weak var bancoLabel: UILabel!
    @IBOutlet weak var nomeLabel: UILabel!
    @IBOutlet weak var valorLabel: UILabel!
    @IBOutlet weak var cpfCnpjLabel: UILabel!
    @IBOutlet weak var agenciaContaLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

extension FavorecidoTableViewCell {
    
    static var height: CGFloat {
        return 111
    }
    
    static var nibName: String {
        return "\(FavorecidoTableViewCell.self)"
    }
    
    static var reusableCellIdentifier: String {
        return "\(FavorecidoTableViewCell.self)"
    }
    
    func popular(_ favorecido: FavorecidoModel) {
        ViewUtils.text(favorecido.nomeTitular, for: nomeLabel)
        ViewUtils.text(favorecido.cpfCnpj, for: cpfCnpjLabel)
        ViewUtils.text(favorecido.banco, for: bancoLabel)
        ViewUtils.text(favorecido.valorTransferencia, for: valorLabel)
        ViewUtils.text("\(favorecido.agencia ?? "")/\(favorecido.conta ?? "")", for: agenciaContaLabel)
    }
}
