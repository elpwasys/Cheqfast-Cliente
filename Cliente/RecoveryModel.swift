//
//  RecoveryModel.swift
//  Cliente
//
//  Created by Everton Luiz Pascke on 07/09/17.
//  Copyright © 2017 Wasys. All rights reserved.
//

import Foundation

class RecoveryModel {
    
    let email: String
    
    var dictionary: [String: Any] {
        return [
            "email": email
        ]
    }
    
    init(email: String) {
        self.email = email
    }
}
