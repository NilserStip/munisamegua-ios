//
//  BaseViewController.swift
//  Seguridad Veintiseis
//
//  Created by Andres Moreno on 11/26/19.
//  Copyright © 2019 uc-web. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyUserDefaults
import TTGSnackbar

class BaseViewController: UIViewController {
    
    let headers: HTTPHeaders = [
        "Authorization": Defaults.authorization,
        "Accept": "application/json",
        "Content-Type": "application/json"
    ]
    let snackbar = TTGSnackbar()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set SnackBar Confirmation
        snackbar.animationType = .slideFromBottomBackToBottom
        snackbar.duration = .middle
        snackbar.leftMargin = 0
        snackbar.bottomMargin = 0
        snackbar.rightMargin = 0
        snackbar.cornerRadius = 0
        snackbar.messageTextColor = .white
        snackbar.messageTextFont = .systemFont(ofSize: 13)        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func showInfoDialog(_ vc: UIViewController, _ message: String) -> Void {
        let dialog = UIAlertController(title: FlavorSetting.appName, message: message, preferredStyle: .alert)
        let actionPositive = UIAlertAction(title: "Aceptar", style: .default)
        //dialog.view.tintColor = Colors.
        dialog.addAction(actionPositive)
        vc.present(dialog, animated: true, completion: nil)
    }
    
    func showActionDialog(_ vc: UIViewController, okTitle: String = "Aceptar", message: String, action:(()->())?){
        let dialog = UIAlertController(title: FlavorSetting.appName, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: okTitle, style: .default) { (ok) in
            action?()
        }
        dialog.addAction(okAction)
        vc.present(dialog, animated: true, completion: nil)
    }
    
    func showDestructiveDialog(_ vc: UIViewController, destructiveTitle: String, cancelTitle: String = "Cancelar", message: String, action:(()->())?){
        let dialog = UIAlertController(title: FlavorSetting.appName, message: message, preferredStyle: .alert)
        let destructiveAction = UIAlertAction(title: destructiveTitle, style: .destructive) { (ok) in
            action?()
        }
        let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel)
        dialog.addAction(cancelAction)
        dialog.addAction(destructiveAction)
        vc.present(dialog, animated: true, completion: nil)
    }

    func showDefaultActionDialog(_ vc: UIViewController, actionTitle: String, cancelTitle: String = "Cancelar", message: String, action:(()->())?){
        let dialog = UIAlertController(title: FlavorSetting.appName, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: actionTitle, style: .default) { (ok) in
            action?()
        }
        let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel)
        dialog.addAction(cancelAction)
        dialog.addAction(defaultAction)
        vc.present(dialog, animated: true, completion: nil)
    }

    func logout(){
        Defaults.session = false
        dismiss(animated: false, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !Defaults.session {
            dismiss(animated: false, completion: nil)
        }
    }
    
    func showSnackBar(_ message: String, _ type: SnackType){
        switch type {
        case .positive:
            snackbar.backgroundColor = Colors.snackPositive
        case .negative:
            snackbar.backgroundColor = Colors.snackNegative
        case .neutral:
            snackbar.backgroundColor = Colors.snackNeutral
        }
        snackbar.message = message
        snackbar.show()
    }
}
