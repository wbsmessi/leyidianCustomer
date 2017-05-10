//
//  StoreIntroductionTableViewCell.swift
//  LeyidianCustomer
//
//  Created by 马志敏 on 2017/3/14.
//  Copyright © 2017年 DEC.MA. All rights reserved.
//

import UIKit

class StoreIntroductionTableViewCell: UITableViewCell {

    @IBOutlet weak var storeImage: UIImageView!
    @IBOutlet weak var storeName: UILabel!
    @IBOutlet weak var storeInfo: UILabel!
    @IBOutlet weak var storeOpenTime: UILabel!
    @IBOutlet weak var status: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
