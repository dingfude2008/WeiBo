//
//  DFWebViewController.swift
//  WeiBoTest
//
//  Created by DFD on 2017/1/21.
//  Copyright © 2017年 dfd. All rights reserved.
//

import UIKit

class DFWebViewController: DFBaseViewController {

    /// webView
    fileprivate var webView = UIWebView(frame: UIScreen.main.bounds)
    
    var urlString: String? {
        didSet{
            guard let urlString = urlString,
                let url = URL(string: urlString)
                else {
                return
            }
            
            webView.loadRequest(URLRequest(url: url))
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

// MARK: - 设置UI
extension DFWebViewController {

    override func setupTableView() {
        
        navItem.title = "网页"
        
        
        view.insertSubview(webView, belowSubview: navigationBar)
        
        webView.backgroundColor = UIColor.white
        
        webView.scrollView.contentInset.top = navigationBar.bounds.height
        
        webView.scrollView.scrollIndicatorInsets.top = webView.scrollView.contentInset.top
        
        
    }
}

