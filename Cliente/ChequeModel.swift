//
//  ChequeModel.swift
//  Cliente
//
//  Created by Everton Luiz Pascke on 13/09/17.
//  Copyright © 2017 Wasys. All rights reserved.
//

import Foundation

import ObjectMapper

class ChequeModel: Model {
    
    var nome: String?
    var cpfCnpj: String?
    var banco: String?
    var conta: String?
    var agencia: String?
    var valor: Double?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        nome <- map["nome"]
        cpfCnpj <- map["cpfCnpj"]
        banco <- map["banco"]
        conta <- map["conta"]
        agencia <- map["agencia"]
        valor <- map["valor"]
    }
}
