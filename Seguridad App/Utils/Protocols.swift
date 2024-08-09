//
//  Protocols.swift
//  Seguridad Veintiseis
//
//  Created by Andres Moreno on 1/14/20.
//  Copyright © 2020 uc-web. All rights reserved.
//

import Foundation

protocol IncidenceDelegate {
    func didSelectIncidence(incidence: Incidence)
}

protocol SubjectDelegate {
    func didSelect(subject: Subject)
}

protocol DrawerDelegate {
    func didTapLogout()
    func didTapComment()
    func didTapPasswordUpdate()
    func didChangeMapTheme()
    func didTapSettings()
}

protocol PhoneValidationDelegate {
    func didValidatePhone()
}

protocol RegisterDelegate {
    func didRegister(credentials: Credentials)
}

protocol SettingsDelegate {
    func didSettingsLogout()
    func didSettingsDeleteAccount()
    func didSettingsPasswordUpdate()
}
