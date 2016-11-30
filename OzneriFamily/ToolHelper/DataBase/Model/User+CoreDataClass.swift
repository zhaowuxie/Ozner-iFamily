//
//  User+CoreDataClass.swift
//  OzneriFamily
//
//  Created by 赵兵 on 2016/9/28.
//  Copyright © 2016年 net.ozner. All rights reserved.
//

import Foundation
import CoreData
import SwiftyJSON
let UserDefaultsUserTokenKey = "usertoken"
let UserDefaultsUserIDKey = "userid"
let CurrentUserDidChangeNotificationName = "CurrentUserDidChangeNotificationName"

typealias successJsonBlock = (JSON) -> Void
typealias successVoidBlock = ()->Void
typealias failureBlock = (_ error:Error?)->Void
public class User: BaseDataObject {

    static var currentUser: User? = nil {
        didSet {
            if oldValue != nil {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: CurrentUserDidChangeNotificationName), object: nil)
            }
        }
    }
    //检查是否需要自动登录
    class func loginWithLocalUserInfo(success: ((User) -> Void), failure: ((NSError) -> Void)) {
        
        let UserToken = UserDefaults.standard.object(forKey: UserDefaultsUserTokenKey) as? NSString
        let UserID = UserDefaults.standard.object(forKey: UserDefaultsUserIDKey) as? NSString
        var error: NSError? = nil
        if UserToken == nil || UserID==nil  {
            failure(NSError())
        } else {
            if let user = CoreDataManager.defaultManager.fetch(entityName: "User", ID: UserID!, error: &error) as? User {
                User.currentUser=user
                success(user)
            } else {
                let userInfo: NSMutableDictionary = [
                    NSLocalizedDescriptionKey: "数据库用户信息不存在",
                    NSLocalizedFailureReasonErrorKey: "",
                    NSLocalizedRecoverySuggestionErrorKey: ""
                ]
                
                if error != nil {
                    userInfo[NSUnderlyingErrorKey] = error
                }
                failure(NSError(
                    domain: (NetworkManager.defaultManager?.RootAdress)!,
                    code: 404,
                    userInfo: userInfo as [NSObject: AnyObject]))
            }
        }
    }
    //获取手机验证码
    class func GetPhoneCode(phone:String,success:@escaping (()->Void),failure:@escaping ((Error)->Void)){
        self.fetchData(key: "GetPhoneCode", parameters: ["phone": phone], success: { (json) in
            success()
            }, failure: failure)
    }
    //获取语音验证码
    class func GetVoicePhoneCode(phone:String,success:@escaping (()->Void),failure:@escaping ((Error)->Void)){
        self.fetchData(key: "GetVoicePhoneCode",
                                              parameters: [
                                                "phone": phone
            ],
                                              success: {
                                                data in
                                                success()
            },
                                              failure: failure)
    }
    //手机登录
    class func loginWithPhone(phone: String, phonecode: String, success: @escaping ((User) -> Void), failure: @escaping ((Error) -> Void)) {
        NetworkManager.clearCookies()
        
        self.fetchDataWithProgress(key: "Login",
                       parameters: [
                        "UserName": phone,
                        "PassWord": phonecode,
                        "miei": (UIDevice.current.identifierForVendor?.uuidString)!,
                        "devicename": UIDevice.current.name
            ],
                       success: {
                        data in
                        let defaults = UserDefaults.standard
                        defaults.set(data["usertoken"].stringValue, forKey: UserDefaultsUserTokenKey)
                        defaults.set(data["userid"].stringValue, forKey: UserDefaultsUserIDKey)
                        
                        let user = User.cachedObjectWithID(ID: data["userid"].stringValue as NSString)
                        user.phone = phone
                        user.id =  data["userid"].stringValue
                        user.usertoken = data["usertoken"].stringValue     
                        defaults.synchronize()
                        loginWithLocalUserInfo(success: success, failure: failure)
                        
            },
                       failure: failure)
    }
    //邮箱登录
    class func loginWithEmail(_ params: NSDictionary,_ sucess:@escaping ((User) -> Void),failure: @escaping ((Error) ->Void)) {
        NetworkManager.clearCookies()
        self.fetchDataWithProgress(key: "MailLogin", parameters: params, success: { (data) in
            let defaults = UserDefaults.standard
            
            defaults.set(data["usertoken"].stringValue, forKey: UserDefaultsUserTokenKey)
            defaults.set(data["userid"].stringValue, forKey: UserDefaultsUserIDKey)
            
            let user = User.cachedObjectWithID(ID: data["userid"].stringValue as NSString)
            user.phone = ""
            user.email = params["username"] as? String
            user.id =  data["userid"].stringValue
            user.usertoken = data["usertoken"].stringValue
            defaults.synchronize()
            loginWithLocalUserInfo(success: sucess, failure: failure)
            
        }) { (error) in
            
            failure(error)
        }
        
        
    }
    //邮箱注册
    class func registerByEmail(_ params: NSDictionary,_ sucess: @escaping (() -> Void),failure:@escaping ((Error) ->Void) ) {
        self.fetchDataWithProgress(key: "MailRegister", parameters: params, success: { (data) in
            sucess()
        }) { (error) in
            failure(error)
        }
    }
    //获取邮箱验证码
    class func getEmailVaildCode(_ params: NSDictionary,_ sucess: @escaping (() -> Void),failure:@escaping ((Error) ->Void)) {
        
        self.fetchDataWithProgress(key: "GetEmailCode", parameters: params, success: { (data) in
            sucess()
        }) { (error) in
            failure(error)
        }
        
    }
    //重置邮箱密码
    class func ResetPasswordByEmail(_ params: NSDictionary,_ sucess: @escaping (() -> Void),failure:@escaping ((Error) ->Void) ) {
        self.fetchDataWithProgress(key: "ResetPassword", parameters: params, success: { (data) in
            sucess()
        }) { (error) in
            failure(error)
        }
    }
    //咨询朱广阳 star
    //获取聊天Token
    
    class func GetAccesstoken() {
        
        var getpar:String = "appid=hzapi"
        getpar = getpar + "&appsecret=8af0134asdffe12"
        let sign_News = getpar.MD5
        let urlStr = "http://dkf.ozner.net/api" + "/token.ashx"
        
        let params:NSDictionary = ["appid":"hzapi","appsecret":"8af0134asdffe12","sign":sign_News!]
        
        self.chatData(urlStr,method: .GET, parameters: params, success: { (json) in
            print(json)
            acsstoken_News = json.dictionary?["result"]?.dictionaryValue["access_token"]?.stringValue ?? ""
            self.GetUserInfoFunc()
            self.userChatLoginFunc()
        }) { (error) in
            print(error)
        }
        
    }
    //获取用户信息
    class func GetUserInfoFunc() {
        
        let tmpPhone = User.currentUser?.phone
        guard tmpPhone != nil else {
            let alertView = SCLAlertView()
            
            _ = alertView.addButton(loadLanguage("确定"), action: {})
            _ = alertView.showInfo(loadLanguage("温馨提示"), subTitle: loadLanguage("请登录"))
            return
        }
        sign_News = ""
        sign_News = "access_token=" + acsstoken_News
        sign_News += appidandsecret
        
        var urlStr = NEWS_URL + "/member.ashx?access_token="
        urlStr += acsstoken_News + "&sign=" + sign_News.MD5
        
        let params:NSDictionary = ["mobile":tmpPhone!]
        
//        let mansger = AFHTTPSessionManager()
//        mansger.requestSerializer = AFHTTPRequestSerializer.init()
        
//        mansger.post(urlStr, parameters: params, constructingBodyWith: { (_) in
//            
//            }, progress: { (_) in
//                
//            }, success: { (task, data) in
//                print(data)
//        }) { (task, error) in
//            print(error)
//        }
        print(urlStr)
        
        self.chatData(urlStr,method:.POST,parameters: params, success: { (data) in
            print(data)
        }) { (error) in
            print(error)
        }
        
        
    }
    //获取历史信息接口
    class  func GetHistoryRecord() {
        
        let getUrl = "http://dkf.ozner.net/api" + "/historyrecord.ashx?access_token=" + ""
        
        
    }
    
    //咨询用户上线
    class func userChatLoginFunc() {
        deviceid_News = BPush.getChannelId()
        
        if deviceid_News == "" {
            print("设备号为空:\(deviceid_News)")
            return
        }
        sign_News = ""
        sign_News = "access_token=" + acsstoken_News
        sign_News += appidandsecret
        
        var urlStr = NEWS_URL + "/customerlogin.ashx?access_token="
        urlStr += acsstoken_News + "&sign=" + sign_News.MD5
        
        let params:NSDictionary = ["customer_id":customerid_News as NSNumber,"device_id":deviceid_News,"channel_id": 5088918642936564194 as NSNumber,"ct_id":ct_id as NSNumber]

        self.chatData(urlStr, method: .GET, parameters: params, success: { (data) in
            print(data)
            }) { (error) in
                print(error)
        }
  
        
    }
    
    
    
    //我
    //提意见
    class func commitSugesstion(_ params:NSDictionary,_ sucess: @escaping successJsonBlock,faliure:@escaping failureBlock) {
        
        self.fetchData(key: "SubmitOpinion", parameters: params, success: { (data) in
            
            sucess(data)
        }) { (error) in
            faliure(error)
        }
        
    }
    //获取用户的朋友列表
    class func GetFriendList(_ sucess: @escaping successJsonBlock,faliure:@escaping failureBlock) {
        self.fetchData(key: "GetFriendList", parameters: [:], success: { (data) in
            
            sucess(data)
            
        }) { (error) in
            
            faliure(error)
            
        }
    }
    //获取好友历史留言
    class func GetHistoryMessage(_ params:NSDictionary,_ sucess: @escaping successJsonBlock,faliure:@escaping failureBlock) {
        self.fetchData(key: "GetHistoryMessage", parameters:params, success: { (data) in
            
            sucess(data)
            
        }) { (error) in
            
            faliure(error)
            
        }
    }
    //留言
    class func LeaveMessage(_ params:NSDictionary,_ sucess: @escaping successJsonBlock,faliure:@escaping failureBlock) {
        self.fetchData(key: "LeaveMessage", parameters:params, success: { (data) in
            
            sucess(data)
            
        }) { (error) in
            
            faliure(error)
            
        }
    }
    
    //获取验证消息
    class func  GetUserVerifMessage(_ sucess: @escaping successJsonBlock,faliure:@escaping failureBlock) {
        self.fetchData(key: "GetUserVerifMessage", parameters: [:], success: { (data) in
            
            sucess(data)
            
        }) { (error) in
            
            faliure(error)
            
        }
    }
    
    //通过好友请求
    class func AcceptUserVerif(_ params:NSDictionary,_ sucess: @escaping successJsonBlock,faliure:@escaping failureBlock) {
        self.fetchData(key: "AcceptUserVerif", parameters:params, success: { (data) in
            
            sucess(data)
            
        }) { (error) in
            
            faliure(error)
            
        }
    }
    //搜索好友
    class func SearchFriend(_ params:NSDictionary,_ sucess: @escaping successJsonBlock,faliure:@escaping failureBlock) {
        self.fetchData(key: "SearchFriend", parameters:params, success: { (data) in
            
            sucess(data)
            
        }) { (error) in
            
            faliure(error)
            
        }
    }
    //获取好友信息(头像，昵称等)
    
    class func GetUserNickImage(_ params:NSDictionary,_ sucess: @escaping successJsonBlock,faliure:@escaping failureBlock) {
        self.fetchData(key: "GetUserNickImage", parameters:params, success: { (data) in
            
            sucess(data)
            
        }) { (error) in
            
            faliure(error)
            
        }
    }
    
    //添加好友验证信息
    class func AddFriend(_ params:NSDictionary,_ sucess: @escaping successJsonBlock,faliure:@escaping failureBlock) {
        self.fetchData(key: "AddFriend", parameters:params, success: { (data) in
            
            sucess(data)
            
        }) { (error) in
            
            faliure(error)
            
        }
    }
    
    //我的排行
    //朋友圈内饮水量实时排行
    class func VolumeFriendRank(_ params:NSDictionary,_ sucess: @escaping successJsonBlock,faliure:@escaping failureBlock) {
        self.fetchData(key: "VolumeFriendRank", parameters:params, success: { (data) in
            
            sucess(data)
            
        }) { (error) in
            
            faliure(error)
            
        }
    }
    //朱广阳 end
    
    //获取用户信息1
    class func GetUserInfo(){
        self.fetchData(key: "GetUserInfo", parameters: [:], success: { (json) in
            let userInfo=json["userinfo"].dictionary
            User.currentUser?.username=userInfo?["Nickname"]?.stringValue
            User.currentUser?.score=userInfo?["Score"]?.stringValue
            User.currentUser?.headimage=userInfo?["Icon"]?.stringValue
            User.currentUser?.gradename=userInfo?["GradeName"]?.stringValue
        }) { (error) in
        }
    }
    //获取用户信息1
