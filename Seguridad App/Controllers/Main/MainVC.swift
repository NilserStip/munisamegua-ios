//
//  ViewController.swift
//  Seguridad Veintiseis
//
//  Created by Andres Moreno on 11/22/19.
//  Copyright © 2019 uc-web. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation
import Alamofire
import SwiftyUserDefaults
import Nuke

class MainVC: BaseViewController, CLLocationManagerDelegate, DrawerDelegate, SettingsDelegate {
    
    var alertController = UIAlertController()
    var categories = [Category]()
    
    let locationManager = CLLocationManager()
    let marker = GMSMarker()
    @IBOutlet weak var lblDebug: UILabel!
    @IBOutlet weak var lblCountdown: UILabel!
    
    //Outlets
    @IBOutlet weak var navBar: UINavigationBar!
    
    @IBOutlet weak var widgetView: UIView!
    @IBOutlet weak var lcWidgetBottom: NSLayoutConstraint!
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var btnAlert: CircleButton!
    
    @IBOutlet weak var btnCategory1: CircleButton!
    @IBOutlet weak var btnCategory2: CircleButton!
    @IBOutlet weak var btnCategory3: CircleButton!
    @IBOutlet weak var btnCategory4: CircleButton!
    @IBOutlet weak var btnCategory5: CircleButton!
    @IBOutlet weak var btnCategory6: CircleButton!
    @IBOutlet weak var btnCategory7: CircleButton!
    @IBOutlet weak var btnCategory8: CircleButton!
    
    @IBOutlet weak var ivCategory1: CircleImageView!
    @IBOutlet weak var ivCategory2: CircleImageView!
    @IBOutlet weak var ivCategory3: CircleImageView!
    @IBOutlet weak var ivCategory4: CircleImageView!
    @IBOutlet weak var ivCategory5: CircleImageView!
    @IBOutlet weak var ivCategory6: CircleImageView!
    @IBOutlet weak var ivCategory7: CircleImageView!
    @IBOutlet weak var ivCategory8: CircleImageView!
    
    
    // Animation Constraints
    @IBOutlet weak var btnCat1Y: NSLayoutConstraint!
    
    @IBOutlet weak var btnCat2X: NSLayoutConstraint!
    @IBOutlet weak var btnCat2Y: NSLayoutConstraint!
    
    @IBOutlet weak var btnCat3X: NSLayoutConstraint!
    
    @IBOutlet weak var btnCat4X: NSLayoutConstraint!
    @IBOutlet weak var btnCat4Y: NSLayoutConstraint!
    
    @IBOutlet weak var btnCat5Y: NSLayoutConstraint!
    
    @IBOutlet weak var btnCat6X: NSLayoutConstraint!
    @IBOutlet weak var btnCat6Y: NSLayoutConstraint!
    
    @IBOutlet weak var btnCat7X: NSLayoutConstraint!
    
    @IBOutlet weak var btnCat8X: NSLayoutConstraint!
    @IBOutlet weak var btnCat8Y: NSLayoutConstraint!
    
    //drawer variables
    
    var phoneNumbers = [PhoneDirectory]()
    var advertisement: Advertisement?
    var advertisements = [Advertisement]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.alpha = 0
        navBar.topItem?.title = FlavorSetting.appName
        // Do any additional setup after loading the view.
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
        initMap()
        setObserver()
        widgetView.isHidden = true
        requestCategories()
        requestZoneService()
        
        requestPhoneDirectory()
        FlavorSetting.isAdSliderEnabled ? requestAdvertisements() : requestAdvertisement()
        lcWidgetBottom.constant = -UIScreen.main.bounds.width
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("Main -> viewDidAppear")
        view.alpha = 1
        btnAlert.applyCircleRadius()
        ivCategory1.applyCircleRadius()
        ivCategory2.applyCircleRadius()
        ivCategory3.applyCircleRadius()
        ivCategory4.applyCircleRadius()
        ivCategory5.applyCircleRadius()
        ivCategory6.applyCircleRadius()
        ivCategory7.applyCircleRadius()
        ivCategory8.applyCircleRadius()
        
        ivCategory1.zoomIn()
        
