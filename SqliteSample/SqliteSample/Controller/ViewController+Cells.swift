//
//  ViewController+Cells.swift
//  SqliteSample
//
//  Created by Thien Vu on 11/09/2022.
//

import Foundation
import UIKit

class ViewCellCustom : UITableViewCell {
    
    let name:UILabel = {
        let name = UILabel()
        name.translatesAutoresizingMaskIntoConstraints = false
        name.clipsToBounds = true
        name.textAlignment = .left
        name.textColor = .black
        name.font = .systemFont(ofSize: 25)
        return name
    }()
    
    let age = UILabel()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.name.text = ""
        self.age.text = ""
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.age.translatesAutoresizingMaskIntoConstraints = false
        self.age.clipsToBounds = true
        self.age.textAlignment = .left
        self.age.textColor = .black
        self.age.font = .systemFont(ofSize: 15)

        let contraints = [
            self.name.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20),
            self.name.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -20),
            self.name.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5),
            self.name.heightAnchor.constraint(equalToConstant: 30)
        ]
        
        NSLayoutConstraint.activate(contraints)
        
        let contraints1 = [
            self.age.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20),
            self.age.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -20),
            self.age.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 40),
            self.age.heightAnchor.constraint(equalToConstant: 20)
        ]
        
        NSLayoutConstraint.activate(contraints1)
        
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(self.name)
        self.contentView.addSubview(self.age)
    }
    
    func setDataForCell(_ name : String, age : String) {
        self.name.text = name
        self.age.text = age
    }
}
