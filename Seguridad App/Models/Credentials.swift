//
//  Credentials.swift
//  Seguridad Veintiseis
//
//  Created by Andres Moreno on 11/26/19.
//  Copyright © 2019 uc-web. All rights reserved.
//

import Foundation

struct Credentials: Codable {
    let email: String
    let password: String
    let device: String
}
