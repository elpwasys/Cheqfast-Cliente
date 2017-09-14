//
//  CredencialModel.swift
//  Cliente
//
//  Created by Everton Luiz Pascke on 07/09/17.
//  Copyright © 2017 Wasys. All rights reserved.
//

import Foundation

class CredencialModel {
    
    let login: String
    let senha: String
    
    var dictionary: [String: Any] {
        return [
            "login": login,
            "senha": senha
        ]
    }
    
    init(login: String, senha: String) {
        self.login = login
        self.senha = senha
    }
}
