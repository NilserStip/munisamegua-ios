//
//  CommentVC.swift
//  Seguridad Veintiseis
//
//  Created by Andres Moreno on 1/16/20.
//  Copyright © 2020 uc-web. All rights reserved.
//

import UIKit
import TransitionButton
import SkyFloatingLabelTextField
import Alamofire

class CommentVC: BaseViewController, UINavigationControllerDelegate, UITextViewDelegate, SubjectDelegate {
    
    var subjects = [Subject]()
    var subject: Subject?
    var comment: Comment?
    
    
    @IBOutlet weak var svInput: UIScrollView!
    @IBOutlet weak var successView: UIView!
    
    @IBOutlet weak var tfSubject: SkyFloatingLabelTextField!
    @IBOutlet weak var tvComment: UITextView!
    @IBOutlet weak var btnSend: TransitionButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tvComment.delegate = self
        tvComment.text = "Escriba un comentario"
        btnSend.applyButtonShadow()
    }
    
    @IBAction func btnBack(_ sender: Any) {
        dismissKeyboard()
        dismiss(animated: true, completion: nil)
    }
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if tvComment.isFirstResponder {
            tvComment.text = nil
            tvComment.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if tvComment.text.isEmpty || tvComment.text == "" {
            tvComment.textColor = .lightGray
            tvComment.text = R.string.comment_comment_input
        }
    }
    @IBAction func btnSend(_ sender: Any) {
        dismissKeyboard()
        if validateFields() {
            requestComment(Comment(description: tvComment.text, subject: subject!))
        }
    }
    
    
    func validateFields() -> Bool {
        if subject == nil {
            showInfoDialog(self, "Seleccione un tema")
            return false
        }
        if tvComment.trim() == R.string.comment_comment_input || tvComment.trim().isEmpty {
            showInfoDialog(self, R.string.comment_comment_input)
            return false
        }
        return true
    }
    
    
    @IBAction func btnSubject(_ sender: Any) {
        performSegue(withIdentifier: "CommentToSubject", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CommentToSubject"{
            let vc = segue.destination as! SubjectVC
            vc.delegate = self
        }
    }
    
    func didSelect(subject: Subject) {
        self.subject = subject
        tfSubject.text = subject.description
    }
    
    
    func requestComment(_ comment: Comment){
        if Connectivity.isConnected(self) {
            btnSend.startAnimation()
            AF.request(Url.comment,
                       method: .post,
                       parameters: comment,
                       encoder: JSONParameterEncoder.default,
                       headers: headers).responseDecodable(of: ResponseModel<Comment>.self) { response in

                        self.btnSend.stopAnimation()
                        switch response.response?.statusCode {
                            case 200:
                                self.svInput.isHidden = true
                            case 401:
                                self.logout()
                            default:
                                self.showInfoDialog(self, R.string.error_api)
                        }
            }
        }
    }
}
