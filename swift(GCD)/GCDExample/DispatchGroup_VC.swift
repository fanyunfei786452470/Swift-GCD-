//
//  DispatchGroup.swift
//  swift(GCD)
//
//  Created by 范云飞 on 2017/8/30.
//  Copyright © 2017年 范云飞. All rights reserved.
//

import UIKit

class DispatchGroup_VC: UIViewController
{
    var indexPath = IndexPath()

    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.title = "DispatchGroup_VC"
        self.view.backgroundColor = UIColor.white
        
        if indexPath.row == 0 {
            Create_group()
        }
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }

    //MARK:分组并发请求
    func Create_group()
    {
        let group = DispatchGroup()
        let queue = DispatchQueue(label: "group.com", qos: .userInitiated, attributes: .concurrent, autoreleaseFrequency: .workItem, target: nil)
        group.enter()
        /* 模拟请求1 */
        queue.async(group: group, execute: {() -> Void in
            Thread.sleep(forTimeInterval: 3)
            group.leave()
            print("请求1完成")
        })
        
        /* 模拟请求2 */
        group.enter()
        queue.async(group: group, execute: {() -> Void in
            Thread.sleep(forTimeInterval: 0.01)
            group.leave()
            print("请求2完成")
        })
        
        /* 模拟请求3 */
        group.enter()
        queue.async(group: group, execute: {() -> Void in
            Thread.sleep(forTimeInterval: 0.0001)
            group.leave()
            print("请求3完成")
        })

        group.notify(queue: DispatchQueue.main) { 
            print("任务完成，刷新")
        }
    }
}
