//
//  Advertisement.swift
//  Seguridad Veintiseis
//
//  Created by Andres Moreno on 1/16/20.
//  Copyright © 2020 uc-web. All rights reserved.
//

import Foundation

struct Advertisement: Codable {
    let url: String
    let imgUrl: String
    
    func fullImgUrl() -> String {
        return "\(Url.baseUrl)/\(imgUrl)"
    }
}
