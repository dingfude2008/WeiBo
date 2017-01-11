//
//  DFHomeViewController.swift
//  WeiBoTest
//
//  Created by DFD on 2016/12/21.
//  Copyright © 2016年 dfd. All rights reserved.
//

import UIKit

/// 原创微博可重用 cell id
fileprivate let originalCellId = "originalCellId"
/// 被转发微博的可重用 cell id
fileprivate let retweetedCellId = "retweetedCellId"


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
        
        
        let statesViewModel : DFStatesViewModel = listViewModel.statuesList[indexPath.row]
        
        let cellId = (statesViewModel.status.retweeted_status != nil) ? retweetedCellId : originalCellId
        
        // 取cell
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! DFStatusCell
        
        // 设置cell
        
        cell.statusViewModel = statesViewModel
        
        // 返回cell
        return cell
    }
    
    
    /*
     
     缓存行高步骤
     1，打开xib/纯代码， 按照从上到下的顺序，以此计算出控件的高度公式，多行的文本标记上显示宽度和字号
     2，计算行高方法  1>在视图模型中，根据公式，定义需要的常量 --->间距，图标，标签视图计算大小，标签的字体
                    2> 定义变量 height
                    3> 从上到下，一次计算， 不要跳跃，不要省略
     3,在构造函数的最后，计算行高
     4,在更新单图尺寸后，再次计算。 凡是cell外部代码导致的cell内部高度变化，都需要重新集计算
     5,调整控制器，1>在base控制器中 实现tableview height 的代理方法，随便返回一个数值。
                    目的，保证子类可以重写方法，否则子类的行高方法不会被执行
                2>在子类中重写行高方法，返回视图模型中计算的行高
                3>取消自动行高
     
     
     */
    
    
    // 注意这里没有使用 override 说明父类没有提高这个方法
    // 3.0中 父类必须实现代理方法，子类才可以重写， 2.0中不需要
    // 这里如果想要使用缓存行高，也就是进这个方法，必须让他的父类实现这个方法，然后再重写
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let vm = listViewModel.statuesList[indexPath.row]
        
        return vm.rowHeight
    }
    
    
}


// MARK: - 设置 UI
extension DFHomeViewController {
    
    override func setupTableView() {
        
        super.setupTableView()
        
        navItem.leftBarButtonItem = UIBarButtonItem(title: "好友", target: self, action: #selector(showFriends))
        
        tableView?.register(UINib(nibName: "DFStatusNormalCell", bundle: nil), forCellReuseIdentifier: originalCellId)
        tableView?.register(UINib(nibName: "DFStatusRetweetedCell", bundle: nil), forCellReuseIdentifier: retweetedCellId)
        
        
        // 有了缓存行高后，就不要使用自动行高了
        tableView?.rowHeight = UITableViewAutomaticDimension    // 自动行高
        
        tableView?.estimatedRowHeight = 300 // 预估行高
        
        tableView?.separatorStyle = .none
        
        setupTitle()
    }
    
    fileprivate func setupTitle(){
        
        let title = DFNetwokrManager.shared.userAccount.screen_name
        
        let button = DFTitleButton(title: title)
        
        button.addTarget(self, action: #selector(clickTitleButton), for: .touchUpInside)
        
        navItem.titleView = button
    }
    
    @objc fileprivate func clickTitleButton(btn: UIButton) {
    
        btn.isSelected = !btn.isSelected
    }
    
    
}

