//
//  PesquisaModel.swift
//  Cliente
//
//  Created by Everton Luiz Pascke on 08/09/17.
//  Copyright © 2017 Wasys. All rights reserved.
//

import Foundation

class PesquisaModel: Model {
    
    var page = 0
    var filtro: FiltroModel?
    var parameters: [String: Any] {
        var parameters = [String: Any]()
        parameters["page"] = self.page
        if let filtro = self.filtro {
            parameters["filtro"] = filtro.parameters
        }
        return parameters
    }
}
