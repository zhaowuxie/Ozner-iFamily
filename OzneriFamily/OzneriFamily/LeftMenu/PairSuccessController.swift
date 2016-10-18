//
//  PairSuccessController.swift
//  OzneriFamily
//
//  Created by 赵兵 on 2016/10/10.
//  Copyright © 2016年 net.ozner. All rights reserved.
//

import UIKit
import Spring
import SnapKit

class PairModle: NSObject {
    var isHidden: Bool?
}


class PairSuccessController: UIViewController {

    @IBAction func backClick(_ sender: AnyObject) {
        _=self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var collectionFlowout: UICollectionViewFlowLayout!
    

    
    @IBOutlet weak var sucessImageLayout: NSLayoutConstraint!
    
    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var searchLb: UILabel!
    
    @IBOutlet weak var successImage: UIImageView!
    @IBOutlet weak var scrollerView: UIView!
    
    @IBOutlet weak var leftBtn: UIButton!
    @IBOutlet weak var rightBtn: UIButton!
    //记录选择了第几个设备，默认第一个
    var indexDevice: Int = 0
    
    var  deviceTypeValue:OznerDeviceType!
    //cell
    var mainMatchView: UIView!
    var pairModel:[PairModle]?{
        didSet{
            collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadImageandLb()

        setUpUI()
        
        getDatas()

        switch (pairModel?.count)! {
        case 0:
            break
        case 1:
            leftBtn.isHidden = true
            rightBtn.isHidden = true
            collectionFlowout.itemSize = CGSize(width: width_screen - 88 - 20, height: 100)
            
            break
        case 2:
            collectionFlowout.itemSize = CGSize(width: (width_screen - 88 - 20 - 10)/2, height: 100)
            break
   
        default:
            collectionFlowout.itemSize = CGSize(width: (width_screen - 88 - 20 - 20)/3, height: 100)
            break
        }
        
    }
    
    private func loadImageandLb() {
        
        switch deviceTypeValue.rawValue {
        case OznerDeviceType.Cup.rawValue:
            mainMatchView = UINib.init(nibName: "CupMatchView", bundle: nil).instantiate(withOwner: nil, options: nil).first as! CupMatchView
            (mainMatchView as! CupMatchView).sucessBtn.addTarget(self, action: #selector(PairSuccessController.sucessAction), for: UIControlEvents.touchUpInside)
            break
        case OznerDeviceType.Tap.rawValue:
            mainMatchView = UINib.init(nibName: "SmallAriClearView", bundle: nil).instantiate(withOwner: nil, options: nil).first as! SmallAriClearView
            (mainMatchView as! SmallAriClearView).placeLb.text = "办公室"
            (mainMatchView as! SmallAriClearView).nameLb.placeholder = "输入水探头名称"
            (mainMatchView as! SmallAriClearView).successbtn.addTarget(self, action: #selector(PairSuccessController.sucessAction), for: UIControlEvents.touchUpInside)
            break
        case OznerDeviceType.TDSPan.rawValue:
            mainMatchView = UINib.init(nibName: "SmallAriClearView", bundle: nil).instantiate(withOwner: nil, options: nil).first as! SmallAriClearView
            (mainMatchView as! SmallAriClearView).placeLb.text = "办公室"
            (mainMatchView as! SmallAriClearView).nameLb.placeholder = "输入检测笔名称"
            (mainMatchView as! SmallAriClearView).successbtn.addTarget(self, action: #selector(PairSuccessController.sucessAction), for: UIControlEvents.touchUpInside)
            break
        case OznerDeviceType.Water_Wifi.rawValue:
            mainMatchView = UINib.init(nibName: "SmallAriClearView", bundle: nil).instantiate(withOwner: nil, options: nil).first as! SmallAriClearView
            (mainMatchView as! SmallAriClearView).placeLb.text = "办公室"
            (mainMatchView as! SmallAriClearView).nameLb.placeholder = "立式空净名称"
            (mainMatchView as! SmallAriClearView).successbtn.addTarget(self, action: #selector(PairSuccessController.sucessAction), for: UIControlEvents.touchUpInside)
            break
        case OznerDeviceType.Air_Blue.rawValue:
            //小空净
            mainMatchView = UINib.init(nibName: "SmallAriClearView", bundle: nil).instantiate(withOwner: nil, options: nil).first as! SmallAriClearView
            (mainMatchView as! SmallAriClearView).successbtn.addTarget(self, action: #selector(PairSuccessController.sucessAction), for: UIControlEvents.touchUpInside)
        case OznerDeviceType.Air_Wifi.rawValue:
            mainMatchView = UINib.init(nibName: "SmallAriClearView", bundle: nil).instantiate(withOwner: nil, options: nil).first as! SmallAriClearView
            (mainMatchView as! SmallAriClearView).placeLb.text = "办公室"
            (mainMatchView as! SmallAriClearView).nameLb.placeholder = "立式空净名称"
            (mainMatchView as! SmallAriClearView).successbtn.addTarget(self, action: #selector(PairSuccessController.sucessAction), for: UIControlEvents.touchUpInside)
            break
        case OznerDeviceType.WaterReplenish.rawValue:
            mainMatchView = UINib.init(nibName: "WaterRefeishView", bundle: nil).instantiate(withOwner: nil, options: nil).first as! WaterRefeishView
            (mainMatchView as! WaterRefeishView).sucessAction.addTarget(self, action: #selector(PairSuccessController.sucessAction), for: UIControlEvents.touchUpInside)
            
            break
        default:
            break
        }
        view.addSubview(mainMatchView)
        mainMatchView.snp.makeConstraints { (make) in
            make.top.equalTo(scrollerView.snp.bottom)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
            if cureentIphoneType == EnumIphoneType.Ipone5
            {
                make.bottom.equalTo(view.snp.bottom).offset(150)
            } else if cureentIphoneType == EnumIphoneType.Iphone6 {
                make.bottom.equalTo(view.snp.bottom).offset(80)
            } else {
                make.bottom.equalTo(view.snp.bottom).offset(1)
            }
        }
    }


    func sucessAction() {
        print(#function)
    }
    
    private func getDatas() {
        //模拟数据
        let model = PairModle()
        model.isHidden = false
        
        let model1 = PairModle()
        model1.isHidden = true
        
        let model2 = PairModle()
        model2.isHidden = true
        
        let model3 = PairModle()
        model3.isHidden = true
        
        let model4 = PairModle()
        model4.isHidden = true
        pairModel = [model,model1,model2,model3,model4];
    }
    private func setUpUI() {
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

        let animal = CABasicAnimation(keyPath: "transform.scale")
        animal.fromValue = NSNumber(value: 1.0)
        animal.toValue = NSNumber(value: 0.5)
        animal.duration = 3.0

        self.successImage.layer.add(animal, forKey: "transform.scale")
        UIView.animate(withDuration: 0.5, animations: {
            
            if cureentIphoneType == EnumIphoneType.Ipone5
            {
            //5
            self.bgImageView.transform = CGAffineTransform(translationX: 0, y: -50)
            self.successImage.transform = CGAffineTransform(translationX: 0, y: -50)
            self.scrollerView.transform = CGAffineTransform(translationX: 0, y: -150)
            self.searchLb.transform = CGAffineTransform(translationX: 0, y: -150)
            self.mainMatchView.transform = CGAffineTransform(translationX: 0, y: -150)
            } else {
            // 6
            self.bgImageView.transform = CGAffineTransform(translationX: 0, y: -80)
            self.successImage.transform = CGAffineTransform(translationX: 0, y: -80)
            self.scrollerView.transform = CGAffineTransform(translationX: 0, y: -100)
            self.searchLb.transform = CGAffineTransform(translationX: 0, y: -100)
            self.mainMatchView.transform = CGAffineTransform(translationX: 0, y: -100)

            }
        }) { (_) in
            
            UIView.animate(withDuration: 0.5, animations: {
                self.successImage.image = UIImage(named: "match_device_successed")
                
            })
            
        }
    }
    
    @IBAction func leftBtnAction(_ sender: AnyObject) {
        
        if indexDevice <= 0 {
            return
        }
        ((pairModel?[indexDevice])! as PairModle).isHidden = true
        indexDevice -= 1
        collectionView.scrollToItem(at: IndexPath(row: indexDevice, section: 0), at: UICollectionViewScrollPosition.left, animated: false)
        ((pairModel?[indexDevice])! as PairModle).isHidden = false
        print(indexDevice)
        collectionView.reloadData()
    }
    
    //已适配
    @IBAction func rightBtnAction(_ sender: AnyObject) {
        if indexDevice >= (pairModel?.count)! - 1 {
            return
        }
        
        collectionView.scrollToItem(at: IndexPath(row: indexDevice, section: 0), at: UICollectionViewScrollPosition.left, animated: false)
        ((pairModel?[indexDevice])! as PairModle).isHidden = true
        indexDevice += 1
        ((pairModel?[indexDevice])! as PairModle).isHidden = false
        print(indexDevice)
        collectionView.reloadData()

    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
 
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

  

}

extension PairSuccessController: UICollectionViewDelegate,UICollectionViewDataSource ,UIScrollViewDelegate{
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pairModel?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "pairsuccessCellID", for: indexPath) as! SuccessPairCell

        //默认锁定第一个
        cell.finishImage.isHidden = ((pairModel?[indexPath.row])! as PairModle).isHidden!
        
        return cell
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexDevice == indexPath.row {
            return
        }
        
        ((pairModel?[indexDevice])! as PairModle).isHidden = true
        
        ((pairModel?[indexPath.row])! as PairModle).isHidden = false
        
        indexDevice = indexPath.row
        self.collectionView.reloadData()
        
    }

    
    
}
