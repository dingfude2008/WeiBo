//
//  WeBoTestCommond.swift
//  WeiBoTest
//
//  Created by DFD on 2016/12/28.
//  Copyright © 2016年 dfd. All rights reserved.
//

import Foundation

// 全局共享变量

// MARK: - 应用程序信息
/// 应用程序 ID
let WBAppKey = "1027304610"
/// 应用程序加密信息(开发者可以申请修改)
let WBAppSecret = "c0733c56ed9f6a670301b975d7b6faeb"
/// 回调地址 - 登录完成调转的 URL，参数以 get 形式拼接
let redirect_uri = "http://www.sz-hema.com/"
//
//let client_id = "1027304610"
//
//let redirect_uri = "http://www.sz-hema.com/"
//
//let secret = "c0733c56ed9f6a670301b975d7b6faeb"


let WeiBoTestUserShouldLoginNotification = "WeiBoTestUserShouldLoginNotification"       // 应该登陆通知


let WeiBoTestUserLoginSuccessNotification = "WeiBoTestUserShouldLoginNotification"      // 登陆成功通知



// MARK: - 微博配图视图常量
// 配图视图外侧的间距
let DFStatusPictureViewOutterMargin = CGFloat(12)
// 配图视图内部图像视图的间距
let DFStatusPictureViewInnerMargin = CGFloat(3)
// 视图的宽度的宽度
let DFStatusPictureViewWidth = UIScreen.cz_screenWidth() - 2 * DFStatusPictureViewOutterMargin
// 每个 Item 默认的宽度
let DFStatusPictureItemWidth = (DFStatusPictureViewWidth - 2 * DFStatusPictureViewInnerMargin) / 3


// MARK: - 照片浏览通知定义
/// @param selectedIndex    选中照片索引
/// @param urls             浏览照片 URL 字符串数组
/// @param parentImageViews 父视图的图像视图数组，用户展现和解除转场动画参照
/// 微博 Cell 浏览照片通知
let DFStatusCellBrowserPhotoNotification = "DFStatusCellBrowserPhotoNotification"
/// 选中索引 Key
let DFStatusCellBrowserPhotoSelectedIndexKey = "DFStatusCellBrowserPhotoSelectedIndexKey"
/// 浏览照片 URL 字符串 Key
let DFStatusCellBrowserPhotoURLsKey = "DFStatusCellBrowserPhotoURLsKey"
/// 父视图的图像视图数组 Key
let DFStatusCellBrowserPhotoImageViewsKey = "DFStatusCellBrowserPhotoImageViewsKey"









