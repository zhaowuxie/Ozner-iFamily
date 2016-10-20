//
//  GloabConfig.swift
//  OzneriFamily
//
//  Created by 赵兵 on 2016/9/23.
//  Copyright © 2016年 net.ozner. All rights reserved.
//

import Foundation
import UIKit
//默认尺寸
let height_tabBar:CGFloat = 64
let height_navBar:CGFloat = 64
let height_statusBar:CGFloat = 20
let height_screen:CGFloat = UIScreen.main.bounds.size.height
let width_screen:CGFloat = UIScreen.main.bounds.size.width
//登陆控制类
enum OznerLoginType:String{
    case ByPhoneNumber="ByPhoneNumber"
    case ByEmail="ByEmail"
}
// app类型
enum OznerAppType:String
{
    case OzneriFamily="浩泽净水家"
    case YiQuan="伊泉净品"
}

//手机型号 忽略4
enum EnumIphoneType {
    case Iphone4
    case Ipone5
    case Iphone6
    case Iphone6p
}
class LoginManager:NSObject{
    //是否是第一次登陆
    class var isFristOpenApp:Bool{
        set{
            UserDefaults.standard.set(newValue, forKey: "IsFristOpenApp")
        }
        get{
            let tmpValue=UserDefaults.standard.object(forKey: "IsFristOpenApp")
            UserDefaults.standard.set(false, forKey: "IsFristOpenApp")
            return  tmpValue == nil ? true:false
        }
    }
    //当前登陆方式
    class var currentLoginType:OznerLoginType{
        set{
            UserDefaults.standard.set(newValue.rawValue, forKey: "currentLoginType")
        }
        get{
            let s = UserDefaults.standard.object(forKey: "currentLoginType") as! String
            return  OznerLoginType(rawValue: s)!
        }
    }
    //是不是中文简体
    static let isChinese_Simplified:Bool = {
            return  loadLanguage("isChinese_Simplified")=="true"
    }()
    //判断是不是“浩泽净水家”
    static let currentApp:OznerAppType = {
        let info = Bundle.main.infoDictionary
        let name = info?["CFBundleDisplayName"] as! String
        return OznerAppType(rawValue: name)!
    }()
    class func checkTel(_ str:NSString)->Bool
    {
        if (str.length != 11) {
            
            return false
        }
        
        
        let regex = "^\\d{11}$"
        let pred = NSPredicate(format: "SELF MATCHES %@",regex)
        
        let isMatch = pred.evaluate(with: str)
        if (!isMatch) {
            return false
        }
        
        return true
        
    }
    
    class func currenIphoneType() -> EnumIphoneType{
        switch width_screen {
        case 320:
            return EnumIphoneType.Ipone5
        case 375:
            return EnumIphoneType.Iphone6
        case 414:
            return EnumIphoneType.Iphone6p
        default:
            return EnumIphoneType.Iphone4
        }
    }
    static var currentDeviceIdentifier:String?=nil//设置和获取当前设备的ID,nil表示无设备
}



//当前设备型号
let cureentIphoneType: EnumIphoneType = LoginManager.currenIphoneType()

