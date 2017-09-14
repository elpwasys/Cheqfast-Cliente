//
//  ChequeTableViewCell.swift
//  Cliente
//
//  Created by Everton Luiz Pascke on 13/09/17.
//  Copyright © 2017 Wasys. All rights reserved.
//

import UIKit
import Kingfisher

class ChequeTableViewCell: UITableViewCell {

    @IBOutlet weak var chequeImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func populate(path: String) {
        chequeImageView.image = UIImage(contentsOfFile: path)
    }
    
    func populate(caminho: String) {
        chequeImageView.image = nil
        if let url = URL(string: "\(Config.baseURL)\(caminho)") {
            let loading = App.Loading()
            loading.show(view: chequeImageView)
            chequeImageView.kf.setImage(with: url) { _, _, _, _ in
                loading.hide()
            }
        }
    }
}

extension ChequeTableViewCell {
    
    static var height: CGFloat {
        return 166
    }
    
    static var nibName: String {
        return "\(ChequeTableViewCell.self)"
    }
    
    static var reusableCellIdentifier: String {
        return "\(ChequeTableViewCell.self)"
    }
}
