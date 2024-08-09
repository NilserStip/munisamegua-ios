//
//  Account.swift
//  Seguridad Veintiseis
//
//  Created by Andres Moreno on 11/26/19.
//  Copyright © 2019 uc-web. All rights reserved.
//

import Foundation

struct Account: Codable {
    let email, firstName, lastName: String
    let password: String?
    let user: User
}
