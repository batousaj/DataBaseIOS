//
//  Model.swift
//  PostgressIOS
//
//  Created by Thien Vu on 01/10/2022.
//

import Foundation

enum ConnectionStatusCode {
    case state_OK
    case state_NOTOK
    case state_TIMEOUT
}

enum Status : Error {
    case OK
    case badRequest
    case badResponse
    case requestFailed
}

class Model {
    
    struct CityInfo {
        var id : Int
        var city : String
        var country : String
        var lat : String
        var lon : String
        var temp : String
        var icon : String
    }
    
    static func apiKey() -> String? {
        
        if let appid = UserDefaults.standard.value(forKey: "app_id") {
            return appid as? String
        }
        
        UserDefaults.standard.set("5f440c90d88114df59cb0c5486aaed34", forKey: "app_id")
        return UserDefaults.standard.value(forKey: "app_id") as? String
    }
    
}

class Package {
    
    struct Results : Decodable {
        var coord:Coord!
        var weather:Weather!
        var main:Main!
        var sys:Sys!
        var id = ""
        
        enum CodingKeys : String, CodingKey {
            case coord
            case weather
            case main
            case sys
            case id
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
        }
    }
    
    struct Coord {
        var lat = ""
        var lon = ""
        
    }
    
    struct Weather {
        var id = ""
        var main = ""
        var icon = ""
    }
    
    struct Main {
        var temp = ""
        var temp_max = ""
        var temp_min = ""
    }
    
    struct Sys {
        var id = ""
        var country = ""
    }
    
}
