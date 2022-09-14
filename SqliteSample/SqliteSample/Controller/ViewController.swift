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
        createUIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !self.checkExistFileManager() { // file do not exist
            DataBaseManager.sharedInstance.createNewTable("userinfo.sqlite")
        } else {
            if !self.fecthData() {
                fatalError("ViewController :: No have data on data base")
            }
        }
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
    
    func checkExistFileManager() -> Bool {
        let search = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let path = search[0] as String
        let url = NSURL(fileURLWithPath: path)
        if let component = url.appendingPathComponent("userinfo.sqlite") {
            let file = component.path
            let fileManager = FileManager.default
            if fileManager.fileExists(atPath: file) {
                return true
            } else {
                return false
            }
        }
        
        return false
    }
    
}

