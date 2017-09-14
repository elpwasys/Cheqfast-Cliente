//
//  ProcessoModel.swift
//  Cliente
//
//  Created by Everton Luiz Pascke on 08/09/17.
//  Copyright © 2017 Wasys. All rights reserved.
//

import Foundation
import ObjectMapper

class ProcessoModel: Model {
    
    var status: Status!
    var coleta: Coleta!
    
    var dataCriacao: Date!
    
    var taxa: Double?
    var valorLiberado: Double?
    
    var tipoProcesso: TipoProcessoModel?
    
    var uploads: [UploadModel]?
    var documentos: [DocumentoModel]?
    var gruposCampos: [CampoGrupoModel]?
    
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
        put("id", id)
        if status != nil {
            put("status", status.rawValue)
        }
        if coleta != nil {
            put("coleta", coleta.rawValue)
        }
        if taxa != nil {
            put("taxa", taxa)
        }
        if valorLiberado != nil {
            put("valorLiberado", valorLiberado)
        }
        put("dataCriacao", dataCriacao)
        if let element = tipoProcesso?.dictionary {
            if values == nil {
                values = [String: String]()
            }
            values?["tipoProcesso"] = element
        }
        if let grupos = self.gruposCampos {
            var elements = [[String: Any]]()
            for grupo in grupos {
                if let element = grupo.dictionary {
                    elements.append(element)
                }
            }
            if !elements.isEmpty {
                if values == nil {
                    values = [String: String]()
                }
                values?["gruposCampos"] = elements
            }
        }
        return values
    }
    
    enum Status: String, Selectable {
        case rascunho = "RASCUNHO"
        case emAnalise = "EM_ANALISE"
        case pendente = "PENDENTE"
        case concluido = "CONCLUIDO"
        case cancelado = "CANCELADO"
        case aguardandoAprovacao = "AGUARDANDO_APROVACAO"
        case aguardandoDocumentos = "AGUARDANDO_DOCUMENTOS"
        case emLiberacao = "EM_LIBERACAO"
        case rejeitado = "REJEITADO"
        var key: String {
            return "Processo.Status.\(self)"
        }
        var icon: UIImage? {
            return UIImage(named: key)
        }
        var label: String {
            return TextUtils.localized(forKey: key)
        }
        var value: String {
            return self.rawValue
        }
        static var values: [Status] {
            return [
                Status.rascunho,
                Status.emAnalise,
                Status.pendente,
                Status.concluido,
                Status.cancelado,
                Status.aguardandoAprovacao,
                Status.aguardandoDocumentos,
                Status.emLiberacao,
                Status.rejeitado
            ]
        }
    }
    
    enum Coleta: String, Selectable {
        case aguardandoColeta = "AGUARDANDO_COLETA"
        case coletado = "COLETADO"
        case armazenado = "ARMAZENADO"
        var key: String {
            return "Processo.Coleta.\(self)"
        }
        var icon: UIImage? {
            switch self {
            case .coletado:
                return Icon.folder
            case .armazenado:
                return Icon.storage
            case .aguardandoColeta:
                return Icon.directionsBike
            }
        }
        var label: String {
            return TextUtils.localized(forKey: key)
        }
        var value: String {
            return self.rawValue
        }
        static var values: [Coleta] {
            return [
                Coleta.aguardandoColeta,
                Coleta.coletado,
                Coleta.armazenado
            ]
        }
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        let dateTransform = DateTransformType()
        status <- map["status"]
        tipoProcesso <- map["tipoProcesso"]
        dataCriacao <- (map["dataCriacao"], dateTransform)
        documentos <- map["documentos"]
        gruposCampos <- map["gruposCampos"]
    }
}
