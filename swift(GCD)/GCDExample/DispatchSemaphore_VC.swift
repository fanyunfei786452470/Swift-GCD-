//
//  DispatchSemaphore_VC.swift
//  swift(GCD)
//
//  Created by 范云飞 on 2017/8/30.
//  Copyright © 2017年 范云飞. All rights reserved.
//

import UIKit

class DispatchSemaphore_VC: UIViewController
{
    var indexPath = IndexPath()

    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.title = "DispatchSemaphore_VC"
        self.view.backgroundColor = UIColor.white
        if indexPath.row == 0
        {
            Create_semaphore_t0()
        }
        if indexPath.row == 1
        {
            Create_semaphore_t1()
        }
        if indexPath.row == 2
        {
            Create_semaphore_t2()
        }
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }

    //MARK:数组添加数据
    func Create_semaphore_t0()
    {
        let queue = DispatchQueue(label: "com.Create_semaphore_t0", qos: .userInitiated, attributes: DispatchQueue.Attributes.concurrent, autoreleaseFrequency: DispatchQueue.AutoreleaseFrequency.workItem, target: nil)
        
        let semaphore = DispatchSemaphore(value: 1)
        let array = NSMutableArray()
        
        let workItem = DispatchWorkItem
        {
            for i in 0..<100000
            {
                semaphore.wait()
                print("\(i)")
                array.add("\(i)")
                semaphore.signal()
            }
        }
        
        queue.async(execute: workItem)
        workItem.notify(queue: DispatchQueue.main) { 
            print("完事")
            print(array)
        }
    }
    
    //MARK:汽车的例子
    func Create_semaphore_t1()
    {
        let semaphore = DispatchSemaphore(value: 0)
        
        let time = DispatchTime.now() + 5
        
        print("begin ===> 车库开始营业了")
        
        let result = semaphore.wait(timeout: time)
        
        if result == DispatchTimeoutResult.success
        {
            print("result = 0 ==> 有车位，无需等待！==> 在这里可安全地执行【需要排他控制的处理（比如只允许一条线程为mutableArray进行addObj操作）】")
            semaphore.signal()
        }
        else
        {
            print("result != 0 ==> timeout，deadline，忍受不了，走了。。")
        }
        
    }
    
    //MARK:控制并发数
    func Create_semaphore_t2()
    {
        
    }
    
}
