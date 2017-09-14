//
//  DispositivoService.swift
//  Cliente
//
//  Created by Everton Luiz Pascke on 07/09/17.
//  Copyright © 2017 Wasys. All rights reserved.
//

import Foundation

import RxSwift
import Alamofire

class DispositivoService: Service {
    
    static func recuperar(_ model: RecoveryModel) throws -> ResultModel {
        let url = "\(Config.restURL)/dispositivo/recuperar"
        let parameters = model.dictionary;
        let response: DataResponse<ResultModel> = try Network.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: Device.headers).parse()
        let result = response.result
        if result.isFailure {
            throw result.error!
        }
        let model = result.value!
        return model
    }
    
    static func autenticar(_ model: CredencialModel) throws -> Dispositivo {
        let url = "\(Config.restURL)/dispositivo/autenticar"
        let parameters = model.dictionary;
        let response: DataResponse<Dispositivo> = try Network.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: Device.headers).parse()
        let result = response.result
        if result.isFailure {
            throw result.error!
        }
        let dispositivo = result.value!
        return dispositivo
    }
    
    class Async {
        
        static func recuperar(_ model: RecoveryModel) -> Observable<ResultModel> {
            return Observable.create { observer in
                do {
                    let dispositivo = try DispositivoService.recuperar(model)
                    observer.onNext(dispositivo)
                    observer.onCompleted()
                } catch {
                    observer.onError(error)
                }
                return Disposables.create()
            }
        }
        
        static func autenticar(_ model: CredencialModel) -> Observable<Dispositivo> {
            return Observable.create { observer in
                do {
                    let dispositivo = try DispositivoService.autenticar(model)
                    observer.onNext(dispositivo)
                    observer.onCompleted()
                } catch {
                    observer.onError(error)
                }
                return Disposables.create()
            }
        }
    }
}
