//
//  ViewController.swift
//  PostgressIOS
//
//  Created by Mac Mini 2021_1 on 22/09/2022.
//

import UIKit
import PostgresClientKit

class CityViewController: UIViewController {
    
    let tempoTable = UITableView()
    
    //private variable
    let cityList = [Model.CityInfo]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setupNavigator()
        self.setupTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupDatabaseManager()
    }
    
    override func didReceiveMemoryWarning() {
        fatalError("Memory warning")
    }
    
    func setupNavigator() {
        self.title = "OpenWeather"
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemGray4
        self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        guard let plusImage = UIImage.init(systemName: "person.fill.badge.plus") else {
            print("ViewController:: Wrong system image name")
            return
        }

        let barButton = UIBarButtonItem.init(image: plusImage, style: .done, target: self, action: #selector(onAddCity))
        barButton.tintColor = .black
        self.navigationController?.navigationBar.items?.first?.rightBarButtonItem = barButton

    }
    
    func setupTableView() {
        self.view.addSubview(tempoTable)
        self.tempoTable.translatesAutoresizingMaskIntoConstraints = false
        self.tempoTable.delegate = self
        self.tempoTable.dataSource = self
        self.tempoTable.register(TableViewCell.self, forCellReuseIdentifier: "CityCells")
        
        
        let contraints = [
            self.tempoTable.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 50),
            self.tempoTable.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.tempoTable.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10),
            self.tempoTable.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10)
        ]
        
        NSLayoutConstraint.activate(contraints)
    }
    
    func setupDatabaseManager() {
        var configuration = PostgresClientKit.ConnectionConfiguration()
        configuration.host = ""
        configuration.port = 80
        configuration.database = ""
        configuration.credential = Credential.scramSHA256(password: "")
        do {
            try DatabaseService.shared.setupDatabaseWith(configuration)
            DatabaseService.shared.database!.delegate = self
        } catch {
            print("Connect to sever error")
        }
    }
    
}

extension CityViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4 /*cityList.count*/
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CityCells", for: indexPath) as! TableViewCell
        
        DispatchQueue.main.async {
            cell.temp = "30.0"
            cell.name = "Ho Chi Minh"
        }
        
        return cell
    }
    
}

extension CityViewController : DataBaseServiceDelegate {
    func DataBaseServiceDelegateOnStatusConnection(_ status: ConnectionStatusCode) {
        print("error : \(status)")
    }
    
    
}

extension CityViewController {
    
    @objc func onAddCity() {
        DatabaseService.shared.database!.insertTable("", column: [], value: []) { results in
            //
        }
    }
    
}

