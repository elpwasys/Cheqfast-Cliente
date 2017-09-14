//
//  NumberUtils.swift
//  AppKit
//
//  Created by Everton Luiz Pascke on 17/11/16.
//  Copyright © 2016 Everton Luiz Pascke. All rights reserved.
//

import Foundation

public class NumberUtils {
    
    static var formatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = nil
        formatter.currencySymbol = ""
        formatter.locale = Locale(identifier: "pt_BR")
        return formatter
    }
    
    public static func format(_ value: Float) -> String? {
        let number = NSNumber.init(value: value)
        return format(number)
    }
    
    public static func format(_ value: Double) -> String? {
        let number = NSNumber.init(value: value)
        return format(number)
    }
    
    public static func format(_ value: NSNumber) -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = App.locale
        return formatter.string(from: value)
    }
    
    static func parse(_ value: String) -> Double? {
        return formatter.number(from: value)?.doubleValue
    }
    
    static func parse(_ value: String?) -> Int? {
        guard let text = value else {
            return nil
        }
        return Int(text)
    }
}
