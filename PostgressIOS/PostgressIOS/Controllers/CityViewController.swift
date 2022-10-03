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
    var cityList = [Model.CityInfo]()

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
        
        self.getAllData()
        let citys = self.getCityInCountry()
        
        self.getCurrentTemp(citys: citys)
    }
    
    func setupDatabaseManager() {
        var configuration = PostgresClientKit.ConnectionConfiguration()
        configuration.host = "127.0.0.1"
        configuration.port = 5432
        configuration.database = "postgres"
        configuration.user = "postgres"
        configuration.credential = Credential.scramSHA256(password: "kenshin123")
        configuration.ssl = false
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
        return cityList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CityCells", for: indexPath) as! TableViewCell
        
        DispatchQueue.main.async {
            cell.temp = "\(self.cityList[indexPath.row].temp)"
            cell.name = self.cityList[indexPath.row].city
        }
        
        return cell
    }
    
}

extension CityViewController : DataBaseServiceDelegate {
    func DataBaseServiceDelegateOnStatusConnection(_ status: ConnectionStatusCode) {
        print("Status : \(status)")
    }
    
}

extension CityViewController {
    
    @objc func onAddCity() {
        var city = ""
        
        let alert = UIAlertController.init(title: "Citys", message: nil, preferredStyle: .alert)
        alert.addTextField { textField in
            city = textField.text!
        }
        alert.addAction(UIAlertAction(title: "OK", style: .default,handler: { action in
            city = alert.textFields![0].text!
            self.getCurrentTemp(citys: [city])
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        self.present(alert, animated: true)
        
    }
    
}

extension CityViewController {
    
    func getAllData() {
        self.selectTable { data, successed in
            if successed {
                self.updateValueOfCity(data: data!)
                self.tempoTable.reloadData()
            }
        }
    }
    
    func getCurrentTemp(citys : [String]) {
        
        for city in citys {
            let query = [
                "q" : city,
                "units" : "metric",
                "appid" : Model.apiKey()
            ]
            
            NewAPI.shared.newAPI(path: "/data/2.5/weather", method: "GET", query: query as [String : Any]) { results in
                switch results {
                case .success(let data) :
                    var dataFinal = data
                    if self.cityList.count > 0 {
                        if let index = self.cityList.firstIndex(where: {$0.city == city}) {
                            self.updateValueCity(value: data)
                        } else {
                            self.insertTable(value: data)
                        }
                    }
                    break
                case .failure(let failed) :
                    print("error : \(failed.localizedDescription)")
                    break
                }
            }
        }
    }
    
    func getCityInCountry() -> [String] {
        var citys = [String]()
        
        for city in self.cityList {
            citys.append(city.city)
        }
        
        return citys
    }
    
    func updateValueOfCity(data : [String : Any]) {
        if self.cityList.count > 0 {
            if let index = cityList.firstIndex(where: {$0.id == data["id"] as! Int}) {
                cityList[index].temp = data["temp"] as! String
            } else {
                self.cityList.append(
                    Model.CityInfo.init(
                        id : data["id"] as! Int,
                        city : data["city"] as! String,
                        country : data["country"] as! String,
                        lat : data["lat"] as! String,
                        lon : data["lon"] as! String,
                        temp : data["temp"] as! String,
                        icon : data["icon"] as! String
                    )
                )
            }
        }
    }
}

extension CityViewController {
    
    func updateValueCity(value : [String:Any]) {
        DatabaseService.shared.database?.updateTable("mycitys", value: value, where_: value["id"] as! String , successHandler: { success in
            if success {
                self.getAllData()
            }
        })
    }
    
    func insertTable(value : [String:Any]) {
        
        let value1 = [Any]()
        
        //continue coding here?
        DatabaseService.shared.database?.insertTable("mycitys", column: ["id", "city", "country","lat", "lon", "temp", "icon"], value: value1) { results in
            if results {
                self.getAllData()
            } else {
                print("Insert failed")
            }
        }
        
    }
    
    func selectTable(completionHandler : @escaping ([String:Any]?,Bool) -> Void) {
        DatabaseService.shared.database?.selectTable(nil, table: "mycitys", whereCondition: nil, extra: nil, recordBlock: { results, success  in
            
            if success {
                do {
                    var dict:[String : Any]!
                    dict["id"] = try (results![0] as! PostgresValue).int()
                    dict["city"] = try (results![1] as! PostgresValue).string()
                    dict["country"] = try (results![2] as! PostgresValue).string()
                    dict["lat"] = try (results![3] as! PostgresValue).string()
                    dict["lon"] = try (results![4] as! PostgresValue).string()
                    dict["temp"] = try (results![5] as! PostgresValue).string()
                    dict["icon"] = try (results![6] as! PostgresValue).string()
                    completionHandler(dict,true)
                    return
                } catch {
                    completionHandler(nil,false)
                }
            }
            completionHandler(nil,false)
            
        })
        completionHandler(nil,false)
    }
}

