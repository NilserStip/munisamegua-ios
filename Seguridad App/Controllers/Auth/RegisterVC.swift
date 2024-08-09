//
//  RegisterVC.swift
//  Seguridad Veintiseis
//
//  Created by Andres Moreno on 11/26/19.
//  Copyright © 2019 uc-web. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import Alamofire
import ActiveLabel
import TransitionButton

class RegisterVC: BaseViewController {

    //Outlets
    @IBOutlet weak var tfFirstName: SkyFloatingLabelTextField!
    @IBOutlet weak var tfLastName: SkyFloatingLabelTextField!
    @IBOutlet weak var tfEmail: SkyFloatingLabelTextField!
    @IBOutlet weak var tfPhone: SkyFloatingLabelTextField!
    @IBOutlet weak var tfAddress: SkyFloatingLabelTextField!
    @IBOutlet weak var tfPassword: SkyFloatingLabelTextField!
    @IBOutlet weak var tfPasswordConfirm: SkyFloatingLabelTextField!
    
    @IBOutlet weak var lblAgreement: ActiveLabel!
    @IBOutlet weak var btnRegister: TransitionButton!
    
    var registerDelegate: RegisterDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnRegister.applyButtonShadow()
        setActiveLabel()
        setDemo()
        
    }
    @IBAction func btnBack(_ sender: Any) {
        dismissKeyboard()
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    func setDemo(){
        if Config.isDemo {
            tfFirstName.text = "iOS user"
            tfLastName.text = "demo"
            tfEmail.text = "user@mail.com"
            tfPhone.text = "999666999"
            tfPassword.text = "654321"
            tfPasswordConfirm.text = "654321"
        }
    }
    
    @IBAction func btnRegister(_ sender: Any) {
        dismissKeyboard()
        if validateFields() {
            let account = Account(email: tfEmail.trim(),
                                  firstName: tfFirstName.trim(),
                                  lastName: tfLastName.trim(),
                                  password: tfPassword.trim(),
                                  user: User(phone: tfPhone.trim(),
                                             type: "CITIZEN",
                                             address: tfAddress.trim()))
            requestRegister(account: account)
        }
    }
    
    func requestRegister(account: Account){
        if Connectivity.isConnected(self) {
            btnRegister.startAnimation()
            AF.request(Url.register,
                       method: .post,
                       parameters: account,
                       encoder: JSONParameterEncoder.default,
                       headers: headers).responseDecodable(of: ResponseModel<Account>.self) { response in
                       switch response.response?.statusCode {
                           case 201:
                           self.btnRegister.stopAnimation(animationStyle: .normal, revertAfterDelay: 0.0)
                           switch response.result {
                               case .success(let value):
                                   print("amd: \(value.data!)")
                                    self.dismiss(animated: true, completion: {
                                        self.registerDelegate?.didRegister(credentials: Credentials(email: account.email, password: account.password!, device: Config.device))
                                    })
                                
                               case .failure(let error):
                                   print(error)
                               }
                           case 400:
                           self.btnRegister.stopAnimation(animationStyle: .shake, revertAfterDelay: 0.0)
                           switch response.result {
                               case .success(let value):
                                   self.showInfoDialog(self, value.message!)
                               case .failure(let error):
                                   print(error)
                               }
                            default:
                            self.btnRegister.stopAnimation(animationStyle: .shake, revertAfterDelay: 0.0)
                            self.showInfoDialog(self, R.string.error_api)
                            }
            }
        }
    }
    
    
    
    func setActiveLabel(){
        let activeTypeTerms = ActiveType.custom(pattern: "\\bTérminos de Uso\\b")
        let activeTypePrivacy = ActiveType.custom(pattern: "\\bPolítica de Privacidad\\b")
        
        lblAgreement.enabledTypes.append(activeTypeTerms)
        lblAgreement.enabledTypes.append(activeTypePrivacy)
        
        lblAgreement.customize { label in
            //Custom types
            lblAgreement.customColor[activeTypeTerms] = Colors.primaryColor
            lblAgreement.customColor[activeTypePrivacy] = Colors.primaryColor
            lblAgreement.configureLinkAttribute = { (type, attributes, isSelected) in
                var atts = attributes
                atts[NSAttributedString.Key.underlineStyle] = NSUnderlineStyle.single.rawValue
                return atts
            }
            
            lblAgreement.handleCustomTap(for: activeTypeTerms) { _ in
                self.performSegue(withIdentifier: "RegisterToAgreement", sender: AgreementType.termsOfUse)
            }
            lblAgreement.handleCustomTap(for: activeTypePrivacy) { _ in
                self.performSegue(withIdentifier: "RegisterToAgreement", sender: AgreementType.privacyPolicy)
            }
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "RegisterToAgreement"{
            if let vc = segue.destination as? AgreementVC {
                
                let agreementType = sender as! Int
        
                if agreementType == AgreementType.termsOfUse {
                    vc.agreementUrl = Url.terms_of_use
                    vc.agreementTitle = "Términos de Uso"
                }else if agreementType == AgreementType.privacyPolicy {
                    vc.agreementUrl = Url.privacy_policy
                    vc.agreementTitle = "Política de Privacidad"
                }
            }
        }
        if segue.identifier == "RegisterToPhoneValidation" {
            if let vc = segue.destination as? PhoneValidationVC {
                /*vc.mPhoneNumber = txtPhone.text?.trim()
                vc.delegate = self*/
            }
        }
    }
    
    func validateFields() -> Bool {
        tfFirstName.errorMessage = nil
        tfLastName.errorMessage = nil
        tfEmail.errorMessage = nil
        tfPhone.errorMessage = nil
        tfPassword.errorMessage = nil
        tfPasswordConfirm.errorMessage = nil
        
        if !tfFirstName.isValidName() {
            tfFirstName.errorMessage = R.string.error_input_name
            tfFirstName.setError(shouldFocus: true)
            return false
        }
        if !tfLastName.isValidName() {
            tfLastName.errorMessage = R.string.error_input_name
            tfLastName.setError(shouldFocus: true)
            return false
        }
        if !tfEmail.isValidEmail() {
            tfEmail.errorMessage = R.string.error_input_email
            tfEmail.setError(shouldFocus: true)
            return false
        }
        if !tfPhone.isValidPhone() {
            tfPhone.errorMessage = R.string.error_input_phone
            tfPhone.setError(shouldFocus: true)
            return false
        }
        if !tfPassword.isValidPassword() {
            tfPassword.errorMessage = R.string.error_input_password
            tfPassword.setError(shouldFocus: true)
            return false
        }
        if tfPasswordConfirm.trim() != tfPassword.trim() {
            tfPasswordConfirm.errorMessage = R.string.error_input_password_confirm
            tfPasswordConfirm.setError(shouldFocus: true)
            return false
        }
        return true
    }
}
