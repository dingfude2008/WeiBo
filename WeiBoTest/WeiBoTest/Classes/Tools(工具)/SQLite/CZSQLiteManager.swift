//
//  CZSQLiteManager.swift
//  刷新控件测试项目
//
//  Created by DFD on 2017/1/23.
//  Copyright © 2017年 DFD. All rights reserved.
//

import Foundation
import FMDB


/*
 1，数据库本质是存在沙盒中的一个文件，首先需要创建和打开数据库
    FMDB- 队列
 2， 创建队列
 3， 增删查改
 
 数据库开发的程序代码几乎都是一致的， 区别在 SQL
 
 一定要在 navicat中测试 SQL 的正确性
 
 
 */
class CZSQLiteManager {

    /// 单例，数据库工具访问点
    static let shared = CZSQLiteManager()
    
    /// 数据库队列
    let queue : FMDatabaseQueue
    
    // 私有构造函数，防止外部调用
    fileprivate init(){
        
        /// 数据库名称
        let dbName = "status .db"
        
        
        // 凡是方法中参数名为path的都代表着是全路径
        var path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        
        path = (path as NSString).appendingPathComponent(dbName)
        
        print("数据库存放路径 \(path)")
        
        // 创建数据库队列，创建或者打开数据库
        queue = FMDatabaseQueue(path: path)
        
        createTable()
        
    }
}


// MARK: - 创建数据表以及其他私有方法
fileprivate extension CZSQLiteManager {

    
    
    /// 创建数据表
    func createTable(){
    
        // 1, 准备 SQL
        guard let path = Bundle.main.path(forResource: "status.sql", ofType: nil),
            let sql = try? String(contentsOfFile: path)
            else {
            return
        }
        
        ///  执行
        ///  内部是串行队列，同步执行的
        ///  可以保证同一时间，同一任务操作数据库，从而保证数据的安全
        queue.inDatabase { (db) in
            
            // 只有创建表的时候可以使用 executeStatements 执行多条sql, 其他时候不能使用
            // 否则会造成sql 注入
            if db?.executeStatements(sql) == true {
                print("创建成功")
            }else {
                print("创建失败")
            }
        }
        
        print("----- over ----")
        
    
    }
    
}

// MARK: - 微博数据操作
extension CZSQLiteManager {

    /// 从数据库加载微博数据数组
    ///
    /// - Parameters:
    ///   - userId: 当前用户id
    ///   - since_id: 返回比since_id大的数据
    ///   - max_id: 返回比max_id小的数据
    /// - Returns: 微博的字典数组，将数据中的 status 字段对应的二进制反序列化，生成字典
    func loadStatus(userId: String, since_id:Int64 = 0, max_id:Int64 = 0) ->[[String: AnyObject]]{
    
        /*
         SELECT statusId, userId, status FROM T_Status
         WHERE userId = 1
         AND statusId > 110
         AND statusId < 115
         ORDER BY statusId DESC LIMIT 20;
         
         */
        
        
        // 1, 准备 sql
        var sql = "SELECT statusId, userId, status FROM T_Status \n"
        sql += "WHERE userId = \(userId) \n"
        
        if since_id > 0 {
            sql += "AND statusId > \(since_id) \n"
        } else if max_id > 0 {
            sql += "AND statusId < \(max_id) \n"
        }
        
        sql += "ORDER BY statusId DESC LIMIT 20;"
        
        print(sql)
        
        // 2, 获取数组
        let array = execRecordSet(sql: sql)
        
        var result = [[String : AnyObject]]()
        
        for dict in array {
        
            guard let jsonData = dict["status"] as? Data,
                let json = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String : AnyObject]
                else {
                continue
            }
            
            result.append(json ?? [:])
        }
        
        return result
    }
    
    
    /*
        1,从网络加载结束后，返回的是微博的‘字典的数组’, 每一个字典对应的一个完整的微博记录
            - 完整的微博记录中，包含有微博的Id
            - 微博记录中，没有包含‘当前登陆的用户Id’
     */
    /// 新增或修改微博数据，微博数据在刷新的时候，可能出现重叠，需要 REPLACE
    ///
    /// - Parameters:
    ///   - userId: 当前登陆用户的Id
    ///   - array: 从网络获取的‘字典的数组’
    func updateStatus(userId:String, array:[[String:AnyObject]]){
    
    
        // 1 准备 SQL
        /*
         statusId:  要保存的微博Id
         userId:    当前用户的userId
         status:    完整微博字典的 json 二进制数据
         */
        let sql = "INSERT OR REPLACE INTO T_Status (statusId, userId, status) VALUES (?, ?, ?);"
        
        
        // 2 执行SQL
        queue.inTransaction { (db, rollBack) in
            
            for dict in array{
            
                // 从字典中取出微博Id, 将字典序列化成二进制数据
                guard let statusId = dict["idstr"] as? String,
                    let jsonData = try? JSONSerialization.data(withJSONObject: dict, options: [])
                    else {
                    continue
                }
                
                if db?.executeUpdate(sql, withArgumentsIn: [statusId, userId, jsonData]) == false {
                
                    // 这里需要回滚  OC 中  *rollBack = YES
                    // xcode的自动转换工具不会转换此处
                    // swift 1.0 2.0 rollBack.memory = true
                    // swift 3.0写法
                    print("执行有错误，回滚")
                    rollBack?.pointee = true
                    break
                }
                
            }
            
            
        }
        
        
    }
    
    
    /// 执行一个sql,返回一个字典的数组
    ///
    /// - Parameter sql: sql
    /// - Returns: 字典的数组
    func execRecordSet(sql:String) -> [[String : AnyObject]] {
        
        var result = [[String : AnyObject]]()
        queue.inDatabase { (db) in
            
            guard let rs = db?.executeQuery(sql, withArgumentsIn: []) else {
                return
            }
            
            while rs.next() {
                
                // 列数
                let colCount = rs.columnCount()
                
                for col in 0..<colCount {
                    
                    guard let name = rs.columnName(for: col),
                        let object = rs.object(forColumnIndex: col) else {
                            continue
                    }
                    
                    result.append([name: object as AnyObject])
                }
            }
        }
        return result
    }
    
}












