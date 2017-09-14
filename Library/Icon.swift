//
//  Icon.swift
//  Cliente
//
//  Created by Everton Luiz Pascke on 21/07/17.
//  Copyright © 2017 Wasys Technology. All rights reserved.
//

import UIKit

struct Icon {
    static func icon(_ named: String) -> UIImage? {
        return UIImage(named: named)/*?.withRenderingMode(.alwaysTemplate)*/
    }
    static let arrowDropDown = icon("ic_arrow_drop_down")
    static let event = icon("ic_event")
    static let close = icon("ic_close")
}
