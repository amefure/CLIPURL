//
//  CategoryTableViewCell.swift
//  URList
//
//  Created by t&a on 2022/10/13.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {
    
    // MARK: - Outlet
    @IBOutlet  private weak var categoryLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - init
    func create(_ category:String){
        categoryLabel.text = category
    }

}
