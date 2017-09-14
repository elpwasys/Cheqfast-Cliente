//
//  PesquisaService.swift
//  Cliente
//
//  Created by Everton Luiz Pascke on 10/09/17.
//  Copyright © 2017 Wasys. All rights reserved.
//

import Foundation

import RxSwift
import Alamofire

class PesquisaService: Service {
    
    static func filtrar(model: PesquisaModel) throws -> ProcessoPagingModel {
        let url = "\(Config.restURL)/pesquisa/filtrar"
        let response: DataResponse<ProcessoPagingModel> = try Network.request(url, method: .post, parameters: model.parameters, encoding: JSONEncoding.default, headers: Device.headers).parse()
        let result = response.result
        if result.isFailure {
            throw result.error!
        }
        let model = result.value!
        return model
    }
    
    class Async {
        
        static func filtrar(model: PesquisaModel) -> Observable<ProcessoPagingModel> {
            return Observable.create { observer in
                do {
                    let model = try PesquisaService.filtrar(model: model)
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
