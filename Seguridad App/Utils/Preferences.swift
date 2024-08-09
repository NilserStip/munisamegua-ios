//
//  Preferences.swift
//  Seguridad Veintiseis
//
//  Created by Andres Moreno on 11/26/19.
//  Copyright © 2019 uc-web. All rights reserved.
//

import SwiftyUserDefaults

extension DefaultsKeys {
    var session: DefaultsKey<Bool> { return .init("session", defaultValue: false) }
    var authorization: DefaultsKey<String> { return .init("authorization", defaultValue: "") }
    var username: DefaultsKey<String> { return .init("username", defaultValue: "usuario") }
    var phone: DefaultsKey<String> { return .init("phone", defaultValue: "") }
    var darkMap: DefaultsKey<Bool> { return .init("darkMap", defaultValue: false) }
    var prevlat: DefaultsKey<Double> { return .init("prevlat", defaultValue: -12.085227) } //unused
    var prevLng: DefaultsKey<Double> { return .init("prevLng", defaultValue: -77.067746) } //unused
}
