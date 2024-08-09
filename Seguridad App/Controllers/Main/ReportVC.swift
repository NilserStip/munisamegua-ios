//
//  ReportVC.swift
//  Seguridad Veintiseis
//
//  Created by Andres Moreno on 1/13/20.
//  Copyright © 2020 uc-web. All rights reserved.
//

import UIKit
import SwiftyUserDefaults
import TransitionButton
import Alamofire

class ReportVC: BaseViewController, UITextViewDelegate, IncidenceDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var report: Report?
    
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var btnBack: UIBarButtonItem!
    
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var ivStatus: UIImageView!
    @IBOutlet weak var lblMessage: UILabel!
    
    @IBOutlet weak var formView: UIView!
    @IBOutlet weak var lcFormHeight: NSLayoutConstraint!
    
    @IBOutlet weak var incidenceView: UIView!
    @IBOutlet weak var lblIncidence: UILabel!
    
    @IBOutlet weak var attachmentView: UIView!
    @IBOutlet weak var lblAttachment: UILabel!
    
    @IBOutlet weak var tvComment: UITextView!
    
    let picker = UIImagePickerController()
    var imageData: Data?
    
    @IBOutlet weak var btnSend: TransitionButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tvComment.textColor = .lightGray
        tvComment.text = "Haga un comentario (opcional)"
        showDefault()
        
        if report == nil {
            dismiss(animated: false, completion: nil)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        incidenceView.applyShadow()
        attachmentView.applyShadow()
        btnSend.applyButtonShadow()
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
            tvComment.text = "Haga un comentario (opcional)"
        }
    }
    
    @IBAction func btnSend(_ sender: Any) {
        dismissKeyboard()
        if btnSend.backgroundColor == Colors.green {
            dismiss(animated: true, completion: nil)
        } else if validateFields() {
            var comment: String?
            if tvComment.trim() != R.string.report_comment_input && !tvComment.trim().isEmpty {
                comment = tvComment.trim()
            }
            requestDetail(report: report!, file: imageData, comment: comment)
        }
    }
    
    func showSuccess() {
        btnBack.isEnabled = true
        btnBack.tintColor = .white
        lblStatus.text = "Su alerta esta siendo\nprocesada por nuestra\ncentral".uppercased()
        lblMessage.text = "Un oficial evaluará la situación. En caso sea necesario nos comunicaremos con usted al \(Defaults.phone)"
        formView.isHidden = true
        lcFormHeight.constant = 0.0
        btnSend.isHidden = false
        btnSend.backgroundColor = Colors.green
        btnSend.setTitle("Aceptar", for: .normal)
        navBar.topItem?.title = "Alerta enviada"
        ivStatus.image = UIImage(named: "img_agent_green")
    }
    func showIntermediate() {
        ivStatus.image = UIImage(named: "img_agent_gray")
        lblStatus.text = "CARGANDO..."
        lblMessage.text = "¡Por favor, espere!"
        formView.isHidden = true
        btnSend.isHidden = true
        lcFormHeight.constant = 0.0
    }
    
    @IBAction func btnBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func showDefault() {
        btnBack.isEnabled = false
        btnBack.tintColor = .clear
        lblStatus.text = "Mantenga la calma\nhemos recibido la alerta y su ubicación actual".uppercased()
        lblMessage.text = "Por favor detalle el delito para poder tomar el mejor curso de acción"
        formView.isHidden = false
        btnSend.isHidden = false
        lcFormHeight.constant = 256.0
    }
    
    @IBAction func btnIncidence(_ sender: Any) {
        performSegue(withIdentifier: "ReportToIncidence", sender: nil)
    }
    @IBAction func btnAttachment(_ sender: Any) {
        showImagePicker()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ReportToIncidence" {
            let vc = segue.destination as! IncidenceVC
            vc.category = report?.category
            vc.incidenceDelegate = self
        }
    }
    
    func didSelectIncidence(incidence: Incidence) {
        report?.incidence = incidence
        lblIncidence.text = report?.incidence?.shortTitle
        lblIncidence.textColor = .black
    }
    
    
    //
    // Choose image from camera, or gallery
    func showImagePicker() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Tomar foto", style: .default, handler: {(action: UIAlertAction) in
            self.getImage(fromSourceType: .camera)
        }))
        alert.addAction(UIAlertAction(title: "Seleccionar de la galería", style: .default, handler: {(action: UIAlertAction) in
            self.getImage(fromSourceType: .photoLibrary)
        }))
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func getImage(fromSourceType sourceType: UIImagePickerController.SourceType) {
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = sourceType
            self.present(imagePickerController, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        
        var width = 1280
        if Float((image?.size.height)!) > Float((image?.size.width)!) {
            width = 720
        }
        let resizedImage = image?.resizeWithWidth(width: CGFloat(integerLiteral: width))
        
        imageData = resizedImage!.jpegData(compressionQuality: 1)!
        
        self.dismiss(animated: false, completion: {
            self.lblAttachment.textColor = Colors.positive
            self.lblAttachment.text = "Foto adjunta"
        })
    }
    
    func validateFields() -> Bool {
        if report?.incidence == nil {
            showInfoDialog(self, "Debe seleccionar un tipo de delito")
            return false
        }
        return true
    }
    
    func requestDetail(report: Report, file: Data?, comment: String?){
        if Connectivity.isConnected(self) {
            showIntermediate()
            AF.upload(multipartFormData: { multipartFormData in
                multipartFormData.append(Data((report.incidence?.id.description.utf8)!), withName: "incidenceId")
                if file != nil {
                    multipartFormData.append(file!, withName: "file", fileName: "file.jpeg", mimeType: "image/jpeg")
                }
                if comment != nil && !comment!.isEmpty {
                    multipartFormData.append(Data(comment!.utf8), withName: "comment")
                }
            }, to: Url.report(reportId: report.id!), method: .put, headers: headers)
                .responseJSON { response in
                    switch response.response?.statusCode {
                        case 200:
                            self.showSuccess()
                        case 401:
                           self.showActionDialog(self, message: R.string.error_session, action: {
                               self.logout()
                           })
                        default:
                            self.showInfoDialog(self, R.string.error_api)
                            self.showDefault()
                    }
            }
            
        }
    }
}
