//
//  DFOAuthViewController.swift
//  WeiBoTest
//
//  Created by DFD on 2016/12/28.
//  Copyright © 2016年 dfd. All rights reserved.
//

import UIKit
import SVProgressHUD




class DFOAuthViewController: UIViewController {

    fileprivate lazy var webView = UIWebView()
    
    // 把view设置webView
    override func loadView() {
        view = webView
        webView.delegate = self
    }
    
    deinit {
        print(#function)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.scrollView.isScrollEnabled = false
        
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "返回", target: self, action: #selector(close), isBack: true)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "自动填充", target: self, action: #selector(autoFill))
        
        
        let urlString = "https://api.weibo.com/oauth2/authorize?client_id=\(WBAppKey)&redirect_uri=\(redirect_uri)"
        
        guard let url = URL(string: urlString) else {
            return
        }
//
        
        
//        
        let request = URLRequest(url: url)
        
        webView.loadRequest(request)
        
    }

    @objc fileprivate func close(){
    
        SVProgressHUD.dismiss()
        
        dismiss(animated: true, completion: nil)
    
    }
    @objc fileprivate func autoFill() {
        
        let js = "document.getElementById('userId').value = 'dingfude@qq.com';" + "document.getElementById('passwd').value = 'dingfude87021699';";
        
        let str = webView.stringByEvaluatingJavaScript(from: js)
        
        print(str ?? "kong")
        
    }
    
}




// MARK: -实现代理协议
extension DFOAuthViewController : UIWebViewDelegate {

//    - (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;
//    - (void)webViewDidStartLoad:(UIWebView *)webView;
//    - (void)webViewDidFinishLoad:(UIWebView *)webView;
//    - (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error;

    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        print("将要加载 ： \(request.url?.absoluteString)")

        guard let absoluteString = request.url?.absoluteString else {
            return false
        }
        
        
        // 1， 如果加载的地址包含了 回调地址，就不加载，不包含就加载
        if !absoluteString.hasPrefix(redirect_uri) {
        
            return true
        }
        
        var range = (absoluteString as NSString).range(of: "?code=")
        
        if range.length ==  0 {
            
            print("取消授权")
            
            close()
            
            return false
        }
        
        
        range = NSMakeRange(range.location + 6, absoluteString.characters.count - range.location - 6)
        
        let code = (absoluteString as NSString).substring(with: range)
        
        
        print("access : \(access)")
        
        
        DFNetwokrManager.shared.loadAccessToken(code: code) { (isSuccess) in
            
            if !isSuccess {
            
                SVProgressHUD.showInfo(withStatus: "请求失败")
            } else {
                
                //SVProgressHUD.showInfo(withStatus: "请求成功")
                
                NotificationCenter.default.post(
                    name: NSNotification.Name(rawValue: WeiBoTestUserLoginSuccessNotification),
                    object: nil)
                
                self.close()
                
            }
            
        }
        
        return false
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        SVProgressHUD.show()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        SVProgressHUD.dismiss()
    }
    
    
}



