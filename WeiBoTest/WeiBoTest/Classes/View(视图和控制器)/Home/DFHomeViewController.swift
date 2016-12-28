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

    fileprivate lazy var listViewModel = DFStatuesListViewModel()
    
//    fileprivate lazy var statusList = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //print("111 - >\(supportedInterfaceOrientations)")
        
    }
    
    
    @objc fileprivate func showFriends() {
        
        self.navigationController?.pushViewController(DFDemoViewController(), animated: true)
    }
    
    
    override func loadData() {

        print(#function)
        
        listViewModel.loadStatus(pullup: self.isPullup) { (isSuccess, shouldRefresh) in
            
            print(self.isPullup ?"上拉数据加载完成" : "下拉数据加载完成")

            self.refreshControl?.endRefreshing()

            self.isPullup = false

            if shouldRefresh {
                
                print("刷新表格")
                self.tableView?.reloadData()
            }
        }
    }
}


// MARK: - 表格数据源方法
extension DFHomeViewController{
    
    // 具体的数据源方法实现
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listViewModel.statuesList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // 取cell
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        
        // 设置cell
        cell.textLabel?.text = listViewModel.statuesList[indexPath.row].text
        
        // 返回cell
        return cell
    }
    
    
}


// MARK: - 设置 UI
extension DFHomeViewController {
    
    override func setupTableView() {
        
        super.setupTableView()
        
        navItem.leftBarButtonItem = UIBarButtonItem(title: "好友", target: self, action: #selector(showFriends))
        
        tableView?.register(NSClassFromString("UITableViewCell"), forCellReuseIdentifier: cellID)
        
        
        
    }
    
}

