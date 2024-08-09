//
//  LoginVC.swift
//  Seguridad Veintiseis
//
//  Created by Andres Moreno on 11/26/19.
//  Copyright © 2019 uc-web. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyUserDefaults
import SkyFloatingLabelTextField
import TransitionButton

class LoginVC: BaseViewController, RegisterDelegate {
    
    //Outlets
    @IBOutlet weak var lblVersion: UILabel!
    @IBOutlet weak var lblLoginTitle: UILabel!
    @IBOutlet weak var tfEmail: SkyFloatingLabelTextField!
    @IBOutlet weak var tfPassword: SkyFloatingLabelTextField!
    @IBOutlet weak var btnLogin: TransitionButton!
    @IBOutlet weak var btnRegister: OvalView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.alpha = 0
        setDemo()
        lblVersion.text = "v\(Config.appVersion)"
        lblLoginTitle.text = FlavorSetting.loginTitle.uppercased()
    }
    override func viewDidAppear(_ animated: Bool) {
        //super.viewDidAppear(animated)
        if  Defaults.session {
            self.performSegue(withIdentifier: "LoginToMain", sender: nil)
        }else {
            self.view.alpha = 1
        }
        btnRegister.isHidden = false
        btnLogin.applyButtonShadow()
    }
    
    func setDemo(){
        if Config.isDemo {
            tfEmail.text = "user@mail.com"
            tfPassword.text = "654321"
        }
    }
    
    @IBAction func btnForgotPassword(_ sender: Any) {
        performSegue(withIdentifier: "LoginToPasswordReset", sender: nil)
    }
    
    @IBAction func btnLogin(_ sender: Any) {
        dismissKeyboard()
        if validateFields() {
            requestLogin(credentials:
                Credentials(email: tfEmail.trim(),
                            password: tfPassword.trim(),
                            device: Config.device))
        }
    }
    @IBAction func btnRegister(_ sender: Any) {
        performSegue(withIdentifier: "LoginToRegister", sender: nil)
    }
    
    func validateFields() -> Bool {
        tfEmail.errorMessage = nil
        tfPassword.errorMessage = nil
        if !tfEmail.isValidEmail() {
            tfEmail.errorMessage = R.string.error_input_email
            tfEmail.setError()
            return false
        }
        if !tfPassword.isValidPassword() {
            tfPassword.errorMessage = R.string.error_input_password
            tfPassword.setError()
            return false
        }
        return true
    }
    
    
    func requestLogin(credentials: Credentials){
        if Connectivity.isConnected(self) {
            btnLogin.startAnimation()
            AF.request(Url.login,
                       method: .post,
                       parameters: credentials,
                       encoder: JSONParameterEncoder.default,
                       headers: headers).responseDecodable(of: ResponseModel<Account>.self) { response in
                       switch response.response?.statusCode {
                           case 200:
                           self.btnRegister.isHidden = true
                           self.btnLogin.stopAnimation(animationStyle: .expand, revertAfterDelay: 2.0)
                               switch response.result {
                               case .success(let value):
                                   Defaults.authorization = response.response?.allHeaderFields["Authorization"] as! String
                                   Defaults.session = true
                                   Defaults.username = value.data!.firstName
                                   Defaults.phone = (value.data?.user.phone)!
                                   Defaults.darkMap = false
                                   
                                   print("amd: \(value.data!)")
                                   
                                   self.tfEmail.text = ""
                                   self.tfPassword.text = ""
                                   self.performSegue(withIdentifier: "LoginToMain", sender: nil)
                                  
                               case .failure(let error):
                                   print(error)
                               }
                            case 401:
                                self.btnLogin.stopAnimation(animationStyle: .shake, revertAfterDelay: 0.0)
                            self.showInfoDialog(self, R.string.error_login)
                            case 403:
                            self.btnLogin.stopAnimation(animationStyle: .shake, revertAfterDelay: 0.0)
                            self.showInfoDialog(self, R.string.error_unauthorized)
                            default:
                            self.btnLogin.stopAnimation(animationStyle: .shake, revertAfterDelay: 0.0)
                            self.showInfoDialog(self, R.string.error_api)
                            }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LoginToRegister" {
            let vc = segue.destination as? RegisterVC
                vc?.registerDelegate = self
        }
    }
    
    func didRegister(credentials: Credentials) {
        requestLogin(credentials: credentials)
    }
}
