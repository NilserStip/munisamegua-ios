//
//  AgreementVC.swift
//  Seguridad Veintiseis
//
//  Created by Andres Moreno on 1/21/20.
//  Copyright © 2020 uc-web. All rights reserved.
//

import UIKit
import WebKit

class AgreementVC: BaseViewController {
    
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var webView: WKWebView!
    var agreementUrl = ""
    var agreementTitle = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navBar.topItem?.title = agreementTitle
        if agreementUrl != "" {
            let url = URL(string: agreementUrl)
            webView.load(URLRequest(url: url!))
        }
    }
    
    @IBAction func btnBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    override func viewDidAppear(_ animated: Bool) {
        //
    }
}
