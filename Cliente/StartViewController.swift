//
//  StartViewController.swift
//  Cliente
//
//  Created by Everton Luiz Pascke on 07/09/17.
//  Copyright © 2017 Wasys. All rights reserved.
//

import UIKit

class StartViewController: CheqfastViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        decideScene()
    }
}

extension StartViewController {
    
    fileprivate func decideScene() {
        let controller: UIViewController
        if Dispositivo.current == nil {
            controller = UIStoryboard.viewController("Main", identifier: "Nav.Login")
        } else {
            controller = UIStoryboard.viewController("Menu", identifier: "Scene.Reveal")
            controller.modalTransitionStyle = .crossDissolve
        }
        self.present(controller, animated: true, completion: nil)
    }
}
