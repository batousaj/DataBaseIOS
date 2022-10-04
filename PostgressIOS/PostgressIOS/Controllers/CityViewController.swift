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
    var iconList = [Model.IconCity]()

    var callbackCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setupNavigator()
        self.setupDatabaseManager()
        self.setupTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.setupDatabaseManager()
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
        
        self.flechData()
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
    
    func flechData() {
        self.getAllData(reload : false)
        let citys = self.getCityInCountry()
        self.getCurrentTemp(citys: citys)
        
        Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { timer in
            self.callbackCount = 0
            self.getCurrentTemp(citys: citys)
        }
    }
    
}

extension CityViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.callbackCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CityCells", for: indexPath) as! TableViewCell
        
        if self.iconList[indexPath.row].image.count > 0 {
            cell.temp = "\(self.cityList[indexPath.row].temp)"
            cell.name = self.cityList[indexPath.row].city
            cell.image = UIImage(data: self.iconList[indexPath.row].image)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let cell = tableView.cellForRow(at: indexPath) as! TableViewCell

        let more = UIContextualAction(style: .normal, title: "More", handler: { action, view, handler in
            handler(true)
        })
        
        let delete = UIContextualAction(style: .destructive, title: "Delete", handler: { action, view, handler in
            self.deleteTable(condition: cell.name ) { success in
                if success {
                    self.callbackCount-=1
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                    if let index = self.cityList.firstIndex(where: {$0.city == cell.name}) {
                        self.cityList.remove(at: index)
                    }
                    if let index = self.iconList.firstIndex(where: {$0.city == cell.name}) {
                        self.iconList.remove(at: index)
                    }
                    self.tempoTable.reloadData()
                }
            }
            handler(true)
        })
        
        let configuration = UISwipeActionsConfiguration(actions: [delete,more])
        return configuration
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
    
    func getAllData(reload : Bool) {
        self.selectTable { data, successed in
            if successed {
                print("Updated data")
                self.updateIconOfCity(data: data!)
                self.updateValueOfCity(data: data!)
                if reload {
                    DispatchQueue.main.async {
                        self.tempoTable.reloadData()
                    }
                }
            } else {
                print("Updated data failed")
            }
        }
    }
    
    func getCurrentTemp(citys : [String]) {
        print("getCurrentTemp")
        for city in citys {
            let query = [
                "q" : city,
                "units" : "metric",
                "appid" : Model.apiKey()
            ]
            
            NewAPI.shared.newAPI(path: "/data/2.5/weather", method: "GET", query: query as [String : Any]) { results in
                switch results {
                case .success(let data) :
                    
                    let dict = self.collectData(data: data,city: city)
                    
                    if self.cityList.count > 0 {
                        if self.cityList.firstIndex(where: {$0.city == city}) != nil {
                            self.updateImageIcon(dict: dict, type: "update")
                        } else {
                            self.updateImageIcon(dict: dict, type: "add")
                        }
                    } else {
                        self.updateImageIcon(dict: dict, type: "add")
                    }
                    break
                case .failure(let failed) :
                    print("error : \(failed.localizedDescription)")
                    break
                }
            }
        }
    }
    
    func updateImageIcon(dict: [String : Any], type : String) {
        NewAPI.shared.downloadIcon(path: "/img/wn/\(dict["icon"] as! String)@2x.png") { results in
            switch (results) {
            case .success(let data) :
                if type == "add" {
                    self.iconList.append(Model.IconCity(city: dict["city"] as! String, icon: dict["icon"] as! String, image: data))
                    self.insertTable(value: dict)
                    
                } else {
                    if let index = self.iconList.firstIndex(where: {$0.city == dict["city"] as! String}) {
                        self.iconList[index].icon = dict["icon"] as! String
                        self.iconList[index].image = data
                    }
                    self.updateValueCity(value: dict)
                    print("self.iconList : \(self.iconList.count)")
                }
                break
                
            case .failure(let error) :
                print("error : \(error.localizedDescription)")
                break
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
            if let index = cityList.firstIndex(where: {$0.id == NumberFormatter().number(from: data["id"] as! String) as! Int}) {
                cityList[index].temp = data["temp"] as! String
            } else {
                self.cityList.append(
                    Model.CityInfo.init(
                        id : NumberFormatter().number(from: data["id"] as! String) as! Int,
                        city : data["city"] as! String,
                        country : data["country"] as! String,
                        lat : data["lat"] as! String,
                        lon : data["lon"] as! String,
                        temp : data["temp"] as! String,
                        icon : data["icon"] as! String
                    )
                )
            }
        } else {
            self.cityList.append(
                Model.CityInfo.init(
                    id : NumberFormatter().number(from: data["id"] as! String) as! Int,
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
    
    func updateIconOfCity(data : [String : Any]) {
        if self.iconList.count > 0 {
            if let index = iconList.firstIndex(where: {$0.city == data["city"] as! String}) {
                self.iconList[index].icon = data["icon"] as! String
            } else {
                self.iconList.append(
                    Model.IconCity.init(
                        city : data["city"] as! String,
                        icon : data["icon"] as! String,
                        image : Data()
                    )
                )
            }
        } else {
            self.iconList.append(
                Model.IconCity.init(
                    city : data["city"] as! String,
                    icon : data["icon"] as! String,
                    image : Data()
                )
            )
        }
    }
    
    func collectData(data : Package.Results, city : String) -> [String : Any] {
        var results = [String:Any]()
        results["id"] = data.id
        results["city"] = city
        results["country"] = data.sys.country
        results["lat"] = data.coord.lat
        results["lon"] = data.coord.lon
        results["temp"] = data.main.temp
        results["icon"] = data.weather.first!.icon
        
        return results
    }
}

extension CityViewController {
    
    func updateValueCity(value : [String:Any]) {
        let id = "id = \(value["id"]!)"
        self.callbackCount+=1
        DatabaseService.shared.database?.updateTable("mycitys", value: value, where_: id , successHandler: { success in
            if self.callbackCount == self.iconList.count {
                self.getAllData(reload: true)
            }
        })
    }
    
    func insertTable(value : [String:Any]) {
        
        var col = [String]()
        var row = [Any]()
        
        value.forEach {
            col.append($0)
            row.append($1)
        }
        
        self.callbackCount+=1
        //continue coding here?
        DatabaseService.shared.database?.insertTable("mycitys", column: col, value: row) { results in
            if results {
                if self.callbackCount == self.iconList.count {
                    self.getAllData(reload: true)
                }
            } else {
                print("Insert failed")
            }
        }
        
    }
    
    func selectTable(completionHandler : @escaping ([String:Any]?,Bool) -> Void) {
        DatabaseService.shared.database?.selectTable(nil, table: "mycitys", whereCondition: nil, extra: nil, recordBlock: { results, success  in
            
            if success {
                do {
                    var dict = [String : Any]()
                    dict["id"] = try (results![0] as! PostgresValue).string()
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
    
    func deleteTable(condition : String, completionHandler : @escaping (Bool) -> Void) {
        DatabaseService.shared.database?.deleteTable("mycitys", where_: "city = '\(condition)'", successHandler: { successed in
            completionHandler(successed)
        })
    }
}

