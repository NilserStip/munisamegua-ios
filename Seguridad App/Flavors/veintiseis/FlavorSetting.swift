//
//  FlavorSetting.swift
//  Seguridad App
//
//  Created by Andres Moreno on 8/13/22.
//  Copyright © 2022 uc-web. All rights reserved.
//

import Foundation
import UIKit

enum FlavorSetting {
    static let baseUrl = "https://samegua.seguridadapp.pe"
    static let appName = "Alerta Samegua"
    static let gMapsKey = "AIzaSyCOE3YmGby3LG6H0bkri9HnWxIPbod_4hE"
    static let appStoreUrl = "https://www.apple.com"
    static let loginTitle = "Municipalidad Provincial de Samegua"
    static let isAdSliderEnabled = false
    
    // Drawer settings
    static let drawerCall1 = "CPNP\nSan Martín"
    static let drawerCall2 = "CPNP\n26 Oct."
    static let drawerCall3 = "Serenazgo"
    static let drawerCall4 = "Bomberos"
    static let ic_drawer_call_1 = UIImage(imageLiteralResourceName: "ic_call_police")
    static let ic_drawer_call_2 = UIImage(imageLiteralResourceName: "ic_call_police")
    static let ic_drawer_call_3 = UIImage(imageLiteralResourceName: "ic_call_serenazgo")
    static let ic_drawer_call_4 = UIImage(imageLiteralResourceName: "ic_call_firefighters")
}
