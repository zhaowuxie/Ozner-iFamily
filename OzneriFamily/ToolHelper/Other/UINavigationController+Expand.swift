//
//  UINavigationController+Expand.swift
//  OzneriFamily
//
//  Created by 赵兵 on 2016/10/19.
//  Copyright © 2016年 net.ozner. All rights reserved.
//

import UIKit
enum OznerNavBarStyle {
    case CupTDSDetail
    case DeviceSetting
    case WaterReplenishSkin
}
extension UINavigationController{
    func SetCustomBarStyle(style:OznerNavBarStyle){
        
        self.navigationBar.isHidden=false
        self.navigationBar.isTranslucent=false
        //let tmpFont=UIFont.init(name: ".SFUIText-Light", size: 17)
        //self.navigationBar.titleTextAttributes = [NSFontAttributeName:tmpFont]
        LoginManager.instance.mainTabBarController?.setTabBarHidden(true, animated: false)
        switch style {
        case .CupTDSDetail:
            self.navigationBar .setBackgroundImage(UIImage(named: "navBgOfCupTdsDetail"), for: UIBarMetrics.default)
            self.navigationBar.shadowImage = UIImage(named: "navBgOfCupTdsDetail")
        case .DeviceSetting:
            self.navigationBar .setBackgroundImage(UIImage(named: "navBgOfSetting"), for: UIBarMetrics.default)
            self.navigationBar.shadowImage = UIImage(named: "bg_clear_black")
            
        case .WaterReplenishSkin:
            self.navigationBar .setBackgroundImage(UIImage(named: "navBgOfWaterReplenishSkin"), for: UIBarMetrics.default)
            self.navigationBar.shadowImage = UIImage(named: "navBgOfWaterReplenishSkin")
        }
        
        
    }
}
