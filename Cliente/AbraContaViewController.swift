//
//  AbraContaViewController.swift
//  Cliente
//
//  Created by Everton Luiz Pascke on 07/09/17.
//  Copyright © 2017 Wasys. All rights reserved.
//

import UIKit

class AbraContaViewController: CheqfastViewController {

    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepare()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }
}

extension AbraContaViewController {
    
    fileprivate func prepare() {
        webView.delegate = self
        if let url = URL(string: "\(Config.baseURL)/abra-sua-conta/") {
            let request = URLRequest(url: url)
            webView.loadRequest(request)
        }
    }
}


extension AbraContaViewController: UIWebViewDelegate {
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        showActivityIndicator()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        hideActivityIndicator()
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        hideActivityIndicator()
        handle(error)
    }
}
