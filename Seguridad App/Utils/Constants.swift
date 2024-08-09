//
//  Constants.swift
//  Seguridad Veintiseis
//
//  Created by Andres Moreno on 11/26/19.
//  Copyright © 2019 uc-web. All rights reserved.
//

import Foundation

enum Config {
    static let device = "ios"
    static let appVersion = "\(Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String)"
    static let tag = "amd"
    static let isDemo = false
    static let isDebugLocation = false
    static let mockLatitude = -11.8535764
    static let mockLongitude = -77.12031126268256
}

enum Url {
    static let baseUrl = FlavorSetting.baseUrl
    static let api = baseUrl + "/api"
    
    static let login = api + "/auth/login"
    static let logout = api + "/auth/logout"
    static let passwordReset = api + "/auth/password-resets"
    
    static let register = api + "/app/accounts/register"
    static let deleteAccount = api + "/app/accounts/delete"
    static let categories = api + "/app/categories"
    
    static func incidences(categoryId: Int) -> String {
        return Url.categories + "/\(categoryId)/incidences"
    }
    
    static let report = api + "/app/reports"
    
    static func report(reportId: Int) -> String {
        return Url.report + "/\(reportId)"
    }
    
    static let advertisement = api + "/app/advertisements/latest"
    static let advertisements = api + "/app/advertisements"
    static let phoneDirectory = api + "/app/phone-directory"
    static let subjects = api + "/app/subjects"
    static let comment = api + "/app/comments"
    static let passwordUpdate = api + "/app/accounts/change-password"
    
    static let zoneService = api + "/app/zone-service"

    static let terms_of_use = "https://www.munisamegua.gob.pe/politicas-terminos-y-condiciones-para-el-aplicativo-movil-de-seguridad-ciudadana/"
    static let privacy_policy = "https://www.munisamegua.gob.pe/politicas-terminos-y-condiciones-para-el-aplicativo-movil-de-seguridad-ciudadana/"
}

enum R {
    enum string {
        static let error_api = "Ocurrió un error desconocido"
        static let error_connection = "Ocurrió un error de conexión"
        static let error_unauthorized = "Lo sentimos. Su cuenta esta deshabilitada"
        static let error_login = "El correo electrónico y la contraseña que ha ingresado no coinciden con nuestros registros. Por favor, revise nuevamente e inténtelo de nuevo"
        static let error_session = "Su sesión ha expirado"
        
        static let comment_comment_input = "Escriba un comentario"
        static let report_comment_input = "Haga un comentario (opcional)"
        
        static let error_input_email = "Correo inválido"
        static let error_input_name = "Mínimo 2 caracteres"
        static let error_input_phone = "Se requiere 9 dígitos"
        static let error_input_empty = "No puede estar en blanco"
        static let error_input_password = "Mínimo 6 caracteres"
        static let error_input_password_confirm = "Las contraseñas deben coincidir"
        
    }
}

enum AgreementType {
    static let termsOfUse = 1
    static let privacyPolicy = 2
}

enum SnackType {
    case positive
    case negative
    case neutral
}
