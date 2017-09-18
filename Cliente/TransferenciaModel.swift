//
//  TransferenciaModel.swift
//  Cliente
//
//  Created by Everton Luiz Pascke on 11/09/17.
//  Copyright © 2017 Wasys. All rights reserved.
//

import Foundation
import ObjectMapper

class TransferenciaModel: Model {
    
    var valor: Double?
    var custo: Double?
    
    var processo: ProcessoModel?
    var principal: ContaBancoModel?
    
    var bancos: [String]?
    var favorecidos: [FavorecidoModel]?
    
    var dictionary: [String: Any]? {
        var values: [String: Any]?
        func put(_ key: String, _ value: Any?) {
            if value != nil {
                if values == nil {
                    values = [String: Any]()
                }
                if value is Double {
                    values?[key] = value
                } else if value is [String: Any] || value is [[String: Any]] {
                    values?[key] = value
                } else if let text = TextUtils.text(value) {
                    values?[key] = text
                }
            }
        }
        put("valor", valor)
        put("custo", custo)
        if let id = self.processo?.id {
            put("processo", ["id": id])
        }
        if let obj = self.principal?.dictionary {
            put("principal", obj)
        }
        if let favorecidos = self.favorecidos {
            var objs = [[String: Any]]()
            for favorecido in favorecidos {
                if let obj = favorecido.dictionary {
                    objs.append(obj)
                }
            }
            if !objs.isEmpty {
                put("favorecidos", objs)
            }
        }
        return values
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        valor <- map["valor"]
        custo <- map["custo"]
        processo <- map["processo"]
        principal <- map["principal"]
        bancos <- map["bancos"]
        favorecidos <- map["favorecidos"]
    }
}
