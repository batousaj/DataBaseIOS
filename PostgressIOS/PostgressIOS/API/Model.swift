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

class Model {
    
    struct CityInfo {
        let id : Int
        let name : String
        let tempo : Int
    }
    
    
}