//    class func GetUserInfo(){
//        self.fetchData(key: "GetUserNickImage", parameters: ["jsonmobile":User.currentUser?.phone!], success: { (json) in
//            let userInfo=json["data"].dictionary
//            User.currentUser?.username=userInfo?["nickname"]?.stringValue
//            User.currentUser?.score=userInfo?["Score"]?.stringValue
//            User.currentUser?.headimage=userInfo?["headimg"]?.stringValue
//            User.currentUser?.gradename=userInfo?["GradeName"]?.stringValue.replacingOccurrences(of: "会员", with: "代理会员")
////            if (User.currentUser?.headimage?.characters.count)!<5 || !(User.currentUser?.headimage?.contains("http"))!
////            {
////                User.currentUser?.headimage=""
////            }
//            print(userInfo)
//            print(userInfo)
//        }) { (error) in
//        }
//    }
//    //获取用户信息2   "15016161314,1561212311,123423342"
//    class func GetUserNickImage(phones:String,success: @escaping (([User]) -> Void), failure: @escaping ((Error) -> Void)){
//        self.fetchData(key: "GetUserNickImage", parameters: ["jsonmobile":phones], success: { (json) in
//            var userArr=[User]()
//            for userInfo in json.array!
//            {
//                let tmpUser=User()
//                tmpUser.username=userInfo?["Nickname"]?.stringValue
//                tmpUser.score=userInfo?["Score"]?.stringValue
//                tmpUser.headimage=userInfo?["Icon"]?.stringValue
//                tmpUser.gradename=userInfo?["GradeName"]?.stringValue
//                userArr.append(tmpUser)
//            }
//            success(userArr)
//            
//        }) { (error) in
//        }
//    }
    //更新用户信息
    class func UpdateUserInfo(){
        self.fetchData(key: "UpdateUserInfo", parameters: ["device_id":BPush.getChannelId()], success: { (json) in
            User.GetUserInfo()
            }) { (error) in
                
        }
    }
    
    //---------------------------设备------------------------------
    //下载探头滤芯数据
    class func FilterService(deviceID:String,success: @escaping ((_ usedDay:Int,_ starDate:Date) -> Void), failure: @escaping ((Error) -> Void)){
        self.fetchData(key: "FilterService", parameters: ["mac":deviceID], success: { (json) in
            let timeStr=json["modifytime"].string!
            let date=NSDate(string: timeStr, formatString: "yyyy-MM-dd HH:mm:ss") as Date
            success(json["useday"].int!, date)
        }, failure: failure)
        
    }

    //净水器设备型号及功能，连接地址下载
    class func GetMachineType(deviceID:String,success: @escaping ((_ ScanEnable:Bool,_ CoolEnable:Bool,_ HotEnable:Bool,_ MachineType:String,_ BuyUrl:String,_ AlertDays:Int) -> Void), failure: @escaping ((Error) -> Void)){
        self.fetchData(key: "GetMachineType", parameters: ["type":deviceID], success: { (json) in
            let tmpData=json["data"].dictionary
            
            success(
                (tmpData?["boolshow"]?.intValue==1 ? true:false),
                (tmpData?["Attr"]?.stringValue.contains("cool:true"))!,
                (tmpData?["Attr"]?.stringValue.contains("hot:true"))!,
                (tmpData?["MachineType"]?.stringValue)!,
                (tmpData?["buylinkurl"]?.stringValue)!,
                (tmpData?["days"]?.intValue)!)
            }, failure: failure)
        
    }
    //净水器获取滤芯服务时间
    class func GetMachineLifeOutTime(deviceID:String,success: @escaping ((_ usedDays:Int,_ stopDate:Date) -> Void), failure: @escaping ((Error) -> Void)){
        self.fetchData(key: "GetMachineLifeOutTime", parameters: ["mac":deviceID], success: { (json) in
            let endStr=json["time"].stringValue
            let nowStr=json["nowtime"].stringValue
            if endStr==""||nowStr==""
            {
               success(0, NSDate().addingYears(1))
                return
            }
            let endDate=NSDate(string: endStr, formatString: "yyyy/MM/dd HH:mm:ss")
            let nowDate=NSDate(string: nowStr, formatString: "yyyy/MM/dd HH:mm:ss")
            let tmpUseDays=365-((endDate?.timeIntervalSince1970)!-(nowDate?.timeIntervalSince1970)!)/(24*3600.0)
            success(min(365, Int(tmpUseDays)), endDate as! Date)
            }, failure: failure)
        
    }
    //上传饮水量获取排名
    class func VolumeSensor(deviceID:String,type:String,volume:Int,success: @escaping ((_ rank:Int) -> Void), failure: @escaping ((Error) -> Void)){
        self.fetchData(key: "VolumeSensor", parameters: ["mac":deviceID,"type":type,"volume":volume], success: { (json) in
            success(json["state"].int!)
            }, failure: failure)
        
    }
    ////上传TDS获取排名
    class func TDSSensor(deviceID:String,type:String,tds:Int,beforetds:Int,success: @escaping ((_ rank:Int,_ total:Int) -> Void), failure: @escaping ((Error) -> Void)){
        self.fetchData(key: "TDSSensor", parameters: ["mac":deviceID,"type":type,"tds":tds,"beforetds":beforetds], success: { (json) in
            success(json["rank"].int!,json["total"].int!)
            }, failure: failure)
    }
    //更新补水仪的数值 Face ，Eyes ,Hands, Neck
    class func UpdateBuShuiYiNumber(mac:String,ynumber:String,snumber:String,action:String,success: @escaping (() -> Void), failure: @escaping ((Error) -> Void)){
        self.fetchData(key: "UpdateBuShuiYiNumber", parameters: ["mac":mac,"ynumber":ynumber,"snumber":snumber,"action":action], success: { (json) in
            success()
            }, failure: failure)
    }
    //获取周月补水仪器数值分布
    class func GetBuShuiFenBu(mac:String,action:String,success: @escaping ((_ SkinTypeIndex:Int,_ AvgAndTimesArr:[Int:HeadOfWaterReplenishStruct],_ WeakData:[Int:[WaterReplenishDataStuct]],_ MonthData:[Int:[WaterReplenishDataStuct]]) -> Void), failure: @escaping ((Error) -> Void)){
        self.fetchData(key: "GetBuShuiFenBu", parameters: ["mac":mac,"action":action], success: { (data) in
            let tmpKeyArr=["FaceSkinValue","EyesSkinValue","HandSkinValue","NeckSkinValue"]
            var AvgAndTimesArr=[Int:HeadOfWaterReplenishStruct]()
            var SkinTypeIndex = -1
            var WeakData=[Int:[WaterReplenishDataStuct]]()
            var MonthData=[Int:[WaterReplenishDataStuct]]()
            for i in 0..<tmpKeyArr.count
            {
                let tempBody=data["data"][tmpKeyArr[i]]
                //周数据
                var tmpweakData=[WaterReplenishDataStuct]()
                for item in tempBody["week"].arrayValue
                {
                    let dateStr=dateStampToString(item["updatetime"].stringValue, format: "yyyy-MM-dd")
                    let date=dateFromString(dateStr, format: "yyyy-MM-dd")
                    let tmpData1=WaterReplenishDataStuct(date: date as NSDate!, oil: item["ynumber"].double!, water: item["snumber"].double!)
                    tmpweakData.append(tmpData1)
                }
                WeakData[i]=tmpweakData
                //月数据
                var maxTimes=0
                var todayValue:Double=0
                var totolValue:Double=0
                var totolOilValue:Double=0
                var tmpMonthData=[WaterReplenishDataStuct]()
                for item in tempBody["monty"].array!
                {
                    let dateStr=dateStampToString(item["updatetime"].stringValue, format: "yyyy-MM-dd")
                    let date=dateFromString(dateStr, format: "yyyy-MM-dd")
                    let tmpData=WaterReplenishDataStuct(date: date as NSDate!, oil: item["ynumber"].double!, water: item["snumber"].double!)
                    tmpMonthData.append(tmpData)
                    
                    totolOilValue+=tmpData.oil
                    totolValue+=tmpData.water
                    
 
                    if tmpData.date.day() == NSDate().day()
                    {
                        todayValue=tmpData.water
                    }
                    maxTimes=max(maxTimes,item["times"].intValue)
                }
                MonthData[i]=tmpMonthData
                let tmpCount=tempBody["monty"].arrayValue.count
                
                let lastValue = tmpCount<=1 ? todayValue:tempBody["monty"][tmpCount-2]["snumber"].doubleValue
                
                let tmpAveValue=tmpCount==0 ? 0:(totolValue/Double(tmpCount))

                AvgAndTimesArr[i]=HeadOfWaterReplenishStruct(skinValueOfToday: todayValue, lastSkinValue: lastValue, averageSkinValue:tmpAveValue, checkTimes: maxTimes)
                let tmpAveOilValue=tmpCount==0 ? 0:(totolOilValue/Double(tmpCount))
                if i==0&&tmpAveOilValue>0
                {
                    SkinTypeIndex = tmpAveOilValue<12 ? 0:SkinTypeIndex
                    SkinTypeIndex = tmpAveOilValue>=12&&tmpAveOilValue<20 ? 1:SkinTypeIndex
                    SkinTypeIndex = tmpAveOilValue>=20 ? 2:SkinTypeIndex
                }
                
            }
            success(SkinTypeIndex, AvgAndTimesArr, WeakData, MonthData)
            }, failure: failure)
    }
    //空气净化器获取室外空气数据
    class func GetWeather(success: @escaping ((_ pollution:String,_ cityname:String,_ PM25:String,_ AQI:String,_ temperature:String,_ humidity:String,_ dataFrom:String) -> Void), failure: @escaping ((Error) -> Void)){
        self.fetchData(key: "GetWeather", parameters: nil, success: { (json) in
            var dataFrom=json["weatherform"].stringValue
            //解析json
            let dataStr=json["data"].stringValue
            let tmpData=dataStr.data(using: String.Encoding.utf8)
            let jsonData=JSON(data: tmpData!)
            let jsonDic=jsonData["HeWeather data service 3.0"][0].dictionaryValue
            let tmpdic=jsonDic["aqi"]?["city"]
            let pollution=tmpdic?["qlty"].stringValue//中度污染
            let AQI=tmpdic?["aqi"].stringValue
            let PM25=tmpdic?["pm25"].stringValue
            let cityname=jsonDic["basic"]?["city"].stringValue//上海
            let tmptime=jsonDic["basic"]?["update"]["loc"].stringValue//"2015-12-25 02:54"
            dataFrom=dataFrom+"   "+tmptime!+"发布"
            let humidity=jsonDic["now"]?["hum"].stringValue
            let temperature=jsonDic["now"]?["tmp"].stringValue
            success(pollution!,cityname!,PM25!,AQI!,temperature!,humidity!,dataFrom)
            }, failure: failure)
    }
    //水探头净水器扫码换滤芯
    class func RenewFilterTime(mac:String,type:String,code:String,success: @escaping (() -> Void), failure: @escaping ((Error) -> Void)){
        self.fetchData(key: "RenewFilterTime", parameters: ["mac":mac,"devicetype":type,"code":code], success: { (json) in
            success()
            }, failure: failure)
    }
    //水机获取好友排名
    class func TdsFriendRank(type:String,success: @escaping ((_ rank:Int) -> Void), failure: @escaping ((Error) -> Void)){
        self.fetchData(key: "TdsFriendRank", parameters: ["type":type], success: { (json) in
            success(json["data"][0]["rank"].intValue)
            }, failure: failure)
    }
    //水杯饮水量好友排名
    class func VolumeFriendRank(success: @escaping ((_ rank:Int) -> Void), failure: @escaping ((Error) -> Void)){
        self.fetchData(key: "VolumeFriendRank", parameters: [:], success: { (json) in
            success(json["data"][0]["rank"].intValue)
            }, failure: failure)
    }
    //获取水机周月TDS分布 oil<==>TDS_BF water<==>TDS_AF
    class func GetDeviceTdsFenBu(mac:String,success: @escaping ((_ weakArr:[WaterReplenishDataStuct],_ monthArr:[WaterReplenishDataStuct]) -> Void), failure: @escaping ((Error) -> Void)){
        self.fetchData(key: "GetDeviceTdsFenBu", parameters: ["mac":mac], success: { (json) in
            var WeakArray=[WaterReplenishDataStuct]()
            var MonthArray=[WaterReplenishDataStuct]()
            for item in json["week"].arrayValue
            {
                let tds1=item["beforetds"].intValue
                let tds2=item["tds"].intValue
                let dateStr=dateStampToString(item["stime"].stringValue, format: "yyyy-MM-dd")
                let date=dateFromString(dateStr, format: "yyyy-MM-dd") as NSDate
                
                let tmpStruct=WaterReplenishDataStuct(date: date, oil: Double(max(tds1, tds2)), water: Double(min(tds1, tds2)))
                WeakArray.append(tmpStruct)
            }
            for item in json["month"].arrayValue
            {
                let tds1=item["beforetds"].intValue
                let tds2=item["tds"].intValue
                let dateStr=dateStampToString(item["stime"].stringValue, format: "yyyy-MM-dd")
                let date=dateFromString(dateStr, format: "yyyy-MM-dd") as NSDate
                
                let tmpStruct=WaterReplenishDataStuct(date: date, oil: Double(max(tds1, tds2)), water: Double(min(tds1, tds2)))
                MonthArray.append(tmpStruct)
            }
            
            success(WeakArray,MonthArray)
            }, failure: failure)
    }
    
}
