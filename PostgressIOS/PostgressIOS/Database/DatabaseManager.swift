//
//  DatabaseManager.swift
//  PostgressIOS
//
//  Created by Thien Vu on 02/10/2022.
//

import Foundation
import PostgresClientKit

protocol DataBaseServiceDelegate  : NSObjectProtocol {
    func DataBaseServiceDelegateOnStatusConnection(_ status : ConnectionStatusCode)
}

class DatabaseService {
    
    static let shared = DatabaseService()
    
    var database:DatabaseManager?
    init() {}
    
    public func setupDatabaseWith(_ configuration: PostgresClientKit.ConnectionConfiguration) throws {
        if database == nil {
            database = try DatabaseManager.init(configuration)
        }
    }
    
    
}

class DatabaseManager {
    
    init() {}
    
    var connection:PostgresClientKit.Connection?
    weak var delegate : DataBaseServiceDelegate?
    
    convenience init(_ configuration: PostgresClientKit.ConnectionConfiguration) throws {
        self.init()
        connection = try PostgresClientKit.Connection(configuration: configuration)
    }
    
    func createTable(_ table: String, column: [[String : String]], successHandler: @escaping (Bool) -> Void) {
        //
    }
    
    func alertTable(_ table: String, addColumn: String, type: String, successHandler: @escaping (Bool) -> Void) {
        //
    }
    
    func alertTable(_ table: String, dropColumn: String, successHandler: @escaping (Bool) -> Void) {
        //
    }
    
    func alertTable(_ table: String, renameColumn: String, column: String, successHandler: @escaping (Bool) -> Void) {
        //
    }
    
    func insertTable(_ table: String, column: [String], value: [Any], successHandler: @escaping (Bool) -> Void) {
        
        let col = column.joined(separator: ", ")
        var val = ""
        
        for i in 0..<value.count {
            if value[i] is String {
                val = val + ", '\(value[i])'"
            } else {
                val = val + ", \(value[i])"
            }
        }
        
        val.removeFirst()
        
        let statement = "INSERT INTO \(table) (\(col)) VALUES (\(val));"
        
        do {
            let prepare = try connection?.prepareStatement(text: statement)
//            defer {
//                prepare?.close()
//            }
            let execute = try prepare?.execute()
            
            successHandler(true)
        } catch {
            successHandler(false)
        }
        
    }
    
    func deleteTable(_ table: String, where_: String, successHandler: @escaping (Bool) -> Void) {
        //
    }
    
    func selectTable(_ columns: [String]?, table: String, whereCondition: String?, extra: String?, recordBlock: @escaping ( [Any]? ,Bool ) -> Void) {
        var statement = ""
        
        let col = columns?.joined(separator: ",")
        
        if columns == nil {
            statement = "SELECT * FROM \(table);"
        }else if whereCondition == nil && extra == nil {
            statement = "SELECT \(col!)) FROM \(table);"
        }else if whereCondition != nil && extra == nil {
            statement = "SELECT \(col!) FROM \(table) WHERE \(whereCondition!));"
        }else if whereCondition == nil && extra != nil {
            statement = "SELECT \(col!) FROM \(table) \(extra!);"
        }else{
            statement = "SELECT \(col!) FROM \(table) WHERE \(whereCondition!) \(extra!));"
        }
        
        var results = [Any]()
        
        do {
            let prepare = try connection!.prepareStatement(text: statement)
            defer { prepare.close() }
            
            let cursor = try prepare.execute()
            defer { cursor.close() }
            
            for row in cursor {
                let columns = try row.get().columns
                results = columns
                recordBlock(results,true)
            }
        } catch {
            recordBlock(nil,false)
        }
    }
    
    func updateTable(_ table: String, value: [String : Any], where_: String, successHandler: @escaping (Bool) -> Void) {
        //
    }
    
}
