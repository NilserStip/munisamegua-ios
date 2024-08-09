//
//  ZoneService.swift
//  Seguridad Veintiseis
//
//  Created by Andres Moreno on 1/21/20.
//  Copyright © 2020 uc-web. All rights reserved.
//

import Foundation
import GoogleMaps

struct ZoneService: Codable {
    var points: String? = "[]"
    
    func area() -> GMSMutablePath{
        
        let area = GMSMutablePath()
        
        let data = points!.data(using: .utf8)!
        do {
            if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [Dictionary<String,Any>]
            {
               print(jsonArray) // use the json here
                for item in jsonArray {
                    if let latitude = item["lat"]{
                        if let lng = item["lng"] {
                            area.add(CLLocationCoordinate2D(latitude: latitude as! CLLocationDegrees, longitude: lng as! CLLocationDegrees))
                        }
                    }
                }
            } else {
                print("bad zone service json")
            }
        } catch let error as NSError {
            print(error)
        }
        
        return area
    }
}
