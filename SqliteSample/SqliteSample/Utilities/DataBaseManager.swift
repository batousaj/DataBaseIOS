//
//  DataBaseManager.swift
//  SqliteSample
//
//  Created by Mac Mini 2021_1 on 13/09/2022.
//

import Foundation

class DataBaseManager {
    
    static let sharedInstance = DataBaseManager()
    
    var service:DataBaseService!
    
    init() {
        self.createDatabaseService()
    }
    
    func createDatabaseService() {
        if ( service == nil) {
            service = DataBaseService()
        }
    }
    
    func createFileDirectoryDatabase() {
        
    }
    
    func createNewTable(_ table : String) {
        
    }
    
    func doParticipant(_ participant : [String:String], action: String, successHandler : @escaping (Bool) -> Void) {
        
        if action == "add" {
            
        } else if action == "edit" {
            
        } else if action == "delete" {
            
        }
    }
    
    func getParticipant(_ recordBlock : @escaping ([[String:String]]) -> Void) {
        
    }
}
