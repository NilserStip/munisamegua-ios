//
//  DrawerVC.swift
//  Seguridad Veintiseis
//
//  Created by Andres Moreno on 1/3/20.
//  Copyright © 2020 uc-web. All rights reserved.
//

import Foundation
import SideMenu
import Alamofire
import SwiftyUserDefaults
import Nuke

class DrawerVC: BaseViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var lblGreeting: UILabel!
    @IBOutlet weak var lcPhoneDirectoryHeight: NSLayoutConstraint!
    @IBOutlet weak var phoneDirectoryView: UIView!
    
    @IBOutlet weak var ivAdvertisement: UIImageView!
    @IBOutlet weak var lcAdvertisementHeight: NSLayoutConstraint!
    @IBOutlet weak var lcAdvertisementAspect: NSLayoutConstraint!
    
    @IBOutlet weak var btnCall1: UIButton!
    @IBOutlet weak var btnCall2: UIButton!
    @IBOutlet weak var btnCall3: UIButton!
    @IBOutlet weak var btnCall4: UIButton!
    
    @IBOutlet weak var lblPhoneCall1: UILabel!
    @IBOutlet weak var lblPhoneCall2: UILabel!
    @IBOutlet weak var lblPhoneCall3: UILabel!
    @IBOutlet weak var lblPhoneCall4: UILabel!
    
    @IBOutlet weak var swMapTheme: UISwitch!
    @IBOutlet weak var lblVersion: UILabel!
    
    var phoneNumbers = [PhoneDirectory]()
    var advertisement: Advertisement?
    var advertisements = [Advertisement]()
    var advertisementIndex = 0
    
    var delegate: DrawerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("DrawerVC -> viewDidLoad")
        
        lcPhoneDirectoryHeight.constant = 0
        phoneDirectoryView.isHidden = true
        
        ivAdvertisement.isHidden = true
        ivAdvertisement.applyCardViewStyle()
        lcAdvertisementHeight.priority = .required
        lcAdvertisementAspect.priority = .defaultLow
        
        lblVersion.text = Config.appVersion
        lblGreeting.text = "Hola,\n\(Defaults.username)"
        swMapTheme.isOn = Defaults.darkMap
        
        if FlavorSetting.isAdSliderEnabled {
            if !advertisements.isEmpty {
                setupSwipeRecognizers()
                setAdvertisement(index: advertisementIndex)
                
                let _ = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true, block: { _ in
                    self.handleSwipeRight()
                })
            }
        } else {
            setAdvertisement()
        }
        setupPhoneDirectory()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func setupPhoneDirectory() {
        btnCall1.setImage(FlavorSetting.ic_drawer_call_1, for: .normal)
        btnCall2.setImage(FlavorSetting.ic_drawer_call_2, for: .normal)
        btnCall3.setImage(FlavorSetting.ic_drawer_call_3, for: .normal)
        btnCall4.setImage(FlavorSetting.ic_drawer_call_4, for: .normal)
        
        lblPhoneCall1.text = FlavorSetting.drawerCall1
        lblPhoneCall2.text = FlavorSetting.drawerCall2
        lblPhoneCall3.text = FlavorSetting.drawerCall3
        lblPhoneCall4.text = FlavorSetting.drawerCall4
        
        if phoneNumbers.count == 4 {
            self.phoneDirectoryView.isHidden = false
            self.lcPhoneDirectoryHeight.priority = .defaultLow
        }
    }
    
    func setupSwipeRecognizers() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapAction(_:)))
        let swipeLeftAction = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction(_:)))
        let swipeRightAction = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction(_:)))
        
        swipeLeftAction.direction = .left
        swipeRightAction.direction = .right
        
        swipeLeftAction.delegate = self
        swipeRightAction.delegate = self
        
        ivAdvertisement.addGestureRecognizer(tapGesture)
        ivAdvertisement.addGestureRecognizer(swipeLeftAction)
        ivAdvertisement.addGestureRecognizer(swipeRightAction)
    }
    
    func setAdvertisement() {
        if advertisement != nil {
            Nuke.loadImage(with: URL(string: "\(Url.baseUrl)/\(advertisement!.imgUrl)")!, into: ivAdvertisement)
            lcAdvertisementAspect.priority = .required
            lcAdvertisementHeight.priority = .defaultLow
            ivAdvertisement.isHidden = false
        }
    }
    
    func setAdvertisement(index: Int) {
        if let advertisement = advertisements[safeIndex: index] {
            let loadingImage = UIImage(imageLiteralResourceName: "img_loading")
            let errorImage = UIImage(imageLiteralResourceName: "img_error")
            Nuke.loadImage(with: URL(string: advertisement.imgUrl)!, options: ImageLoadingOptions(placeholder: loadingImage, failureImage: errorImage), into: ivAdvertisement)
            lcAdvertisementAspect.priority = .required
            lcAdvertisementHeight.priority = .defaultLow
            ivAdvertisement.isHidden = false
        }
    }
    
    @IBAction func btnCall1(_ sender: Any) {
        if phoneNumbers.count == 4 {
            Util.makeCall(vc: self, phone: phoneNumbers[0].number)
        }
    }
    @IBAction func btnCall2(_ sender: Any) {
        if phoneNumbers.count == 4 {
            Util.makeCall(vc: self, phone: phoneNumbers[1].number)
        }
    }
    @IBAction func btnCall3(_ sender: Any) {
        if phoneNumbers.count == 4 {
            Util.makeCall(vc: self, phone: phoneNumbers[2].number)
        }
    }
    @IBAction func btnCall4(_ sender: Any) {
        if phoneNumbers.count == 4 {
            Util.makeCall(vc: self, phone: phoneNumbers[3].number)
        }
    }
    
    @IBAction func swMapTheme(_ sender: Any) {
        Defaults.darkMap = swMapTheme.isOn
        delegate?.didChangeMapTheme()
    }
    @IBAction func btnPasswordUpdate(_ sender: Any) {
        dismiss(animated: false, completion: {
            self.delegate?.didTapPasswordUpdate()
        })
    }
    @IBAction func btnComment(_ sender: Any) {
        dismiss(animated: false, completion: {
            self.delegate?.didTapComment()
        })
    }
    
    @IBAction func btnRate(_ sender: Any) {
        Util.openUrl(FlavorSetting.appStoreUrl)
    }
    @IBAction func btnVersion(_ sender: Any) {
    }
    @IBAction func btnLogout(_ sender: Any) {
        showDestructiveDialog(self, destructiveTitle: "Cerrar sesión", message: "¿Desea cerrar sesión?") {
            self.dismiss(animated: false, completion: {
                self.delegate?.didTapLogout()
            })
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        true
    }
    
    @objc func tapAction(_ sender: UITapGestureRecognizer) {
        if let advertisement = advertisements[safeIndex: advertisementIndex] {
            Util.openUrl(advertisement.url)
        }
    }
    
    @objc func swipeAction(_ sender: UISwipeGestureRecognizer) {
        switch sender.direction {
            case .left: handleSwipeLeft()
            case .right: handleSwipeRight()
            default: break
        }
    }
    
    func handleSwipeLeft() {
        if self.advertisementIndex == self.advertisements.count - 1 {
            self.advertisementIndex = 0
        } else{
            self.advertisementIndex+=1
        }
        setAdvertisement(index: advertisementIndex)
    }
    
    func handleSwipeRight() {
        if self.advertisementIndex == 0 {
            self.advertisementIndex = self.advertisements.count - 1
        } else  {
            self.advertisementIndex-=1
        }
        setAdvertisement(index: advertisementIndex)
    }
    
    @IBAction func btnSettings(_ sender: Any) {
        dismiss(animated: false, completion: {
            self.delegate?.didTapSettings()
        })
    }
}
