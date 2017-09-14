//
//  DocumentoService.swift
//  Cliente
//
//  Created by Everton Luiz Pascke on 14/09/17.
//  Copyright © 2017 Wasys. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire

class DocumentoService: Service {
    
    static func obter(_ id: Int) throws -> DocumentoModel {
        let url = "\(Config.restURL)/documento/obter/\(id)"
        let response: DataResponse<DocumentoModel> = try Network.request(url, method: .get, encoding: JSONEncoding.default, headers: Device.headers).parse()
        let result = response.result
        if result.isFailure {
            throw result.error!
        }
        let model = result.value!
        return model
    }
    
    static func justificar(_ model: JustificativaModel) throws -> ResultModel {
        let url = "\(Config.restURL)/documento/justificar"
        let parameters = model.dictionary
        let response: DataResponse<ResultModel> = try Network.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: Device.headers).parse()
        let result = response.result
        if result.isFailure {
            throw result.error!
        }
        let model = result.value!
        return model
    }
    
    static func substituir(_ id: Int, upload: UploadModel) throws -> DigitalizacaoModel {
        let referencia = "\(id)"
        let digitalizacao = try DigitalizacaoService.criar(referencia: referencia, tipo: .documento, uploads: [upload])
        try DigitalizacaoService.digitalizar(tipo: .documento, referencia: referencia)
        return digitalizacao
    }
    
    class Async {
        
        static func obter(_ id: Int) -> Observable<DocumentoModel> {
            return Observable.create { observer in
                do {
                    let model = try DocumentoService.obter(id)
                    observer.onNext(model)
                    observer.onCompleted()
                } catch {
                    observer.onError(error)
                }
                return Disposables.create()
            
            }
        }
        
        static func substituir(_ id: Int, upload: UploadModel) -> Observable<DigitalizacaoModel> {
            return Observable.create { observer in
                do {
                    let model = try DocumentoService.substituir(id, upload: upload)
                    observer.onNext(model)
                    observer.onCompleted()
                } catch {
                    observer.onError(error)
                }
                return Disposables.create()
                
            }
        }
        
        static func justificar(_ model: JustificativaModel) -> Observable<ResultModel> {
            return Observable.create { observer in
                do {
                    let result = try DocumentoService.justificar(model)
                    observer.onNext(result)
                    observer.onCompleted()
                } catch {
                    observer.onError(error)
                }
                return Disposables.create()
            }
        }
    }
}
