//
//  DFHomeViewController.swift
//  WeiBoTest
//
//  Created by DFD on 2016/12/21.
//  Copyright © 2016年 dfd. All rights reserved.
//

import UIKit

// 定义全局常量
fileprivate let cellID = "cellID"


class DFHomeViewController: DFBaseViewController {

    
    fileprivate lazy var statusList = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        print("111 - >\(supportedInterfaceOrientations)")
        
    }
    
    
    @objc fileprivate func showFriends() {
        
        self.navigationController?.pushViewController(DFDemoViewController(), animated: true)
    }
    
    
    override func loadData() {
        
        for i in 0..<15 {
            
//            statusList.insert(i.description, at: 0)
            
            statusList.append(i.description)
            
        }
    }
    
    
    

}


// MARK: - 表格数据源方法
extension DFHomeViewController{
    
    // 具体的数据源方法实现
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return statusList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // 取cell
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        
//        let cell = tableView.dequeueReusableCell(withIdentifier: <#T##String#>, for: <#T##IndexPath#>)
        
        
        
        // 设置cell
        cell.textLabel?.text = statusList[indexPath.row]//    "\(indexPath.row)"
        
        // 返回cell
        return cell
    }
    
    
}


// MARK: - 设置 UI
extension DFHomeViewController {
    
    override func setupUI() {
        super.setupUI()
        
        
        navItem.leftBarButtonItem = UIBarButtonItem(title: "好友", target: self, action: #selector(showFriends))
        
        
        tableView?.register(NSClassFromString("UITableViewCell"), forCellReuseIdentifier: cellID)
        
        
        
    }
    
}

