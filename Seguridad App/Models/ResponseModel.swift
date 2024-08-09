//
//  ResponseModel.swift
//  Seguridad Veintiseis
//
//  Created by Andres Moreno on 11/26/19.
//  Copyright © 2019 uc-web. All rights reserved.
//

import Foundation

struct ResponseModel<T: Codable>: Codable {
    var data: T?
    var message: String?
    var apiVersion: String?
}
