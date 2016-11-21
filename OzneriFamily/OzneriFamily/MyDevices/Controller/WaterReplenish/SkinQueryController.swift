//
//  SkinQueryController.swift
//  OzneriFamily
//
//  Created by 赵兵 on 2016/11/2.
//  Copyright © 2016年 net.ozner. All rights reserved.
//

import UIKit

class SkinQueryController: UIViewController {

    var currentSkinTypeIndex=0//0：无，1油，2干,3中
    var totalTimes = 0
    //header
    @IBOutlet var skinTypeLabel: UILabel!
    @IBOutlet var skinTypeImg: UIImageView!
    @IBOutlet var skinTypeStateLabel: UILabel!
    //center
    @IBOutlet var testCountLabel: UILabel!
    @IBOutlet var testStateLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    //footer
    @IBAction func segmentClick(_ sender: UISegmentedControl) {
        footerSkinType.image=UIImage(named:"womanSkinOfChaXun\(sender.selectedSegmentIndex+1)")
        SkinSatteLabel.text=skinDescripeText[sender.selectedSegmentIndex+1]
    }
    @IBOutlet var footerSkinType: UIImageView!
    @IBOutlet var SkinSatteLabel: UILabel!
    
    let skinTextArr=["暂无","干性皮肤","油性皮肤","中性皮肤"]
    let skinDescripeText=[
        "数据累计不足，无法查询到您的肤质类型，请再接再厉",
        "干性肌需要进行深层补水，另外，肌肤营养缺乏会加速保水能力衰弱，定期使用适量精华补水也能改善您的干性特质哦！",
        "皮肤通道是先吸收水，再吸收油。当肌底极度缺水干燥的时候，为保护皮肤，油脂才会分泌过盛。水油已严重失衡啦，请注意控油补水！",
        "干性肌需要进行深层补水，另外，肌肤营养缺乏会加速保水能力衰弱！"
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        skinTypeLabel.text=skinTextArr[currentSkinTypeIndex]
        skinTypeImg.image=UIImage(named:"womanSkinOfChaXun\(currentSkinTypeIndex)")
        skinTypeStateLabel.text=skinDescripeText[currentSkinTypeIndex]
       
        testCountLabel.text = totalTimes<45 ? "\(totalTimes)/45":"\(totalTimes)"
        testStateLabel.text = totalTimes<45 ? loadLanguage("检测次数累计达45次才能给您相对精准的数据"):""
        
        dateLabel.text="\("统计时间"):\(NSDate().year()).\(NSDate().month()).01-\(NSDate().year()).\(NSDate().month()).\(NSDate().day())"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.SetCustomBarStyle(style: OznerNavBarStyle.WaterReplenishSkin)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier=="buyWater"
        {
            let vc = segue.destination as! AboutDeviceController
            vc.title="购买精华水"
            
            vc.setLoadContent(content: (NetworkManager.defaultManager?.URL?["buyEssenceWater"]?.stringValue)!, isUrl: true)
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
   

}