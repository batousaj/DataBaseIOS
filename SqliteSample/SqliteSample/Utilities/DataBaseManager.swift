//
//  DataBaseManager.swift
//  SqliteSample
//
//  Created by Mac Mini 2021_1 on 13/09/2022.
//

import Foundation

public protocol DataBaseServiceDelegate {
    func createTable(_ table : String, column: [[String:String]], successHandler : @escaping (Bool) -> Void )
    
    func alertTable(_ table : String, addColumn: String, type: String, successHandler : @escaping (Bool) -> Void )
    func alertTable(_ table : String, dropColumn: String, successHandler : @escaping (Bool) -> Void )
    func alertTable(_ table : String, renameColumn: String, column: String, successHandler : @escaping (Bool) -> Void )
    
    func insertTable(_ table : String, column: [String], value : [Any], successHandler : @escaping (Bool) -> Void)
    
    func deleteTable(_ table :  String, where_ : String, successHandler : @escaping (Bool) -> Void)
    
    func selectTable(_ columns : [String]?, table: String, whereCondition : String?, extra: String?, recordBlock : @escaping ([AnyHashable:Any]) -> Void, successHandler : @escaping (Bool) -> Void)
    
    func updateTable(_ table :  String, value:[String : Any], where_ : String, successHandler : @escaping (Bool) -> Void)
    
    func statement(_ statement : String, recordBlock : @escaping ([AnyHashable:Any]) -> Void, successHandler : @escaping (Bool) -> Void)
    func statement(_ statement : String, successHandler : @escaping (Bool) -> Void)
}

class DataBaseManager {
    
    static let sharedInstance = DataBaseManager()
    
    var service:DataBaseService!
    open var delegate:DataBaseServiceDelegate?
    
    init() {
        self.createDatabaseService()
    }
    
    func createDatabaseService() {
        if ( service == nil) {
            service = DataBaseService()
            self.delegate = service
        }
    }
    
    func createFileDirectoryDatabase(_ name: String, completionHandler : @escaping (String, Bool) -> Void) {
        let fileManager = FileManager.default
        let directory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let url = NSURL(fileURLWithPath: directory[0])
        if let component = url.appendingPathComponent(name) {
            if fileManager.fileExists(atPath: component.path) {
                completionHandler("File was exist", false)
            } else {
                fileManager.createFile(atPath: component.path, contents: nil)
                DataBaseManager.sharedInstance.service.databasePath = component.path
                completionHandler("", true)
            }
        }
    }
    
    func createNewTable(_ table : String, value : [[String:String]]) -> Bool {
        var complete = false
        self.delegate!.createTable(Model.table, column: value) { results in
            if results {
                print("Create Table \(Model.table) complete")
                complete = true
            }
        }
        return complete
    }
    
    func doParticipant(_ participant : [String:Any], action: String) -> Bool {
        var complete = false
        var col = [String]()
        var val = [Any]()
        var condition = ""
        
        if participant.count > 2 {
            if action == Model.ADD {
                col = participant.map({ $0.key })
                val = participant.map({ $0.value})
                self.delegate!.insertTable(Model.table, column: col, value: val) { results in
                    if results {
                        print("Add value complete")
                        complete = true
                    }
                }
                return complete
                
            } else if action == Model.UPDATE {
                condition = "\(Model.id) = \(String(describing: participant[Model.id]!))"
                self.delegate!.updateTable(Model.table, value: participant, where_: condition, successHandler: {  results in
                    if results {
                        print("Update value complete")
                        complete = true
                    }
                })
                return complete
            }
        }
        return complete
    }
    
    func deleteParticipant(_ id: String)  -> Bool {
        var complete = false
        
        self.delegate!.deleteTable(Model.table, where_: "\(Model.id) = \(id)") { results in
            if results {
                print("delete value complete")
                complete = true
            }
        }
        return complete
    }
    
    func getParticipant(_ recordBlock : @escaping ([String:Any]) -> Void) {
        var dict = [String:Any]()
        self.delegate!.selectTable(nil,
                                 table: Model.table,
                                 whereCondition: nil,
                                 extra: nil) { dictionary in
            for (key,value) in dictionary {
                dict[key as! String] = value
            }
            recordBlock(dict)
        } successHandler: { results in
            if results {
                print("DataBaseManager:: get data complete ")
            }
        }
    }
}
