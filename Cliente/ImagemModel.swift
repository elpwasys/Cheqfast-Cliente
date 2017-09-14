//
//  ImagemModel.swift
//  Cetelem
//
//  Created by Everton Luiz Pascke on 26/07/17.
//  Copyright © 2017 Wasys Technology. All rights reserved.
//

import Foundation
import ObjectMapper

class ImagemModel: Model {
    
    var path: String?
    var nome: String?
    var caminho: String!
    
    var cache: Bool?
    var versao: Int!
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        path <- map["path"]
        nome <- map["nome"]
        caminho <- map["caminho"]
        cache <- map["cache"]
        versao <- map["versao"]
    }
}
