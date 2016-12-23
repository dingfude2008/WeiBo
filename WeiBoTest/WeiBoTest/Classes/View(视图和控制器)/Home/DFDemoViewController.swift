//
//  DFDemoViewController.swift
//  WeiBoTest
//
//  Created by DFD on 2016/12/23.
//  Copyright © 2016年 dfd. All rights reserved.
//

import UIKit

class DFDemoViewController: DFBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
        title = "第 \(navigationController?.childViewControllers.count ?? 0) 个"
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc fileprivate  func goNext() {
        
        let vc = DFDemoViewController()
        
        navigationController?.pushViewController(vc, animated: true)
        
        
    }
    
}


extension DFDemoViewController {

    override func setupUI() {
        super.setupUI()
        
        
        navItem.rightBarButtonItem = UIBarButtonItem(title: "Next", target: self, action: #selector(goNext))
        
        
    }
}





