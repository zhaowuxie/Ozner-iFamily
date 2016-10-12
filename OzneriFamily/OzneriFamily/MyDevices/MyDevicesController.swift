//
//  MyDevicesController.swift
//  OzneriFamily
//
//  Created by 赵兵 on 2016/9/23.
//  Copyright © 2016年 net.ozner. All rights reserved.
//

import UIKit

class MyDevicesController: UIViewController {

    @IBOutlet var deviceNameLabel: UILabel!//设备名称
    @IBOutlet var deviceConnectStateLabel: UILabel!//设备连接状态
    @IBOutlet var deviceViewContainer: DeviceViewContainer!//自定义视图容器，加载设备自定义视图
    @IBOutlet var centerViewContainer: UIView!//中部视图容器（包括电量，滤芯状态，设置）,主要用于centerViewContainer是否隐藏
    @IBOutlet var bottomOfCenterViewContainer: NSLayoutConstraint!//调整centerViewContainer的距离底部位置
    @IBOutlet var batteryViewContainer: UIView!//电量容器,作用隐藏与否
    @IBOutlet var batteryImg: UIImageView!
    @IBOutlet var batteryValueLabel: UILabel!
    
    @IBOutlet var filterViewContainer: UIView!//滤芯容器,作用隐藏与否
    @IBOutlet var filterImg: UIImageView!
    @IBOutlet var filterValueLabel: UILabel!
    @IBOutlet var filterStateLabel: UILabel!
    
    @IBAction func toDeviceSettingClick(_ sender: AnyObject) {//点击设置按钮事件
        self.performSegue(withIdentifier: "showSetting", sender: nil)
    }
    @IBAction func leftMenuClick(_ sender: UIButton) {//左菜单点击按钮
        self.toggleLeft()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var curDevice:OznerDevice?
        let deviceArr=OznerManager.instance().getDevices() as NSArray
        if deviceArr.count>0
        {
             curDevice=deviceArr.object(at: 0) as? OznerDevice
        }
        deviceViewContainer.delegate=self
        deviceViewContainer.SetDeviceView(device: curDevice)
        // Do any additional setup after loading the view.
    }


    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden=true
        self.slideMenuController()?.removeLeftGestures()
        self.slideMenuController()?.addLeftGestures()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
//DeviceViewContainerDelegate代理方法
extension MyDevicesController : DeviceViewContainerDelegate{
    func AddNewDeviceClick() {
        let addDeviceNav=UIStoryboard(name: "LeftMenu", bundle: nil).instantiateViewController(withIdentifier: "LeftMenuNav") as! UINavigationController
        weak var weakSelf=self
        self.present(addDeviceNav, animated: false) {
            weakSelf?.closeLeft()
        }
    }
    func DeviceNameChange(name: String) {
        deviceNameLabel.text=name
    }
    func DeviceConnectStateChange(stateDes: String) {
        deviceConnectStateLabel.text=stateDes
    }
    func WhitchCenterViewIsHiden(MainIsHiden:Bool,BateryIsHiden:Bool,FilterIsHiden:Bool,BottomValue:CGFloat){
        centerViewContainer.isHidden=MainIsHiden
        batteryViewContainer.isHidden=BateryIsHiden
        filterViewContainer.isHidden=FilterIsHiden
        bottomOfCenterViewContainer.constant=BottomValue
    }
    //0-100，<0表示无
    func BateryValueChange(value:Int){
        switch true {
        case value<0:
            batteryImg.image=UIImage(named: "dian_liang_0")
            batteryValueLabel.text="-"
        case value==0:
            batteryImg.image=UIImage(named: "dian_liang_0")
            batteryValueLabel.text="0%"
        case value>0&&value<=30:
            batteryImg.image=UIImage(named: "dian_liang_30")
            batteryValueLabel.text="\(value)%"
        case value>30&&value<=70:
            batteryImg.image=UIImage(named: "dian_liang_70")
            batteryValueLabel.text="\(value)%"
        case value>70:
            batteryImg.image=UIImage(named: "dian_liang_100")
            batteryValueLabel.text="\(value)%"
        default:
            break
        }
    }
    func FilterValueChange(value:Int){
        switch true {
        case value<0:
            filterImg.image=UIImage(named: "airLvxinState0")
            filterValueLabel.text="-"
        case value==0:
            filterImg.image=UIImage(named: "airLvxinState0")
            filterValueLabel.text="0%"
        case value>0&&value<=40:
            filterImg.image=UIImage(named: "airLvxinState1")
            filterValueLabel.text="\(value)%"
        case value>40&&value<=60:
            filterImg.image=UIImage(named: "airLvxinState2")
            filterValueLabel.text="\(value)%"
        case value>60&&value<100:
            filterImg.image=UIImage(named: "airLvxinState3")
            filterValueLabel.text="\(value)%"
        default:
            filterImg.image=UIImage(named: "airLvxinState4")
            filterValueLabel.text="\(value)%"
            break
        }
        filterStateLabel.text = value<30 ? "请及时更换滤芯":"滤芯状态"
    }//0-100，<0表示无
    
}
//侧滑控制器代理方法
extension MyDevicesController : SlideMenuControllerDelegate {
    
    func leftWillOpen() {
        print("SlideMenuControllerDelegate: leftWillOpen")
    }
    
    func leftDidOpen() {
        print("SlideMenuControllerDelegate: leftDidOpen")
    }
    
    func leftWillClose() {
        print("SlideMenuControllerDelegate: leftWillClose")
    }
    
    func leftDidClose() {
        print("SlideMenuControllerDelegate: leftDidClose")
    }
    
    func rightWillOpen() {
        print("SlideMenuControllerDelegate: rightWillOpen")
    }
    
    func rightDidOpen() {
        print("SlideMenuControllerDelegate: rightDidOpen")
    }
    
    func rightWillClose() {
        print("SlideMenuControllerDelegate: rightWillClose")
    }
    
    func rightDidClose() {
        print("SlideMenuControllerDelegate: rightDidClose")
    }
}
