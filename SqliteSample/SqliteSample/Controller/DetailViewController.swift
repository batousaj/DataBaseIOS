//
//  DetailViewController.swift
//  SqliteSample
//
//  Created by Mac Mini 2021_1 on 13/09/2022.
//

import Foundation
import UIKit

enum StateEdit {
    case save
    case edit
}

class DetailViewController : UIViewController {
    
    let titleOver = UILabel()
    
    let name = UITextField()
    let age = UITextField()
    let address = UITextField()
    
    let editting = UIButton()
    
    var nameInfo:Model.NameInfo!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overview()
        if (!isModal) {
            self.createEditView(StateEdit.save)
            self.createViewInfoWith(name: nil, age: nil, address: nil)
        } else {
            self.createEditView(StateEdit.edit)
            self.createViewInfoWith(name: self.nameInfo.name, age: self.nameInfo.age, address: self.nameInfo.address)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    public func getDataFromTable(_ model : Model.NameInfo) {
        self.nameInfo = model
    }
    
    func overview() {
        self.view.addSubview(self.titleOver)
        self.titleOver.translatesAutoresizingMaskIntoConstraints = false
        
        self.titleOver.text = "User Info"
        self.titleOver.font = UIFont.systemFont(ofSize: 25)
        self.titleOver.textAlignment = .center
        self.titleOver.textColor = .black
        
        let contraints = [
            self.titleOver.topAnchor.constraint(equalTo: self.view.topAnchor , constant: 100),
            self.titleOver.heightAnchor.constraint(equalToConstant: 50),
            self.titleOver.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 100),
            self.titleOver.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -100)
        ]
        NSLayoutConstraint.activate(contraints)
        
    }
    
    func createEditView(_ state: StateEdit ) {
        self.view.addSubview(self.editting)
        self.editting.translatesAutoresizingMaskIntoConstraints = false
        
        self.editting.addTarget(self, action: #selector(OnClickEditting), for: .touchUpInside)
        self.changeNameEditting(state: state)
        self.editting.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        self.editting.setTitleColor(.tintColor, for: .normal)
        self.editting.titleLabel?.textAlignment = .center
        
        let contraintsEdit = [
            self.editting.topAnchor.constraint(equalTo: self.view.topAnchor , constant: 100),
            self.editting.heightAnchor.constraint(equalToConstant: 50),
            self.editting.leadingAnchor.constraint(equalTo: self.titleOver.trailingAnchor, constant: 30),
            self.editting.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10)
        ]
        NSLayoutConstraint.activate(contraintsEdit)
    }
    
    func createViewInfoWith(name : String?, age : String?, address : String?) {
        self.view.addSubview(self.name)
        self.name.translatesAutoresizingMaskIntoConstraints = false
        self.name.backgroundColor = .systemGray6
        if name != nil {
            self.name.text = name
        }
        
        self.view.addSubview(self.age)
        self.age.translatesAutoresizingMaskIntoConstraints = false
        self.age.backgroundColor = .systemGray6
        if age != nil {
            self.age.text = age
        }

        self.view.addSubview(self.address)
        self.address.translatesAutoresizingMaskIntoConstraints = false
        self.address.backgroundColor = .systemGray6
        if address != nil {
            self.address.text = address
        }
        
        if name != nil && age != nil && address != nil {
            setEnableTextFieled(true)
        }

        let contraintsName = [
            self.name.topAnchor.constraint(equalTo: self.titleOver.topAnchor , constant: 100),
            self.name.heightAnchor.constraint(equalToConstant: 40),
            self.name.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 50),
            self.name.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -100)
        ]
        
        NSLayoutConstraint.activate(contraintsName)
        
        let contraintsAge = [
            self.age.topAnchor.constraint(equalTo: self.name.topAnchor , constant: 100),
            self.age.heightAnchor.constraint(equalToConstant: 40),
            self.age.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 50),
            self.age.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -100)
        ]
        
        NSLayoutConstraint.activate(contraintsAge)
        
        let contraintsAddress = [
            self.address.topAnchor.constraint(equalTo: self.age.topAnchor , constant: 100),
            self.address.heightAnchor.constraint(equalToConstant: 40),
            self.address.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 50),
            self.address.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -100)
        ]
        
        NSLayoutConstraint.activate(contraintsAddress)
    }
    
    func changeNameEditting( state: StateEdit ) {
        if state == StateEdit.save {
            self.editting.setTitle("Save", for: .normal)
        } else {
            self.editting.setTitle("Edit", for: .normal)
        }
    }
    
    func setEnableTextFieled(_ enable : Bool) {
        self.name.isUserInteractionEnabled = enable
        self.age.isUserInteractionEnabled = enable
        self.address.isUserInteractionEnabled = enable
    }
}

// MARK: - UIViewController implementation

extension DetailViewController {

    var isModal: Bool {
        let presentingIsNavigation = navigationController?.presentingViewController?.presentedViewController == navigationController

        return presentingIsNavigation
    }
    
    @objc func OnClickEditting() {
        print("SqliteSample:: OnClickEditting")
        
        if self.editting.titleLabel?.text == "Save" {
                        
            if let nameT = self.name.text, let ageT = self.age.text, let addressT = self.address.text, nameT != "" && ageT != "" && addressT != "" {
                let data = [Model.name : nameT,
                            Model.age  : ageT,
                            Model.address : addressT]
                
                if (!isModal) {
                    let results = DataBaseManager.sharedInstance.doParticipant(data, action: Model.ADD)
                    if results {
                        self.navigationController?.popViewController(animated: true)
                    } else {
                        if let alertController = UIAlertController.alertActionWarning(message: "Error when set user info", completion: { action in
                            if action != nil {
                                //
                            }
                        }) {
                            self.present(alertController, animated: true)
                        }
                    }
                } else {
                    let results = DataBaseManager.sharedInstance.doParticipant(data, action: Model.UPDATE)
                    if results {
                        self.dismiss(animated: true)
                    } else {
                        if let alertController = UIAlertController.alertActionWarning(message: "Error when set user info", completion: { action in
                            if action != nil {
                                //
                            }
                        }) {
                            self.present(alertController, animated: true)
                        }
                    }
                }
                
            } else {
                if let alertController = UIAlertController.alertActionWarning(message: "Some infomation is empty", completion: { action in
                    if action != nil {
                        //
                    }
                }) {
                    self.present(alertController, animated: true)
                }
                return
            }
            
        }
        
        if self.editting.titleLabel?.text == "Edit" {
            setEnableTextFieled(true)
            changeNameEditting(state: StateEdit.save)
        }
        
    }
}
