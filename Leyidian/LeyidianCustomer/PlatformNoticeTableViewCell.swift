//
//  PlatformNoticeTableViewCell.swift
//  LeyidianCustomer
//
//  Created by 马志敏 on 2017/3/7.
//  Copyright © 2017年 DEC.MA. All rights reserved.
//

import UIKit

class PlatformNoticeTableViewCell: UITableViewCell {

    @IBOutlet weak var messageImg: UIImageView!
    @IBOutlet weak var messageContext: UILabel!
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
