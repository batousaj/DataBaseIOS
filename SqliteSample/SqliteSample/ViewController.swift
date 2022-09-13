//
//  ViewController.swift
//  SqliteSample
//
//  Created by Thien Vu on 11/09/2022.
//

import UIKit

class ViewController: UIViewController {
    
    let nameList = UITableView()
    
    @IBOutlet weak var navigator: UINavigationBar!
    
    let nameInfo = [NameInfo]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        createUIView()
    }

    func createUIView() {
        setUINavigatorView()
        createTableNameList()
    }
    
    func setUINavigatorView() {
        navigator.items?.first?.title = "Particapant list"
        
        guard let plusImage = UIImage.init(systemName: "person.fill.badge.plus") else {
            print("SqliteSample:: Wrong system image name")
            return
        }
        
        let barButton = UIBarButtonItem.init(image: plusImage, style: .done, target: self, action: #selector(onAddNameList))
//        self.navigator.navigationItem.rightBarButtonItem = barButton
    }
    
    func createTableNameList() {
        self.view.addSubview(nameList)
        nameList.translatesAutoresizingMaskIntoConstraints = false
        nameList.delegate = self
        nameList.dataSource = self
        nameList.register(ViewCellCustom.self, forCellReuseIdentifier: "ListNameCell")
        
        let contraints = [
            self.nameList.topAnchor.constraint(equalTo: self.navigator.bottomAnchor, constant: 10),
            self.nameList.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.nameList.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.nameList.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ]
                
        NSLayoutConstraint.activate(contraints)
    }
    
    
}

