//
//  ProcessoService.swift
//  Cliente
//
//  Created by Everton Luiz Pascke on 11/09/17.
//  Copyright © 2017 Wasys. All rights reserved.
//

import Foundation

import RxSwift
import Alamofire

class ProcessoService: Service {
    
    static func salvar(_ model: ProcessoModel) throws -> ProcessoModel {
        let url = "\(Config.restURL)/processo/salvar"
        let dictionary = model.dictionary
        let response: DataResponse<ProcessoModel> = try Network.request(url, method: .post, parameters: dictionary, encoding: JSONEncoding.default, headers: Device.headers).parse()
        let result = response.result
        if result.isFailure {
            throw result.error!
        }
        let values = result.value!
        if let uploads = model.uploads {
            let referencia = "\(values.id!)"
            _ = try DigitalizacaoService.criar(referencia: referencia, tipo: .tipificacao, uploads: uploads)
            try DigitalizacaoService.digitalizar(tipo: .tipificacao, referencia: referencia)
        }
        return values
    }
    
    static func aprovar(_ id: Int, model: TransferenciaModel) throws -> DataSet<ProcessoModel, ProcessoRegraModel> {
        let url = "\(Config.restURL)/processo/aprovar/\(id)"
        let dictionary = model.dictionary
        let response: DataResponse<DataSet<ProcessoModel, ProcessoRegraModel>> = try Network.request(url, method: .post, parameters: dictionary, encoding: JSONEncoding.default, headers: Device.headers).parse()
        let result = response.result
        if result.isFailure {
            throw result.error!
        }
        let dataSet = result.value!
        return dataSet
    }
    
    static func editar(_ id: Int) throws -> DataSet<ProcessoModel, ProcessoRegraModel> {
        let url = "\(Config.restURL)/processo/editar/\(id)"
        let response: DataResponse<DataSet<ProcessoModel, ProcessoRegraModel>> = try Network.request(url, method: .get, encoding: JSONEncoding.default, headers: Device.headers).parse()
        let result = response.result
        if result.isFailure {
            throw result.error!
        }
        let dataSet = result.value!
        return dataSet
    }
    
    static func cancelar(_ id: Int) throws -> DataSet<ProcessoModel, ProcessoRegraModel> {
        let url = "\(Config.restURL)/processo/cancelar/\(id)"
        let response: DataResponse<DataSet<ProcessoModel, ProcessoRegraModel>> = try Network.request(url, method: .get, encoding: JSONEncoding.default, headers: Device.headers).parse()
        let result = response.result
        if result.isFailure {
            throw result.error!
        }
        let dataSet = result.value!
        return dataSet
    }
    
    static func obter() throws -> ProcessoModel {
        let url = "\(Config.restURL)/processo/criar"
        let response: DataResponse<ProcessoModel> = try Network.request(url, method: .get, encoding: JSONEncoding.default, headers: Device.headers).parse()
        let result = response.result
        if result.isFailure {
            throw result.error!
        }
        let model = result.value!
        return model
    }
    
    class Async {
        
        static func obter() -> Observable<ProcessoModel> {
            return Observable.create { observer in
                do {
                    let model = try ProcessoService.obter()
                    observer.onNext(model)
                    observer.onCompleted()
                } catch {
                    observer.onError(error)
                }
                return Disposables.create()
            }
        }
        
        static func editar(_ id: Int) -> Observable<DataSet<ProcessoModel, ProcessoRegraModel>> {
            return Observable.create { observer in
                do {
                    let dataSet = try ProcessoService.editar(id)
                    observer.onNext(dataSet)
                    observer.onCompleted()
                } catch {
                    observer.onError(error)
                }
                return Disposables.create()
            }
        }
        
        static func aprovar(_ id: Int, model: TransferenciaModel) -> Observable<DataSet<ProcessoModel, ProcessoRegraModel>> {
            return Observable.create { observer in
                do {
                    let dataSet = try ProcessoService.aprovar(id, model: model)
                    observer.onNext(dataSet)
                    observer.onCompleted()
                } catch {
                    observer.onError(error)
                }
                return Disposables.create()
            }
        }
        
        static func cancelar(_ id: Int) -> Observable<DataSet<ProcessoModel, ProcessoRegraModel>> {
            return Observable.create { observer in
                do {
                    let dataSet = try ProcessoService.cancelar(id)
                    observer.onNext(dataSet)
                    observer.onCompleted()
                } catch {
                    observer.onError(error)
                }
                return Disposables.create()
            }
        }
        
        static func salvar(_ model: ProcessoModel) -> Observable<ProcessoModel> {
            return Observable.create { observer in
                do {
                    let model = try ProcessoService.salvar(model)
                    observer.onNext(model)
                    observer.onCompleted()
                } catch {
                    observer.onError(error)
                }
                return Disposables.create()
            }
        }
    }
}
