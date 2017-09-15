//
//  TransferenciaService.swift
//  Cliente
//
//  Created by Everton Luiz Pascke on 15/09/17.
//  Copyright © 2017 Wasys. All rights reserved.
//

import Foundation

import RxSwift
import Alamofire

class TransferenciaService: Service {
    
    static func obter(_ id: Int) throws -> TransferenciaModel {
        let url = "\(Config.restURL)/transferencia/obter/\(id)"
        let response: DataResponse<TransferenciaModel> = try Network.request(url, method: .get, encoding: JSONEncoding.default, headers: Device.headers).parse()
        let result = response.result
        if result.isFailure {
            throw result.error!
        }
        let model = result.value!
        return model
    }
    
    class Async {
        
        static func obter(_ id: Int) -> Observable<TransferenciaModel> {
            return Observable.create { observer in
                do {
                    let model = try TransferenciaService.obter(id)
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
