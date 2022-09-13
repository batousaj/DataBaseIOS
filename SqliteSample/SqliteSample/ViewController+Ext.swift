//
//  ViewController+Ext.swift
//  SqliteSample
//
//  Created by Thien Vu on 11/09/2022.
//

import Foundation
import UIKit

extension ViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return nameInfo.count
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListNameCell", for: indexPath) as! ViewCellCustom
        cell.createCellView()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("SqliteSample:: didSelectRowAt")
        let storyboard = UIStoryboard.init(name: "DetailView", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "DetailView") as! DetailViewController
        let navigator = UINavigationController.init(rootViewController: viewController)
        self.navigationController?.present(navigator, animated: true)
        
    }
    
    @objc func onAddNameList() {
        print("SqliteSample:: Add name list")
        let storyboard = UIStoryboard.init(name: "DetailView", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "DetailView") as! DetailViewController
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
}
