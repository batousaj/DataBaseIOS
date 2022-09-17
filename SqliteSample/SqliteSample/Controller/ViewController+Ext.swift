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
        return nameInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListNameCell", for: indexPath) as! ViewCellCustom
        cell.setDataForCell(self.nameInfo[indexPath.row].name, age: self.nameInfo[indexPath.row].age)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let success = DataBaseManager.sharedInstance.deleteParticipant("\(self.nameInfo[indexPath.row].id)")
            self.nameInfo.remove(at: indexPath.row)
            if success {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        } else {
            //
        }
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        self.nameInfo.swapAt(sourceIndexPath.row, destinationIndexPath.row)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("SqliteSample:: didSelectRowAt")
        let cell = tableView.cellForRow(at: indexPath) as! ViewCellCustom
        let storyboard = UIStoryboard.init(name: "DetailView", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "DetailView") as! DetailViewController
        
        self.nameInfo.forEach { info in
            if info.name == cell.name.text {
                viewController.getDataFromTable(info, id: indexPath.row)
            }
        }
        
        let navigator = UINavigationController.init(rootViewController: viewController)
        self.navigationController?.present(navigator, animated: true)
    }
    
    @objc func onAddNameList() {
        print("SqliteSample:: Add name list")
        let storyboard = UIStoryboard.init(name: "DetailView", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "DetailView") as! DetailViewController
        if nameInfo.count > 0 {
            var haveID = false
            for i in 0..<self.nameInfo.last!.id {
                if !identify.contains(i) {
                    haveID = true
                    viewController.getDataFromTable(nil, id: i)
                    break;
                }
            }
            if !haveID {
                viewController.getDataFromTable(nil, id: self.nameInfo.last!.id  + 1)
            }
        }
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc func OnBackAfterPresent() {
        if !self.fecthData() {
            print("ViewController:: No have data on data base")
        }
    }
    
    @objc func OnTouchTable() {
        NotificationCenter.default.post(name: NSNotification.Name("kWillTouchTableView"), object: true)
    }
    
    @objc func OnEndTouchTable() {
        NotificationCenter.default.post(name: NSNotification.Name("kWillTouchTableView"), object: false)
    }
    
    @objc func OnTouchTableView(notification: Notification) {
        let data = notification.object as! Bool
        self.nameList.isEditing = data
    }
    
}
