//
//  AppDelegate.swift
//  Cliente
//
//  Created by Everton Luiz Pascke on 10/09/17.
//  Copyright © 2017 Wasys. All rights reserved.
//

import UIKit

import UIKit
import MaterialComponents
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        IQKeyboardManager.sharedManager().enable = true
        let color = Color.primary
        //UILabel.appearance().textColor = MDCPalette.grey.tint700
        UINavigationBar.appearance().barTintColor = color
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        MDCRaisedButton.appearance().backgroundColor = Color.primary
        MDCRaisedButton.appearance().customTitleColor = UIColor.white
        
        return true
    }
}
