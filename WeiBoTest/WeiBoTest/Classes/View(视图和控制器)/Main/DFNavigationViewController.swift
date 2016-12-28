//
//  DFNavigationViewController.swift
//  WeiBoTest
//
//  Created by DFD on 2016/12/21.
//  Copyright © 2016年 dfd. All rights reserved.
//

import UIKit


class DFNavigationViewController: UINavigationController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.isHidden = true
        
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if viewControllers.count > 0 {
            
            viewController.hidesBottomBarWhenPushed = true
            
            if let vc = viewController as? DFBaseViewController {
                
                var title = "返回"
                
                if  viewControllers.count == 1 {
                    
                    title = childViewControllers.first?.title ?? "返回"
                    
                }
                
                vc.navItem.leftBarButtonItem = UIBarButtonItem(title: title, target: self, action: #selector(popoParent), isBack:title == "返回")
            }
        }
        
        super.pushViewController(viewController, animated: true)
    }
    
    @objc private func popoParent() {
        popViewController(animated: true)
    }

}
