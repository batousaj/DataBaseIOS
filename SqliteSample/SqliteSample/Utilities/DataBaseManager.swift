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
    
    func createFileDirectoryDatabase(_ completionHandler : @escaping (String, Bool) -> Void) {
        let fileManager = FileManager.default
        let directory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let url = NSURL(fileURLWithPath: directory[0])
        if let component = url.appendingPathComponent("userinfo.sqlite") {
            if fileManager.fileExists(atPath: component.path) {
                completionHandler("File was exist", false)
            } else {
                do {
                    try fileManager.createDirectory(at: component, withIntermediateDirectories: true)
                    completionHandler("", true)
                }
                catch {
                    completionHandler("Can not create fiel derectory", false)
                }
            }
        }
    }
    
    func createNewTable(_ table : String, value : [[String:String]]) -> Bool {
        var complete = false
        self.service.createTable(Model.table, column: "") { results in
            if results {
                print("Create Table \(Model.table) complete")
                complete = true
            }
        }
        return complete
    }
    
    func doParticipant(_ participant : [String:String], action: String) -> Bool {
        var complete = false
        
        if participant.count > 2 {
            if action == Model.ADD {
                for (key,value) in participant {
                    self.service.insertTable(Model.table, column: key, value: [value]) { results in
                        if results {
                            print("Add value complete")
                            complete = true
                        }
                    }
                }
                return complete
                
            } else if action == Model.UPDATE {
                for (key,value) in participant {
                    self.service.updateTable(Model.table, value: [value], where: key, successHandler: {  results in
                        if results {
                            print("Update value complete")
                            complete = true
                        }
                    })
                }
                return complete
                
            } else if action == Model.DELETE {
                for key in participant.keys {
                    self.service.deleteTable(Model.table, where: [key]) { results in
                        if results {
                            print("delete value complete")
                            complete = true
                        }
                    }
                }
                return complete
            }
        }
        return complete
    }
    
    func getParticipant(_ recordBlock : @escaping ([[String]]) -> Void) {
        self.service.selectTable([Model.name,Model.age,Model.address],
                                 from: Model.table,
                                 where: "",
                                 extra: "") { dictionary in
            recordBlock(dictionary)
        } successHandler: { results in
            if results {
                print("DataBaseManager:: get data complete ")
            }
        }

    }
}
