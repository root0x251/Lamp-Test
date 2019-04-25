//
//  TableViewCell.swift
//  Lamp Test
//
//  Created by Вячеслав Алексеевич on 24/04/2019.
//  Copyright © 2019 Бортниченко Вячеслав Алексеевич. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var testLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
