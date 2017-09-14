//
//  ContaBancoModel.swift
//  Cliente
//
//  Created by Everton Luiz Pascke on 11/09/17.
//  Copyright © 2017 Wasys. All rights reserved.
//

import Foundation
import ObjectMapper

class ContaBancoModel: Model {
    
    var status: Status?
    
    var banco: String?
    var conta: String?
    var agencia: String?
    var cpfCnpj: String?
    var nomeTitular: String?
    
    var valor: Double?
    var custo: Double?
    var valorTransferencia: Double?
    
    var dictionary: [String: Any]? {
        var values: [String: Any]?
        func put(_ key: String, _ value: Any?) {
            if value != nil, let text = TextUtils.text(value) {
                if values == nil {
                    values = [String: Any]()
                }
                values?[key] = text
            }
        }
        if let status = self.status {
            put("status", status.rawValue)
        }
        put("banco", banco)
        put("conta", conta)
        put("agencia", agencia)
        put("cpfCnpj", cpfCnpj)
        put("nomeTitular", nomeTitular)
        put("valor", valor)
        put("custo", custo)
        put("valorTransferencia", valorTransferencia)
        return values
    }
    
    enum Status: String {
        case ativo = "ATIVO"
        case inativo = "INATIVO"
        case historico = "HISTORICO"
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        status <- map["status"]
        banco <- map["banco"]
        conta <- map["conta"]
        agencia <- map["agencia"]
        cpfCnpj <- map["cpfCnpj"]
        nomeTitular <- map["nomeTitular"]
        valor <- map["valor"]
        custo <- map["custo"]
        valorTransferencia <- map["valorTransferencia"]
    }
}
