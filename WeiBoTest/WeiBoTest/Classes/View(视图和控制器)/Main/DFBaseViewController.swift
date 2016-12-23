//
//  DFBaseViewController.swift
//  WeiBoTest
//
//  Created by DFD on 2016/12/21.
//  Copyright © 2016年 dfd. All rights reserved.
//

import UIKit

class DFBaseViewController: UIViewController {

    
    lazy var navigationBar = UINavigationBar(frame: CGRect(x:0, y:0, width:UIScreen.cz_screenWidth(), height:64))
    
    lazy var navItem = UINavigationItem()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        
        setupUI()
        
    }
    
    override var title: String? {
        
        didSet{
        
            navItem.title = title
            
        }
        
    }

}


extension DFBaseViewController {
    
    func setupUI(){
        
        view.backgroundColor = UIColor.cz_random()
        
        view.addSubview(navigationBar)
        
        navigationBar.barTintColor = UIColor.cz_color(withHex: 0xF6F6F6)
        
        navigationBar.items = [navItem]
        
        
        
        
    }

}
