//
//  DataBaseService.swift
//  SqliteSample
//
//  Created by Mac Mini 2021_1 on 13/09/2022.
//

import Foundation

class DataBaseService {
    
    // MARK: - Alert table
    func createTable(_ table : String, column: String, cuccessHandler : @escaping (Bool) -> Void ) {
        
    }
    
    // MARK: - Alert table
    
    func alertTable(_ table : String, addColumn: String, type: String, successHandler : @escaping (Bool) -> Void ) {
        
    }
    
    func alertTable(_ table : String, dropColumn: String, type: String, successHandler : @escaping (Bool) -> Void ) {
        
    }
    
    func alertTable(_ table : String, alertColumn: String, type: String, successHandler : @escaping (Bool) -> Void ) {
        
    }
    
    func alertTable(_ table : String, renameColumn: String, type: String, successHandler : @escaping (Bool) -> Void ) {
        
    }
    
    // MARK: - insert table
    
    func insertTable(_ table : String, column: String?, value : [String], successHandler : @escaping (Bool) -> Void) {
        
    }
    
    // MARK: - delete table
    
    func deleteTable(_ table :  String, where : [String], successHandler : @escaping (Bool) -> Void) {
        
    }
    
    // MARK: - select table
    func selectTable(_ columns : [String], from: String, where : String, extra: String, recordBlock : @escaping ([[String]]) -> Void, successHandler : @escaping (Bool) -> Void) {
        
    }
    
    // MARK: - update table
    func updateTable(_ table :  String, value:[String], where : String, successHandler : @escaping (Bool) -> Void) {
    
    }
    
    
    // MARK: - Private function
    
    func statement(_ statement : String, recordBlock : @escaping ([String]) -> Void, successHandler : @escaping (Bool) -> Void) {
        
    }
    
    func statement(_ statement : String, successHandler : @escaping (Bool) -> Void) {
        
    }
}
