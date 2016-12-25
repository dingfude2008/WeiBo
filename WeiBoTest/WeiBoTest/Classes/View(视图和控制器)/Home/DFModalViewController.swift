//
//  DFModalViewController.swift
//  WeiBoTest
//
//  Created by DFD on 2016/12/24.
//  Copyright © 2016年 dfd. All rights reserved.
//

import UIKit

class DFModalViewController: DFBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        print(UIApplication.shared.delegate ?? "")
        
        
        guard let delegate = UIApplication.shared.delegate as? AppDelegate
            else {
                return
        }
        
        delegate.isSupportLandscape = true
        
        
    }
    override var shouldAutorotate: Bool {
        return true
    }
    
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        
        return .landscape
    }
    
    
    override var interfaceOrientation:UIInterfaceOrientation {
        
        return .portrait
    }
    
    override var preferredInterfaceOrientationForPresentation : UIInterfaceOrientation {
        
        return .portrait
    }
}



extension DFModalViewController {
    
    
    

}
