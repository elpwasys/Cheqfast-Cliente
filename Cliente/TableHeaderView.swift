//
//  TableHeaderView.swift
//  Cliente
//
//  Created by Everton Luiz Pascke on 10/09/17.
//  Copyright © 2017 Wasys. All rights reserved.
//

import UIKit

class TableHeaderView: UITableViewHeaderFooterView {
    
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    static var height: CGFloat {
        return 58
    }
    
    static var nibName: String {
        return "\(TableHeaderView.self)"
    }
    
    static var reusableCellIdentifier: String {
        return "\(TableHeaderView.self)"
    }
    
    func prepare(_ title: String, color: UIColor = Color.primary) {
        titleLabel.text = title
        titleLabel.textColor = color
        lineView.backgroundColor = color
    }
}
