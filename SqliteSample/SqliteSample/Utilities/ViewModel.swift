//
//  ViewModel.swift
//  SqliteSample
//
//  Created by Thien Vu on 11/09/2022.
//

import Foundation

class Model  {
    
    static let table = "USERINFO"
    
    static let id    = "ID"
    static let name    = "NAME"
    static let age     = "AGE"
    static let address = "ADDRESS"
    
    static let ADD      = "Add"
    static let UPDATE   = "Update"
    static let DELETE   = "Delete"

    struct NameInfo {
        let name : String
        let age : String
        let address : String
    }
    
    static func fecthData() -> [Model.NameInfo] {
        
        var name = ""
        var age = ""
        var address = ""
        
        var infoUser = [Model.NameInfo]()
        DataBaseManager.sharedInstance.getParticipant() { dict in
            for (key, value) in dict {
                if key == Model.name {
                    name = value
                } else if key == Model.age {
                    age = value
                } else if key == Model.address {
                    address = value
                }
            }
            
            infoUser.append(Model.NameInfo(name: name,
                                           age: age,
                                           address: address))
        }
        
        return infoUser
        
    }
    
}



