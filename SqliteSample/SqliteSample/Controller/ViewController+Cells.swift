//
//  ViewController+Cells.swift
//  SqliteSample
//
//  Created by Thien Vu on 11/09/2022.
//

import Foundation
import UIKit

class ViewCellCustom : UITableViewCell {
    
    let name = UILabel()
    
    let age = UILabel()
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    func createCellView() {
        
    }
}
