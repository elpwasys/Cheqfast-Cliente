//
//  TermoViewController.swift
//  Cliente
//
//  Created by Everton Luiz Pascke on 07/09/17.
//  Copyright © 2017 Wasys. All rights reserved.
//

import UIKit

class TermoViewController: DrawerViewController {

    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepare()
    }
}

extension TermoViewController {
    
    fileprivate func prepare() {
        webView.delegate = self
        if let url = URL(string: "\(Config.baseURL)/termo.html") {
            let request = URLRequest(url: url)
            webView.loadRequest(request)
        }
    }
}


extension TermoViewController: UIWebViewDelegate {
    
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
