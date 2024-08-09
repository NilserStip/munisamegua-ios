//
//  PasswordResetVC.swift
//  Seguridad Veintiseis
//
//  Created by Andres Moreno on 11/26/19.
//  Copyright © 2019 uc-web. All rights reserved.
//

import UIKit
import TransitionButton
import Alamofire
import SkyFloatingLabelTextField

class PasswordResetVC: BaseViewController {

    @IBOutlet weak var successView: UIView!
    @IBOutlet weak var tfEmail: SkyFloatingLabelTextField!
    @IBOutlet weak var btnResetPassword: TransitionButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func btnBack(_ sender: Any) {
        dismissKeyboard()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnResetPassword(_ sender: Any) {
        dismissKeyboard()
        if validateFields() {
            requestPasswordReset(email: tfEmail.trim())
        }
    }
    
    
    func validateFields() -> Bool {
        tfEmail.errorMessage = nil
        if !tfEmail.isValidEmail() {
            tfEmail.errorMessage = R.string.error_input_email
            tfEmail.setError()
            return false
        }
        return true
    }
    
    func requestPasswordReset(email: String){
        if Connectivity.isConnected(self) {
            btnResetPassword.startAnimation()
            AF.upload(multipartFormData: { multipartFormData in
                multipartFormData.append(Data(email.utf8), withName: "email")
            }, to: Url.passwordReset, headers: headers)
                .responseJSON { response in
                    self.btnResetPassword.stopAnimation()
                    debugPrint(response)
                    switch response.response?.statusCode {
                        case 200:
                            self.view.bringSubviewToFront(self.successView)
                         default:
                         self.showInfoDialog(self, R.string.error_api)
                     }
                }
            
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //
    }
}
