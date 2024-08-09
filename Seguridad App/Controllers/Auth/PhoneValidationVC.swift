//
//  PhoneValidationVC.swift
//  Seguridad Veintiseis
//
//  Created by Andres Moreno on 11/26/19.
//  Copyright © 2019 uc-web. All rights reserved.
//

import UIKit
// import FirebaseAuth

class PhoneValidationVC: BaseViewController {
    
    //IMPORTANTE: este controlador no ha sido probado. Solo se ha transferido del ejemplo de BikerCab, se dejo en espera por no contar con una cuenta de Apple aun para generar la llave p12 para Firebase
    
    var delegate: PhoneValidationDelegate? = nil
    
    // Outlets
    @IBOutlet weak var viewSMSSend: UIView!
    @IBOutlet weak var lblPhoneNumber: UILabel!
    @IBOutlet weak var viewSMSValidate: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var txtSMSCode: UITextField!
    
    // Variables
    var mPhoneNumber: String?
    var mVerificationId: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        viewSMSSend.isHidden = false
        viewSMSValidate.isHidden = true
        lblPhoneNumber.text = mPhoneNumber
        lblTitle.text = "Ingresa el código de 6 dígitos enviado al \(mPhoneNumber!)"

        // Do any additional setup after loading the view.
    }
    @IBAction func btnBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnSendSMS(_ sender: Any) {
        dismissKeyboard()
        Loader.start(view)
//        Auth.auth().languageCode = "es";
//        PhoneAuthProvider.provider().verifyPhoneNumber("+51\(mPhoneNumber!)", uiDelegate: nil) { (verificationID, error) in
//            Loader.stop()
//            if let error = error {
//                print(error.localizedDescription)
//                self.showInfoDialog(self, "Lo sentimos, algo salió mal. Por favor verifique el número y vuelva a intentarlo.")
//                return
//            }
//            // Sign in using the verificationID and the code sent to the user
//            self.mVerificationId = verificationID
//            self.viewSMSSend.isHidden = true
//            self.viewSMSValidate.isHidden = false
//        }
    }
    
    @IBAction func btnValidateSMS(_ sender: Any) {
        dismissKeyboard()
        if txtSMSCode.trim().count > 5 {
            Loader.start(view)
//            let credential = PhoneAuthProvider.provider().credential(
//                withVerificationID: mVerificationId!,
//                verificationCode: txtSMSCode.trim())
//            
//            Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
//                Loader.stop()
//                if let error = error {
//                    print(error.localizedDescription)
//                    self.showInfoDialog(self, "El código ingresado no es válido")
//                    return
//                }
//                self.dismiss(animated: true, completion: {
//                    self.delegate?.didValidatePhone()
//                })
//            }
        } else {
            //txtSMSCode.shake()
            //showSnackBar("Faltan dígitos")
            self.showInfoDialog(self, "Faltan dígitos")
        }
        
    }
}
