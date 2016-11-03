//
//  MyLikeViewController.swift
//  OzneriFamily
//
//  Created by zhuguangyang on 16/10/25.
//  Copyright © 2016年 net.ozner. All rights reserved.
//

import UIKit

class MyLikeViewController: UIViewController {
    
    var tableView: UITableView?

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpUI()
    }

    
    func setUpUI() {
        tableView = UITableView(frame: self.view.bounds)
        
        tableView?.delegate = self
        tableView?.dataSource = self
        
        tableView?.separatorStyle = .none
        tableView?.register(UINib.init(nibName: "ZanMeTableViewCell", bundle: nil), forCellReuseIdentifier: "ZanMeTableViewCellID")
        
        view.addSubview(tableView!)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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


extension MyLikeViewController : UITableViewDelegate, UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ZanMeTableViewCellID", for: indexPath) as! ZanMeTableViewCell
        cell.selectionStyle = .none
        
        
        return cell
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 79
    }

    
}