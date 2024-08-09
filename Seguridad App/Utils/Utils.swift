//
//  Utils.swift
//  Seguridad Veintiseis
//
//  Created by Andres Moreno on 1/16/20.
//  Copyright © 2020 uc-web. All rights reserved.
//

import Foundation
import UIKit

public class Util {
    static func makeCall(vc: UIViewController, phone: String) -> Void {
        if #available(iOS 10.0, *) {
            if let url = URL(string: "tel://\(phone)") {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }else{
            let aURL = NSURL(string: "tel://\(phone)")
            if UIApplication.shared.canOpenURL(aURL! as URL) {
                UIApplication.shared.openURL(aURL! as URL)
            } else {
                let dialog = UIAlertController(title: FlavorSetting.appName, message: "No se ha podido completar la llamada", preferredStyle: .alert)
                let actionPositive = UIAlertAction(title: "Aceptar", style: .default) {
                    (alert: UIAlertAction!) in
                }
                dialog.addAction(actionPositive)
                vc.present(dialog, animated: true, completion: nil)
            }
        }
    }    
    
    static func openUrl(_ strUrl: String){
        if let url = URL(string: strUrl) {
            UIApplication.shared.open(url, options: [:])
        }
    }
}
