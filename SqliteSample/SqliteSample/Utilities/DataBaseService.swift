//
//  DataBaseService.swift
//  SqliteSample
//
//  Created by Mac Mini 2021_1 on 13/09/2022.
//

import Foundation

class DataBaseService : DataBaseServiceDelegate {
    
    var databasePath = ""
    
    var queue:FMDatabaseQueue!
    
    init() {}
    
    // MARK: - Alert table
    func createTable(_ table : String, column: [[String:String]], successHandler : @escaping (Bool) -> Void ) {
        var success = false
        var col = ""
        
        for dict in column {
            for (key,value) in dict {
                col = col + key + " " + value + " "
            }
        }
        
        let statement = "CREATE TABLE \(table) (\(col));"
        
        self.statement(statement) { results in
            success = results
        }
        
        successHandler(success)
    }
    
    // MARK: - Alert table
    
    func alertTable(_ table : String, addColumn: String, type: String, successHandler : @escaping (Bool) -> Void ) {
        var success = false
        
        let statement = "ALERT TABLE \(table) ADD \(addColumn) \(type);"
        
        self.statement(statement) { results in
            success = results
        }
        
        successHandler(success)
    }
    
    func alertTable(_ table : String, dropColumn: String, successHandler : @escaping (Bool) -> Void ) {
        var success = false
        
        let statement = "ALERT TABLE \(table) DROP COLUMN \(dropColumn);"
        
        self.statement(statement) { results in
            success = results
        }
        
        successHandler(success)
    }
    
    func alertTable(_ table : String, renameColumn: String, column: String, successHandler : @escaping (Bool) -> Void ) {
        var success = false
        
        let statement = "ALERT TABLE \(table) RENAME COLUMN \(column) TO \(renameColumn);"
        
        self.statement(statement) { results in
            success = results
        }
        
        successHandler(success)
    }
    
    // MARK: - insert table
    
    func insertTable(_ table : String, column: [String], value : [Any], successHandler : @escaping (Bool) -> Void) {
        var success = false
        
        let col = column.joined(separator: ", ")
        var val = ""
        
        for i in 0..<value.count {
            if value[i] is String {
                val = val + ", '\(value[i])'"
            } else if value[i] is Int {
                val = val + ", \(value[i])"
            }
        }
        
        val.removeFirst()
        
        let statement = "INSERT INTO \(table) (\(col)) VALUES (\(val));"
        
        self.statement(statement) { results in
            success = results
        }
        
        successHandler(success)
    }
    
    // MARK: - delete table
    
    func deleteTable(_ table :  String, where_ : String, successHandler : @escaping (Bool) -> Void) {
        var success = false
        
        let statement = "DELETE FROM \(table) WHERE \(where_);"
        
        self.statement(statement) { results in
            success = results
        }
        
        successHandler(success)
    }
    
    // MARK: - select table
    func selectTable(_ columns : [String]?, table: String, whereCondition : String?, extra: String?, recordBlock : @escaping ([AnyHashable:Any]) -> Void, successHandler : @escaping (Bool) -> Void) {
        var success = false
        var statement = ""
        
        let col = columns?.joined(separator: ",")
        
        if columns == nil {
            statement = "SELECT * FROM \(table);"
        }else if whereCondition == nil && extra == nil {
            statement = "SELECT \(String(describing: col)) FROM \(table);"
        }else if whereCondition != nil && extra == nil {
            statement = "SELECT \(String(describing: col)) FROM \(table) WHERE \(String(describing: whereCondition));"
        }else if whereCondition == nil && extra != nil {
            statement = "SELECT \(String(describing: col)) FROM \(table) \(String(describing: extra));"
        }else{
            statement = "SELECT \(String(describing: col)) FROM \(table) WHERE \(String(describing: whereCondition)) \(String(describing: extra));"
        }
        
        self.statement(statement) { dict in
            recordBlock(dict)
        } successHandler: { results in
            success = results
        }

        successHandler(success)
    }
    
    // MARK: - update table
    func updateTable(_ table :  String, value:[String : Any], where_ : String, successHandler : @escaping (Bool) -> Void) {
        var success = false
        var valueSet = ""
        
        for (key,val) in value {
            if val is String {
                valueSet = valueSet + "," + " " + key + " = " + "'\(val)'"
            } else if val is Int {
                valueSet = valueSet + "," + " " + key + " = " + "\(val)"
            }
        }
        valueSet.removeFirst()
        
        let statement = "UPDATE \(table) SET \(valueSet)  WHERE \(where_);"
        
        self.statement(statement) { results in
            success = results
        }

        successHandler(success)
    }
    
    
    // MARK: - Private function
    
    func statement(_ statement : String, recordBlock : @escaping ([AnyHashable:Any]) -> Void, successHandler : @escaping (Bool) -> Void) {
        var success = false
        
        if databasePath != "" {
            if queue == nil {
                queue = FMDatabaseQueue.init(path: databasePath)
            }
            
            queue.inDatabase { database in
                do {
                    let results = try database.executeQuery(statement, values: nil)
                    while ( results.next()) {
                        let dict = results.resultDictionary!
                        recordBlock(dict)
                        success = true
                    }
                }
                catch {
                    fatalError("Can run query on database")
                }
            }
        }
        successHandler(success)
    }
    
    func statement(_ statement : String, successHandler : @escaping (Bool) -> Void) {
        var success = false
        
        if databasePath != "" {
            if queue == nil {
                queue = FMDatabaseQueue.init(path: self.databasePath)
            }
            
            queue.inDatabase { database in
                do {
                    try database.executeUpdate(statement, values: nil)
                    success = true
                } catch {
                    fatalError("Can run upadte on database")
                }
            }
        }
        
        successHandler(success)
    }
}
