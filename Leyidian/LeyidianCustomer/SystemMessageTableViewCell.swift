//
//  SystemMessageTableViewCell.swift
//  LeyidianCustomer
//
//  Created by 马志敏 on 2017/3/7.
//  Copyright © 2017年 DEC.MA. All rights reserved.
//

import UIKit

class SystemMessageTableViewCell: UITableViewCell {

    @IBOutlet weak var messageTitle: UILabel!
    @IBOutlet weak var messageDetail: UILabel!
    @IBOutlet weak var messageDate: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
