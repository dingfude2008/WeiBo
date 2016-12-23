//
//  DFHomeViewController.swift
//  WeiBoTest
//
//  Created by DFD on 2016/12/21.
//  Copyright © 2016年 dfd. All rights reserved.
//

import UIKit

class DFHomeViewController: DFBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    @objc fileprivate func showFriends() {
        
        self.navigationController?.pushViewController(DFDemoViewController(), animated: true)
    }

}


extension DFHomeViewController {
    
    override func setupUI() {
        super.setupUI()
        
        
        navItem.rightBarButtonItem = UIBarButtonItem(title: "好友", target: self, action: #selector(showFriends))
        
    }
    
}

