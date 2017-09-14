//
//  FiltroModel.swift
//  Cliente
//
//  Created by Everton Luiz Pascke on 08/09/17.
//  Copyright © 2017 Wasys. All rights reserved.
//

import Foundation

class FiltroModel: Model {
    
    var numero: String?
    var dataInicio: Date?
    var dataTermino: Date?
    var status: ProcessoModel.Status?
    var coleta: ProcessoModel.Coleta?
    
    var parameters: [String: String] {
        var parameters = [String: String]()
        if TextUtils.isNotBlank(self.numero) {
            parameters["numero"] = self.numero!
        }
        if let dataInicio = self.dataInicio {
            parameters["dataInicio"] = TextUtils.text(dataInicio, type: .dateBr)
        }
        if let dataTermino = self.dataTermino {
            parameters["dataTermino"] = TextUtils.text(dataTermino, type: .dateBr)
        }
        if let status = self.status {
            parameters["status"] = status.rawValue
        }
        if let coleta = self.coleta {
            parameters["coleta"] = coleta.rawValue
        }
        return parameters
    }
}
