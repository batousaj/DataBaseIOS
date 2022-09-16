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
        self.service.createTable(Model.table, column: value) { results in
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
                self.service.insertTable(Model.table, column: col, value: val) { results in
                    if results {
                        print("Add value complete")
                        complete = true
                    }
                }
                return complete
                
            } else if action == Model.UPDATE {
                condition = "\(Model.id) = \(String(describing: participant[Model.id]!))"
                self.service.updateTable(Model.table, value: participant, where_: condition, successHandler: {  results in
                    if results {
                        print("Update value complete")
                        complete = true
                    }
                })
                return complete
                
            } else if action == Model.DELETE {
                condition = "\(Model.id) = \(String(describing: participant[Model.id]!))"
                self.service.deleteTable(Model.table, where_: condition) { results in
                    if results {
                        print("delete value complete")
                        complete = true
                    }
                }
                return complete
            }
        }
        return complete
    }
    
    func getParticipant(_ recordBlock : @escaping ([String:String]) -> Void) {
        var dict = [String:String]()
        self.service.selectTable(nil,
                                 table: Model.table,
                                 whereCondition: nil,
                                 extra: nil) { dictionary in
            for (key,value) in dictionary {
                dict[key as! String] = "\(value)"
            }
            recordBlock(dict)
        } successHandler: { results in
            if results {
                print("DataBaseManager:: get data complete ")
            }
        }

    }
}
