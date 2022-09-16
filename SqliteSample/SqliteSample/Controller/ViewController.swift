//
//  ViewController.swift
//  SqliteSample
//
//  Created by Thien Vu on 11/09/2022.
//

import UIKit

class ViewController: UIViewController {
    
    let nameList = UITableView()
    
    var nameInfo = [Model.NameInfo]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.registerNotification()
        createUIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !self.checkExistFileManager("userinfo.sqlite") { // file do not exist
            DataBaseManager.sharedInstance.createFileDirectoryDatabase("userinfo.sqlite") { comment, successed in
                if successed {
                    print("ViewController:: Create file successed")
                } else {
                    fatalError("DataBaseManager:: \(comment)")
                }
            }
            
            if self.createTableValue() {
                print("ViewController:: Create TABLE \(Model.table) successed")
            } else {
                fatalError("DataBaseManager::  Create TABLE \(Model.table) failed")
            }
            
        } else {
            if !self.fecthData() {
                print("ViewController:: No have data on data base")
            } else {
                nameList.reloadData()
            }
        }
    }
    
    func registerNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(OnBackAfterPresent), name: Notification.Name("kWillAppearAfterPresent"), object: nil)
    }

    func createUIView() {
        setUINavigatorView()
        createTableNameList()
    }
    
    func setUINavigatorView() {
        
        self.title = "Particapant list"
        self.navigationController?.navigationBar.backgroundColor = .systemGray6
        
        guard let plusImage = UIImage.init(systemName: "person.fill.badge.plus") else {
            print("SqliteSample:: Wrong system image name")
            return
        }

        let barButton = UIBarButtonItem.init(image: plusImage, style: .done, target: self, action: #selector(onAddNameList))
        barButton.tintColor = .black
        self.navigationController?.navigationBar.items?.first?.rightBarButtonItem = barButton
    }
    
    func createTableNameList() {
        self.view.addSubview(nameList)
        nameList.translatesAutoresizingMaskIntoConstraints = false
        nameList.delegate = self
        nameList.dataSource = self
        nameList.register(ViewCellCustom.self, forCellReuseIdentifier: "ListNameCell")
        
        let contraints = [
            self.nameList.topAnchor.constraint(equalTo: self.view.topAnchor , constant: 120),
            self.nameList.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.nameList.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.nameList.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20)
        ]
                
        NSLayoutConstraint.activate(contraints)
    }
    
    func fecthData() -> Bool {
        
        self.nameInfo = Model.fecthData()
        
        if self.nameInfo.count > 0 {
            return true
        }
        
        return false
    }
    
    func checkExistFileManager(_ name :  String) -> Bool {
        let search = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let path = search[0] as String
        let url = NSURL(fileURLWithPath: path)
        if let component = url.appendingPathComponent(name) {
            let file = component.path
            let fileManager = FileManager.default
            if fileManager.fileExists(atPath: file) {
                DataBaseManager.sharedInstance.service.databasePath = component.path
                return true
            } else {
                return false
            }
        }
        
        return false
    }
    
    func createTableValue() -> Bool {
        var column = [[String:String]]()
        column.append(contentsOf:
            [[Model.id       : "INT PRIMARY KEY NOT NULL,"],
             [Model.name     : "TEXT NOT NULL,"],
             [Model.age      : "INT NOT NULL,"],
             [Model.address  : "CHAR(50) NOT NULL"]]
        )
        
        return DataBaseManager.sharedInstance.createNewTable("\(Model.table)", value: column)
    }
}

