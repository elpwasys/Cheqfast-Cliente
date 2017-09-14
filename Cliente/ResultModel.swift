//
//  ResultModel.swift
//  Cliente
//
//  Created by Everton Luiz Pascke on 07/09/17.
//  Copyright © 2017 Wasys. All rights reserved.
//

import Foundation
import ObjectMapper

class ResultModel: Model {
    
    var success: Bool?
    var messages: [String]?
    
    var isSuccess: Bool {
        return self.success ?? false
    }
    
    var message: String? {
        guard let messages = self.messages else {
            return nil
        }
        return messages.joined(separator: ", ")
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        success <- map["success"]
        messages <- map["messages"]
    }
}
