//
//  ClienteService.swift
//  Cliente
//
//  Created by Everton Luiz Pascke on 10/09/17.
//  Copyright © 2017 Wasys. All rights reserved.
//

import Foundation

import RxSwift
import Alamofire

class ClienteService: Service {
    
    static func obter() throws -> ProcessoModel {
        let url = "\(Config.restURL)/cliente/obter"
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
                    let model = try ClienteService.obter()
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
