//
//  DispatchOnce_VC.swift
//  swift(GCD)
//
//  Created by 范云飞 on 2017/9/12.
//  Copyright © 2017年 范云飞. All rights reserved.
//

import UIKit

class DispatchOnce_VC: UIViewController
{
    var indexPath = IndexPath()
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        if indexPath.row == 0
        {
            Create_once()
        }
        if indexPath.row == 1
        {
            Create_single()
        }
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }

    //MARK:代码只执行一次
    func Create_once()
    {
        /**
         由于swift3.0 中去掉了dispatch_once 的api
         因此需要我们自己扩展
         */
        DispatchQueue.once(token: "com.once") { (Void) in
            print("do this once!")
        }
    }
    
    //MARK:创建单例
    func Create_single()
    {
        let single1 = Single.shareInstance2
        let single2 = Single.shareInstance3
        let single3 = Single.shareInstance3
        
        /* 创建的三个对象的地址都是一样的 */
        print("single1\(single1)")
        print("single2\(single2)")
        print("single3\(single3)")
        
    }
}
