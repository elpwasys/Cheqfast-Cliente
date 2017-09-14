//
//  DigitalizacaoModel.swift
//  Cetelem
//
//  Created by Everton Luiz Pascke on 25/07/17.
//  Copyright © 2017 Wasys Technology. All rights reserved.
//

import Foundation
import MaterialComponents

class DigitalizacaoModel {
    
    var id: Int!
    var tentativas: Int!
    
    var tipo: Tipo!
    var status: Status!
    
    var referencia: String!
    var mensagem: String?
    
    var dataHora: Date!
    var dataHoraEnvio: Date?
    var dataHoraRetorno: Date?
    
    var arquivos: [ArquivoModel]?
    
    enum Tipo: String {
        case documento = "DOCUMENTO"
        case tipificacao = "TIPIFICACAO"
        var key: String {
            return "Digitalizacao.Tipo.\(self)"
        }
        var label: String {
            return TextUtils.localized(forKey: key)
        }
    }
    
    enum Status: String {
        case erro = "ERRO"
        case enviado = "ENVIADO"
        case enviando = "ENVIANDO"
        case aguardando = "AGUARDANDO"
        var key: String {
            return "Digitalizacao.Status.\(self)"
        }
        var label: String {
            return TextUtils.localized(forKey: key)
        }
        var textColor: UIColor {
            return UIColor.white
        }
        var shadowColor: UIColor {
            switch self {
            case .erro: return MDCPalette.red.tint900
            case .enviado: return MDCPalette.green.tint900
            case .enviando: return MDCPalette.orange.tint900
            case .aguardando: return MDCPalette.grey.tint900
            }
        }
        var backgroundColor: UIColor {
            switch self {
                case .erro: return MDCPalette.red.tint500
                case .enviado: return MDCPalette.green.tint500
                case .enviando: return MDCPalette.orange.tint500
                case .aguardando: return MDCPalette.grey.tint500
            }
        }
    }
    
    static func from(_ digitalizacao: Digitalizacao) -> DigitalizacaoModel {
        let model = DigitalizacaoModel()
        model.id = digitalizacao.id
        model.tentativas = digitalizacao.tentativas
        model.tipo = Tipo(rawValue: digitalizacao.tipo)
        model.status = Status(rawValue: digitalizacao.status)
        model.referencia = digitalizacao.referencia
        model.mensagem = digitalizacao.mensagem
        model.dataHora = digitalizacao.dataHora
        model.dataHoraEnvio = digitalizacao.dataHoraEnvio
        model.dataHoraRetorno = digitalizacao.dataHoraRetorno
        model.arquivos = ArquivoModel.from(digitalizacao.arquivos)
        return model
    }
}
