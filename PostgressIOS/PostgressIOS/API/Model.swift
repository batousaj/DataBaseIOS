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
    
    struct IconCity {
        var city : String
        var icon : String
        var image : Data
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
        var weather:[Weather]!
        var main:Main!
        var sys:Sys!
        var id = 0
        
        enum CodingKeys : String, CodingKey {
            case coord
            case weather
            case main
            case sys
            case id
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            coord = try container.decode(Coord.self, forKey: .coord)
            weather = try container.decode([Weather].self, forKey: .weather)
            main = try container.decode(Main.self, forKey: .main)
            sys = try container.decode(Sys.self, forKey: .sys)
            id = try container.decode(Int.self, forKey: .id)
        }
    }
    
    struct Coord : Decodable {
        var lat:Float = 0.0
        var lon:Float = 0.0
        
        enum CodingKeys : String, CodingKey {
            case lon
            case lat
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            lat = try container.decode(Float.self, forKey: CodingKeys.lat)
            lon = try container.decode(Float.self, forKey: CodingKeys.lon)
            
        }
    }
    
    struct Weather : Decodable {
        var id = 0
        var main = ""
        var icon = ""
        
        enum CodingKeys : String, CodingKey {
            case id
            case main
            case icon
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            id = try container.decode(Int.self, forKey: CodingKeys.id)
            main = try container.decode(String.self, forKey: CodingKeys.main)
            icon = try container.decode(String.self, forKey: CodingKeys.icon)
        }
    }
    
    struct Main : Decodable {
        var temp:Float
        var temp_max:Float
        var temp_min:Float
        
        enum CodingKeys : String, CodingKey {
            case temp
            case temp_max
            case temp_min
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            temp = try container.decode(Float.self, forKey: CodingKeys.temp)
            temp_max = try container.decode(Float.self, forKey: CodingKeys.temp_max)
            temp_min = try container.decode(Float.self, forKey: CodingKeys.temp_min)
        }
    }
    
    struct Sys : Decodable {
        var id = 0
        var country = ""
        
        enum CodingKeys : String, CodingKey {
            case id
            case country
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            id = try container.decode(Int.self, forKey: CodingKeys.id)
            country = try container.decode(String.self, forKey: CodingKeys.country)
        }
    }
    
}
