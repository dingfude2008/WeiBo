//
//  String+Extersion.swift
//  WeiBoTest
//
//  Created by DFD on 2017/1/18.
//  Copyright © 2017年 dfd. All rights reserved.
//

import Foundation

extension String {

    func cz_href()->(link:String, text:String)?{
        
        let pattern = "<a href=\"(.*?)\".*?>(.*?)</a>"
        
        guard let regx = try? NSRegularExpression(pattern: pattern, options: []),
            let result = regx.firstMatch(in: self, options: [], range: NSMakeRange(0, characters.count))
            else {
            return nil
        }
        
        let link = (self as NSString).substring(with: result.rangeAt(1))
        let text = (self as NSString).substring(with: result.rangeAt(2))
        
        return (link, text)
    }
    

}
