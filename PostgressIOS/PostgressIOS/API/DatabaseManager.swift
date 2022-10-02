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
        if database != nil {
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
        //
    }
    
    func deleteTable(_ table: String, where_: String, successHandler: @escaping (Bool) -> Void) {
        //
    }
    
    func selectTable(_ columns: [String]?, table: String, whereCondition: String?, extra: String?, recordBlock: @escaping ([AnyHashable : Any]) -> Void, successHandler: @escaping (Bool) -> Void) {
        //
    }
    
    func updateTable(_ table: String, value: [String : Any], where_: String, successHandler: @escaping (Bool) -> Void) {
        //
    }
    
    func statement(_ statement: String, recordBlock: @escaping ([AnyHashable : Any]) -> Void, successHandler: @escaping (Bool) -> Void) {
        //
    }
    
    func statement(_ statement: String, successHandler: @escaping (Bool) -> Void) {
        //
    }
    
}
