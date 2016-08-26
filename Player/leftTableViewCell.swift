//
//  letTableViewCell.swift
//  Player
//
//  Created by kung on 16/8/19.
//  Copyright © 2016年 kung. All rights reserved.
//

import UIKit

class leftTableViewCell: UITableViewCell {

    @IBOutlet weak var labelName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        labelName.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.5)
        labelName.layer.cornerRadius = 10
        labelName.layer.borderWidth = 2
        labelName.layer.borderColor = UIColor.whiteColor().CGColor
        labelName.layer.masksToBounds = true
        labelName.highlightedTextColor = UIColor.whiteColor()

    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
