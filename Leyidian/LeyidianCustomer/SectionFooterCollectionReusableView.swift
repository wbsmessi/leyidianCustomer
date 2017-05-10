//
//  SectionFooterCollectionReusableView.swift
//  LeyidianCustomer
//
//  Created by 马志敏 on 2017/3/2.
//  Copyright © 2017年 DEC.MA. All rights reserved.
//

import UIKit

class SectionFooterCollectionReusableView: UICollectionReusableView {
    lazy var bgImage = UIImageView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        bgImage.frame=self.frame
        bgImage.backgroundColor=MyGlobalColor()
        self.addSubview(bgImage)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
}
