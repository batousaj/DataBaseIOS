//
//  ViewController+Cells.swift
//  PostgressIOS
//
//  Created by Thien Vu on 01/10/2022.
//

import Foundation
import UIKit

class TableViewCell : UITableViewCell {
    
    let title:UILabel! = {
        let tile = UILabel()
        tile.translatesAutoresizingMaskIntoConstraints = false
        tile.clipsToBounds = true
        tile.textAlignment = .left
        tile.textColor = .black
        tile.font = .boldSystemFont(ofSize: 25)

        return tile
    }()
    
    let tempo:UILabel! = {
        let tile = UILabel()
        tile.translatesAutoresizingMaskIntoConstraints = false
        tile.clipsToBounds = true
        tile.textAlignment = .left
        tile.textColor = .black
        tile.font = .systemFont(ofSize: 15)

        return tile
    }()
    
    public var name : String! {
        didSet {
            self.title.text = name
        }
    }
    
    public var temp : String! {
        didSet {
            self.tempo.text = temp
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.name = ""
        self.temp = ""
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.contentView.addSubview(self.title)
        self.contentView.addSubview(self.tempo)
        
        let contraints = [
            self.title.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20),
            self.title.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -20),
            self.title.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5),
            self.title.heightAnchor.constraint(equalToConstant: 30)
        ]
        
        NSLayoutConstraint.activate(contraints)
        
        let contraints1 = [
            self.tempo.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20),
            self.tempo.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -20),
            self.tempo.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 40),
            self.tempo.heightAnchor.constraint(equalToConstant: 20)
        ]
        
        NSLayoutConstraint.activate(contraints1)
    }

}
