//
//  Connectivity.swift
//  Seguridad Veintiseis
//
//  Created by Andres Moreno on 11/26/19.
//  Copyright © 2019 uc-web. All rights reserved.
//

import Foundation
import Alamofire

class Connectivity {
    class func isConnected(_ vc: BaseViewController) ->Bool {
        if NetworkReachabilityManager()!.isReachable {
            return true
        }else{
            vc.showSnackBar("No hay conexión a internet", .negative)
            return false
        }
    }
}
