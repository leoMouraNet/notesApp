//
//  TableViewCell.swift
//  notesApp
//
//  Created by Simon Gonzalez on 2016-07-31.
//  Copyright © 2016 skl. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    //Vars
    @IBOutlet weak var tittleNote: UILabel!
    @IBOutlet weak var dateNote: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
