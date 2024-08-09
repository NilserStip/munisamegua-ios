//
//  PasswordUpdateVC.swift
//  Seguridad Veintiseis
//
//  Created by Andres Moreno on 1/16/20.
//  Copyright © 2020 uc-web. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import Alamofire
import SwiftyUserDefaults
import TransitionButton

class PasswordUpdateVC: BaseViewController {

    
    @IBOutlet weak var tfPassword: SkyFloatingLabelTextField!
    @IBOutlet weak var tfPasswordConfirm: SkyFloatingLabelTextField!
    @IBOutlet weak var successView: UIView!
    @IBOutlet weak var btnSend: TransitionButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func btnBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnSend(_ sender: Any) {
        dismissKeyboard()
        if validateFields() {
            requestPasswordUpdate(newPassword: tfPassword.trim())
        }
    }
    
    
    
    func requestPasswordUpdate(newPassword: String){
        if Connectivity.isConnected(self) {
            btnSend.startAnimation()
            AF.upload(multipartFormData: { multipartFormData in
                multipartFormData.append(Data(newPassword.utf8), withName: "newPassword")
            }, to: Url.passwordUpdate, headers: headers)
                .responseJSON { response in
                    self.btnSend.stopAnimation()
                    debugPrint(response)
                    switch response.response?.statusCode {
                        case 201:
                            self.view.bringSubviewToFront(self.successView)
                         case 401:
                            self.showActionDialog(self, message: R.string.error_session, action: {
                                self.logout()
                            })
                         default:
                         self.showInfoDialog(self, R.string.error_api)
                     }
                }
            
        }
    }
    
    func validateFields() -> Bool {
        tfPassword.errorMessage = nil
        tfPasswordConfirm.errorMessage = nil
        if !tfPassword.isValidPassword() {
            tfPassword.errorMessage = "Mínimo 6 caracteres"
            tfPassword.setError()
            return false
        }
        if tfPassword.trim() != tfPasswordConfirm.trim(){
            tfPasswordConfirm.errorMessage = "Las contraseñas deben coincidir"
            tfPasswordConfirm.setError()
            return false
        }
        return true
    }
    
    
}
