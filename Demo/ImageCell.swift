//
//  ImageCell.swift
//  Demo
//
//  Created by David Kong on 4/11/17.
//  Copyright © 2017 JAUNT INC. All rights reserved.
//

import Foundation
import UIKit
class ImageCell: UITableViewCell {
    
    var imageCellView = UIImageView()
    var imageCellViewRight = UIImageView()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(imageCellView)
        self.contentView.addSubview(imageCellViewRight)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageCellView.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_WIDTH)
        imageCellViewRight.frame = CGRect(x:155, y: 0, width: 150, height: 150)
    }
}
