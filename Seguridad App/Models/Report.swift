//
//  Report.swift
//  Seguridad Veintiseis
//
//  Created by Andres Moreno on 11/26/19.
//  Copyright © 2019 uc-web. All rights reserved.
//

import Foundation

struct Report: Codable {
    let id: Int?
    let account: Account?
    let category: Category
    let latitude: String
    let longitude: String
    var incidence: Incidence?
    let photoURL: String?
    var comment: String?
    let address: String
}
