//
//  DispatchBlock_VC.swift
//  swift(GCD)
//
//  Created by 范云飞 on 2017/9/12.
//  Copyright © 2017年 范云飞. All rights reserved.
//

import UIKit

class DispatchBlock_VC: UIViewController {
    var indexPath = IndexPath()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        Create_block_t()
    }
    func Create_block_t()
    {
        let queue = DispatchQueue(label: "com.block", qos: DispatchQoS.unspecified, attributes: DispatchQueue.Attributes.concurrent, autoreleaseFrequency: DispatchQueue.AutoreleaseFrequency.workItem, target: nil)
        queue.async {
            let taskQueue = DispatchQueue(label: "com.taskQueue", qos: DispatchQoS.unspecified, attributes: DispatchQueue.Attributes.concurrent, autoreleaseFrequency: DispatchQueue.AutoreleaseFrequency.workItem, target: nil)
            let workItem = DispatchWorkItem
            {
                print("开始执行")
                for index in 0..<10000
                {
                    print("任务执行中%d",index)
                }
                print("结束执行")
            }
            
            taskQueue.async(execute: workItem)
            
            /* 等待时长，10s之后超时 */
            let timeout = DispatchTime.now() + 10
            let resutl:DispatchTimeoutResult = workItem.wait(timeout: timeout)
            if resutl == DispatchTimeoutResult.success {
                print("执行成功")
            }
            else {
                print("执行超时")
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