        checkLocationSettings()
        
    }
    @IBAction func btnDrawer(_ sender: Any) {
        performSegue(withIdentifier: "MainToMenu", sender: nil)
    }
    
    @IBAction func btnAlert(_ sender: Any) {
        if GMSGeometryContainsLocation(marker.position, (zoneService?.area())!, true) {
            showAlerts()
        }else{
            showInfoDialog(self, "No se encuentra en el area de servicio")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MainToMenu" {
            if let nav = segue.destination as? UINavigationController {
                if let vc = nav.topViewController as? DrawerVC {
                    vc.delegate = self
                    vc.phoneNumbers = phoneNumbers
                    vc.advertisement = advertisement
                    vc.advertisements = advertisements
                    
                }
            }
        }
        
        if segue.identifier == "MainToReport" {
            if let vc = segue.destination as? ReportVC {
                vc.report = sender as? Report
            }
        }
        
        if segue.identifier == "MainToSettings" {
            if let vc = segue.destination as? SettingsVC {
                vc.delegate = self
            }
        }
    }
    
    func initMap() {
        mapView.settings.setAllGesturesEnabled(false)
        
        let camera_fixed = GMSCameraPosition.camera(
            withLatitude: -12.085227,
            longitude: -77.067746,
            zoom: 13)
        mapView.camera = camera_fixed
        
        var mapResource = "map"
        if Defaults.darkMap {
            mapResource = "mapDark"
        }
        
        do {
            if let styleURL = Bundle.main.url(forResource: mapResource, withExtension: "json") {
                mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
            } else {
                print("Unable to find map.json")
            }
        } catch {
            print("One or more of the map styles failed to load. \(error)")
        }
    }
    
    func showAlerts() {
        lblDebug.text = "¿Qué delito quiere reportar?"
        lblCountdown.text = "Seleccione\nun delito"
        btnAlert.isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.3) {
            self.mapView.padding = UIEdgeInsets(
                top: UIScreen.main.bounds.width * 0.25,
                left: 0.0,
                bottom: UIScreen.main.bounds.width,
                right: 0.0
            )
        }
        btnAlert.setBackgroundImage(UIImage(imageLiteralResourceName: "ic_btn_alert_gray"), for: .normal)
        
        let straightDistance = CGFloat(0.3375) * UIScreen.main.bounds.width
        let diagonalDistance = straightDistance / CGFloat(2.0.squareRoot())
        
        UIView.animate(withDuration: 0.3, animations: {
            
            self.btnCat1Y.constant = -straightDistance
            
            self.btnCat2X.constant = diagonalDistance
            self.btnCat2Y.constant = -diagonalDistance
            
            self.btnCat3X.constant = straightDistance
            
            self.btnCat4X.constant = diagonalDistance
            self.btnCat4Y.constant = diagonalDistance
            
            self.btnCat5Y.constant = straightDistance
            
            self.btnCat6X.constant = -diagonalDistance
            self.btnCat6Y.constant = -diagonalDistance
            
            self.btnCat7X.constant = -straightDistance
            
            self.btnCat8X.constant = -diagonalDistance
            self.btnCat8Y.constant = diagonalDistance
            
            self.view.layoutIfNeeded()
            
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            if !self.btnAlert.isUserInteractionEnabled {
                self.hideAlerts()
            }
        }
    }
    
    func hideAlerts(){
        lblDebug.text = address
        lblCountdown.text = ""
        btnAlert.isUserInteractionEnabled = true
        UIView.animate(withDuration: 0.25) {
            self.mapView.padding = UIEdgeInsets(
                top: 0.0,
                left: 0.0,
                bottom: UIScreen.main.bounds.width * 0.75,
                right: 0.0
            )
        }
        btnAlert.setBackgroundImage(UIImage(imageLiteralResourceName: "ic_btn_alert_red"), for: .normal)
        
        UIView.animate(withDuration: 0.3, animations: {
            
            self.btnCat1Y.constant = 0
            
            self.btnCat2X.constant = 0
            self.btnCat2Y.constant = 0
            
            self.btnCat3X.constant = 0
            
            self.btnCat4X.constant = 0
            self.btnCat4Y.constant = 0
            
            self.btnCat5Y.constant = 0
            
            self.btnCat6X.constant = 0
            self.btnCat6Y.constant = 0
            
            self.btnCat7X.constant = 0
            
            self.btnCat8X.constant = 0
            self.btnCat8Y.constant = 0
            
            self.view.layoutIfNeeded()
            
        })
    }
    
    var address = "Obteniendo ubicación..."
    var demo = true
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        let latitude = Config.isDebugLocation ? Config.mockLatitude : locations.last!.coordinate.latitude
        let longitude = Config.isDebugLocation ? Config.mockLongitude : locations.last!.coordinate.longitude
        
        alertController.dismiss(animated: false, completion: nil)
        
        if lcWidgetBottom.constant != 0 {
            UIView.animate(withDuration: 1, animations: {
                self.lcWidgetBottom.constant = 0
                self.view.layoutIfNeeded()
            })
        }
        
        // print("Timestamp: \(Date.init().description)")
        // print("Latitude: \(latitude)\nLongitude: \(longitude)")
        
        marker.position = CLLocationCoordinate2D(
            latitude: latitude,
            longitude: longitude)
        marker.appearAnimation = .pop
        marker.icon = UIImage(named: "ic_marker")
        marker.map = mapView
        
        if btnAlert.isUserInteractionEnabled {
            
            let camera_fixed = GMSCameraPosition.camera(
                withLatitude: latitude,
                longitude: longitude,
                zoom: 15)
            
            self.mapView.padding = UIEdgeInsets(
                top: 0.0,
                left: 0.0,
                bottom: UIScreen.main.bounds.width * 0.75,
                right: 0.0
            )
            
            mapView.animate(to: camera_fixed)
        }
        
        let geo: GMSGeocoder = GMSGeocoder()
        geo.reverseGeocodeCoordinate(marker.position, completionHandler: { (response, error) in
            let sample = response
            let fullAddress = sample?.firstResult()
            if let fullAddress = fullAddress?.lines?[0]{
                self.address = fullAddress
            }
            //self.address = (fullAddress?.lines?[0])!
            //self.address = (fullAddress?.lines![0].removeAfter(character: ","))!
            if self.btnAlert.isUserInteractionEnabled {
                self.lblDebug.text = self.address
            }
        })
    }
    
    func checkLocationSettings(){
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.allowsBackgroundLocationUpdates = true
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.distanceFilter = 3
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                print("No access")
                askPermissionDialog()
            case .authorizedAlways, .authorizedWhenInUse:
                print("Access")
            //Dialog.show(self.view, loadingText: "Obteniendo ubicación")
            @unknown default:
                break
            }
        } else {
            print("Location services are not enabled")
            askPermissionDialog()
        }
    }
    
    
    func askPermissionDialog(){
        alertController = UIAlertController(title: FlavorSetting.appName, message: "Debe activar el servicio de ubicación", preferredStyle: UIAlertController.Style.alert)
        let actionPositive = UIAlertAction(title: "Ir a configuración", style: UIAlertAction.Style.default) {
            (result : UIAlertAction) -> Void in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url)
            }
        }
        let actionNegative = UIAlertAction(title: "Cancelar", style: .default)
        
        alertController.addAction(actionPositive)
        alertController.addAction(actionNegative)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func requestCategories(){
        if Connectivity.isConnected(self) {
            AF.request(Url.categories,
                       method: .get,
                       headers: headers).responseDecodable(of: ResponseModel<[Category]>.self) { response in
                        switch response.response?.statusCode {
                                    
                            case 200:
                                switch response.result {
                                case .success(let value):
                                    self.categories = value.data!
                                    self.setCategories()
                                case .failure(let error):
                                    print(error)
                                }
                            case 401:
                                self.logout()
                            default:
                                self.showInfoDialog(self, R.string.error_api)
                        }
            }
        }
    }
    
    func setCategories(){
        
        btnCategory1.isHidden = true
        btnCategory2.isHidden = true
        btnCategory3.isHidden = true
        btnCategory4.isHidden = true
        btnCategory5.isHidden = true
        btnCategory6.isHidden = true
        btnCategory7.isHidden = true
        btnCategory8.isHidden = true
        
        ivCategory1.isHidden = true
        ivCategory2.isHidden = true
        ivCategory3.isHidden = true
        ivCategory4.isHidden = true
        ivCategory5.isHidden = true
        ivCategory6.isHidden = true
        ivCategory7.isHidden = true
        ivCategory8.isHidden = true
        
        for i in 0..<categories.count {
            switch i {
            case 0:
                widgetView.isHidden = false
                btnCategory1.isHidden = false
                ivCategory1.isHidden = false
                Nuke.loadImage(with: URL(string: "\(Url.baseUrl)/\(categories[i].iconUrl)")!, into: ivCategory1)
            case 1:
                btnCategory2.isHidden = false
                ivCategory2.isHidden = false
                Nuke.loadImage(with: URL(string: "\(Url.baseUrl)/\(categories[i].iconUrl)")!, into: ivCategory2)
            case 2:
                btnCategory3.isHidden = false
                ivCategory3.isHidden = false
                Nuke.loadImage(with: URL(string: "\(Url.baseUrl)/\(categories[i].iconUrl)")!, into: ivCategory3)
            case 3:
                btnCategory4.isHidden = false
                ivCategory4.isHidden = false
                Nuke.loadImage(with: URL(string: "\(Url.baseUrl)/\(categories[i].iconUrl)")!, into: ivCategory4)
            case 4:
                btnCategory5.isHidden = false
                ivCategory5.isHidden = false
                Nuke.loadImage(with: URL(string: "\(Url.baseUrl)/\(categories[i].iconUrl)")!, into: ivCategory5)
            case 5:
                btnCategory6.isHidden = false
                ivCategory6.isHidden = false
                Nuke.loadImage(with: URL(string: "\(Url.baseUrl)/\(categories[i].iconUrl)")!, into: ivCategory6)
            case 6:
                btnCategory7.isHidden = false
                ivCategory7.isHidden = false
                Nuke.loadImage(with: URL(string: "\(Url.baseUrl)/\(categories[i].iconUrl)")!, into: ivCategory7)
            case 7:
                btnCategory8.isHidden = false
                ivCategory8.isHidden = false
                Nuke.loadImage(with: URL(string: "\(Url.baseUrl)/\(categories[i].iconUrl)")!, into: ivCategory8)
            default:
                break
            }
        }
    }
    
    @IBAction func btnCategory1(_ sender: Any) {
        sendAlert(idx: 0)
    }
    @IBAction func btnCategory2(_ sender: Any) {
        sendAlert(idx: 1)
    }
    @IBAction func btnCategory3(_ sender: Any) {
        sendAlert(idx: 2)
    }
    @IBAction func btnCategory4(_ sender: Any) {
        sendAlert(idx: 3)
    }
    @IBAction func btnCategory5(_ sender: Any) {
        sendAlert(idx: 4)
    }
    @IBAction func btnCategory6(_ sender: Any) {
        sendAlert(idx: 5)
    }
    @IBAction func btnCategory7(_ sender: Any) {
        sendAlert(idx: 6)
    }
    @IBAction func btnCategory8(_ sender: Any) {
        sendAlert(idx: 7)
    }
    
    func sendAlert(idx: Int) {
        if (!btnAlert.isUserInteractionEnabled) {
            hideAlerts()
            if (categories.count > idx) {
                let report = Report(id: nil,
                                    account: nil,
                                    category: categories[idx],
                                    latitude: marker.position.latitude.description,
                                    longitude: marker.position.longitude.description,
                                    incidence: nil,
                                    photoURL: nil,
                                    comment: nil,
                                    address: ""
                )
                print(report.category.title)
                requestReport(report)
            }
        }
    }
    
    func requestReport(_ report: Report){
        if Connectivity.isConnected(self) {
            Loader.start(view)
            AF.request(Url.report,
                       method: .post,
                       parameters: report,
                       encoder: JSONParameterEncoder.default,
                       headers: headers).responseDecodable(of: ResponseModel<Report>.self) { response in
                        Loader.stop()
                        switch response.response?.statusCode {
                                    
                            case 200:
                                switch response.result {
                                case .success(let value):
                                    print("amd: \(value)")
                                    self.performSegue(withIdentifier: "MainToReport", sender: value.data)
                                case .failure(let error):
                                    print(error)
                                }
                            case 401:
                                self.logout()
                            default:
                                self.showInfoDialog(self, R.string.error_api)
                        }
            }
        }
    }
    
    func requestAdvertisement(){
        if Connectivity.isConnected(self) {
            AF.request(Url.advertisement,
                       method: .get,
                       headers: headers).responseDecodable(of: ResponseModel<Advertisement>.self) { response in
                        
                        switch response.response?.statusCode {
                                    
                            case 200:
                                switch response.result {
                                case .success(let value):
                                    print("amd: \(value)")
                                    if value.data != nil {
                                        /*Nuke.loadImage(with: URL(string: "\(Url.baseUrl)/\(value.data!.imgUrl)")!, into: self.ivAdvertisement)
                                        self.lcAdvertisementAspect.priority = .defaultHigh
                                        self.lcAdvertisementHeight.priority = .defaultLow
                                        self.ivAdvertisement.isHidden = false*/
                                        self.advertisement = value.data
                                    }
                                case .failure(let error):
                                    print(error)
                                }
                            case 401:
                                self.logout()
                                break
                            default:
                                break
                        }
            }
        }
    }
    
    func requestAdvertisements(){
        if Connectivity.isConnected(self) {
            AF.request(Url.advertisements,
                       method: .get,
                       headers: headers).responseDecodable(of: ResponseModel<[Advertisement]>.self) { response in
                
                        print("amd: \(response)")
                        switch response.response?.statusCode {
                                    
                            case 200:
                                switch response.result {
                                case .success(let value):
                                    print("amd: \(value)")
                                    if value.data != nil && !value.data!.isEmpty {
                                        /*Nuke.loadImage(with: URL(string: "\(Url.baseUrl)/\(value.data!.imgUrl)")!, into: self.ivAdvertisement)
                                        self.lcAdvertisementAspect.priority = .defaultHigh
                                        self.lcAdvertisementHeight.priority = .defaultLow
                                        self.ivAdvertisement.isHidden = false*/
                                        self.advertisements = value.data!
                                    }
                                case .failure(let error):
                                    print(error)
                                }
                            case 401:
                                self.logout()
                                break
                            default:
                                break
                        }
            }
        }
    }
    
    func requestPhoneDirectory(){
        if Connectivity.isConnected(self) {
            AF.request(Url.phoneDirectory,
                       method: .get,
                       headers: headers).responseDecodable(of: ResponseModel<[PhoneDirectory]>.self) { response in
                        
                        switch response.response?.statusCode {
                                    
                            case 200:
                                switch response.result {
                                case .success(let value):
                                    print("amd: \(value)")
                                    if value.data != nil {
                                        self.phoneNumbers = value.data!
                                    }
                                case .failure(let error):
                                    print(error)
                                }
                            case 401:
                                self.logout()
                                break
                            default:
                                break
                        }
            }
        }
    }
    
    func doLogout() {
        if Connectivity.isConnected(self) {
            Loader.start(view)
            AF.request(Url.logout,
                       method: .post,
                       headers: headers).responseJSON { response in
                        Loader.stop()
                        switch response.response?.statusCode {
                            case 200:
                                self.logout()
                            case 401:
                               self.logout()
                            default:
                                self.showInfoDialog(self, R.string.error_api)
                        }
            }
        }
    }
    
    func didTapLogout() {
        doLogout()
    }

    func didTapComment() {
        performSegue(withIdentifier: "MainToComment", sender: nil)
    }
    
    func didTapPasswordUpdate() {
        performSegue(withIdentifier: "MainToPasswordUpdate", sender: nil)
    }
    
    func didTapSettings() {
        performSegue(withIdentifier: "MainToSettings", sender: nil)
    }
    
    func didSettingsLogout() {
        doLogout()
    }
    
    func didSettingsPasswordUpdate() {
        performSegue(withIdentifier: "MainToPasswordUpdate", sender: nil)
    }
    
    func didSettingsDeleteAccount() {
        if Connectivity.isConnected(self) {
            Loader.start(view)
            AF.request(Url.deleteAccount,
                       method: .post,
                       headers: headers).responseJSON { response in
                        Loader.stop()
                        switch response.response?.statusCode {
                            case 200:
                                self.logout()
                            case 401:
                               self.logout()
                            default:
                                self.showInfoDialog(self, R.string.error_api)
                        }
            }
        }
    }
    
    func didChangeMapTheme() {
        var mapResource = "map"
        if Defaults.darkMap {
            mapResource = "mapDark"
        }
         do {
                   if let styleURL = Bundle.main.url(forResource: mapResource, withExtension: "json") {
                       mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
                   } else {
                       print("Unable to find map.json")
                   }
               } catch {
                   print("One or more of the map styles failed to load. \(error)")
               }
    }
    
    
    var zoneService: ZoneService?
    
    func requestZoneService(){
        if Connectivity.isConnected(self) {
            AF.request(Url.zoneService,
                       method: .get,
                       headers: headers).responseDecodable(of: ResponseModel<ZoneService>.self) { response in
                        switch response.response?.statusCode {
                            case 200:
                                switch response.result {
                                case .success(let value):
                                    print("amd: \(value)")
                                    self.zoneService = value.data
                                case .failure(let error):
                                    print(error)
                                }
                            case 401:
                                self.logout()
                            default:
                                self.showInfoDialog(self, R.string.error_api)
                        }
            }
        }
    }
    
    
    
    
    func setObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    @objc func willEnterForeground(){
        print("willEnterForeground")
        checkLocationSettings()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
}



