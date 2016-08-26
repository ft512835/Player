//
//  viewTVCell.swift
//  Player
//
//  Created by kung on 16/8/8.
//  Copyright © 2016年 kung. All rights reserved.
//

import UIKit

class viewTVCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
   
    @IBOutlet weak var created: UILabel!
    
    @IBOutlet weak var discribe: UILabel!
    
    @IBOutlet weak var icon: UIImageView!
    
    @IBOutlet weak var infoView: UIView!
    
    var url: String!
    
    
    override func awakeFromNib() {
        
        infoView.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.5)
                
    }
    
    override func setSelected( selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
