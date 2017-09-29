//
//  Single.swift
//  swift(GCD)
//
//  Created by 范云飞 on 2017/9/20.
//  Copyright © 2017年 范云飞. All rights reserved.
//

import UIKit

let single = Single()
class Single: NSObject
{
    var Name:String = ""/* 可以利用此属性验证单例传值 */
    
    //MARK:静态创建的方式
    class var shareInstance2 : Single
    {
        return single
    }
    
    //MARK:struct创建方式
    static var shareInstance3:Single
    {
        return single
    }
    
    /* init方法 */
    override init()
    {
        super.init()
        print("调用初始化方法")
    }
}

//MARK:通过给DispatchQueue添加扩展
public extension DispatchQueue
{
    private static var _onceTracker = [String]()
    
    /**
     Executes a block of code, associated with a unique token, only once.  The code is thread safe and will
     only execute the code once even in the presence of multithreaded calls.
     
     - parameter token: A unique reverse DNS style name such as com.vectorform.<name> or a GUID
     - parameter block: Block to execute once
     */
    public class func once(token: String, block:(Void)->Void)
    {
        objc_sync_enter(self);
        defer
        {
            objc_sync_exit(self)
        }
        
        if _onceTracker.contains(token)
        {
            return
        }
        _onceTracker.append(token)
        block()
    }
}

