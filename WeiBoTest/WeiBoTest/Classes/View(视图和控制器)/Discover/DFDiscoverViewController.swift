//
//  DFDiscoverViewController.swift
//  WeiBoTest
//
//  Created by DFD on 2016/12/21.
//  Copyright © 2016年 dfd. All rights reserved.
//

import UIKit

class DFDiscoverViewController: DFBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // 模拟teken过期
        DFNetwokrManager.shared.userAccount.access_token = "12"
        
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
