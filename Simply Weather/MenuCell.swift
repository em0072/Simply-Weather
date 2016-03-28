//
//  MenuCell.swift
//  SimplyWeather
//
//  Created by Митько Евгений on 20.01.16.
//  Copyright © 2016 Evgeny Mitko. All rights reserved.
//

import UIKit

class MenuCell: UITableViewCell {

    @IBOutlet weak var cityNameLabel: UILabel?
    @IBOutlet weak var tempLabel: UILabel?
    @IBOutlet weak var weatherIcon: UIImageView?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
       // self.selectionStyle = UITableViewCellSelectionStyle.None;
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // Cell BG Set
    func setBG() {
    
}

}
