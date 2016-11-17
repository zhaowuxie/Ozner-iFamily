//
//  MyInfoCell.swift
//  OzneriFamily
//
//  Created by zhuguangyang on 16/10/11.
//  Copyright © 2016年 net.ozner. All rights reserved.
//

import UIKit

class MyInfoCell: UITableViewCell {

    @IBOutlet weak var iconImage: UIImageView!
    
    
    @IBOutlet weak var iconNameLb: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
 
    
    func reloadUI(infoStruct: MyCenterController.MyInfoStrcut) -> Void {
        iconImage.image = UIImage(named: infoStruct.imageName)
        iconNameLb.text = infoStruct.nameLb
        
    }
    
}
