//
//  DispatchQueue.swift
//  swift(GCD)
//
//  Created by 范云飞 on 2017/8/30.
//  Copyright © 2017年 范云飞. All rights reserved.
//

import UIKit

class DispatchQueue_VC: UIViewController {

    var indexPath = IndexPath()
    
    var ImageView1:UIImageView?
    var ImageView2:UIImageView?
    var ImageView3:UIImageView?/* 合并过的图片 */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "DispatchQueue_VC"
        self.view.backgroundColor = UIColor.white
        
        if indexPath.row == 0 {
            Create_async_concurrent()
        }
        if indexPath.row == 1 {
            Create_async_serial()
        }
        if indexPath.row == 2 {
            Create_sync_concurrent()
        }
        if indexPath.row == 3 {
            Create_sync_serial()
        }
        if indexPath.row == 4 {
            Create_global()
        }
        if indexPath.row == 5 {
            Create_main()
        }
        if indexPath.row == 6 {
            Create_after()
        }
        if indexPath.row == 7 {
            Create_workItem()
        }
    }
    
    //MARK:初始化控件
    func setUI() {
        self.ImageView1 = UIImageView(frame: CGRect(x: 50,
                                                    y: 100,
                                                width: 100,
                                               height: 100
        ))
        self.view.addSubview(self.ImageView1!);
        
        self.ImageView2 = UIImageView(frame: CGRect(x: 200,
                                                    y: 100,
                                                width: 100,
                                               height: 100
        ))
        self.view.addSubview(self.ImageView2!)
        
        self.ImageView3 = UIImageView(frame: CGRect(x: 100,
                                                    y: 300,
                                                width: 200,
                                               height: 100
        ))
        self.view.addSubview(self.ImageView3!)
    }
    
    //MARK:下载图片并和并
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let queue = DispatchQueue(label: "创建串行队列")
        
        var image1: UIImage? = nil
        queue.sync {
            /* 获取图片的URL */
            let url = URL(string: "http://scimg.jb51.net/allimg/151109/14-15110Z9535JH.jpg")
            /* 下载图片的二进制数据 */
            let image1Data = try? Data(contentsOf: url!)
            /* 转换图片 */
            image1 = UIImage(data: image1Data!)
        }
        var image2: UIImage? = nil
        
        queue.sync {
            /* 获取图片的URL */
            let url = URL(string: "http://scimg.jb51.net/allimg/151109/14-15110Z9535JH.jpg")
            /* 下载图片的二进制数据 */
            let image2Data = try? Data(contentsOf: url!)
            /* 转换图片 */
            image2 = UIImage(data: image2Data!)
            
        }
        
        DispatchQueue.main.async {
            print("图片合并开始---\(Thread.current)")
            
            self.ImageView1?.image = image1
            
            self.ImageView2?.image = image2
            
            /* 合并两张图片 */
            /* 注意最后一个参数是浮点数（0.0）,不要写成0 */
            UIGraphicsBeginImageContextWithOptions(CGSize(width: 200, height: 100), false, 0.0)
            
            image1?.draw(in: CGRect(x: 0,
                                    y: 0,
                                width: 100,
                               height: 100
            ))
            
            image2?.draw(in: CGRect(x: 100,
                                    y: 0,
                                width: 100,
                               height: 100
            ))
            
            self.ImageView3?.image = UIGraphicsGetImageFromCurrentImageContext()
            /* 关闭上下文 */
            UIGraphicsEndImageContext()
            
            print("图片合并完成---\(Thread.current)")
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:异步+并行
    func Create_async_concurrent() {
        let concurrentQueue = DispatchQueue(label: "concurrentQueue.com", qos: .default, attributes: .concurrent, autoreleaseFrequency: .workItem , target: nil)
        
        /* 模拟请求1 */
        concurrentQueue.async(execute: {() -> Void in
            Thread.sleep(forTimeInterval: 2)
            print("请求1完成")
        })
        /* 模拟请求2 */
        concurrentQueue.async(execute: {() -> Void in
            Thread.sleep(forTimeInterval: 3)
            print("请求2完成")
        })
        /* 模拟请求3 */
        concurrentQueue.async(execute: {() -> Void in
            Thread.sleep(forTimeInterval: 0.001)
            print("请求3完成")
        })
        
        concurrentQueue.async(group: nil, qos: .default, flags: .barrier) { 
            print("滚犊子")
            Thread.sleep(forTimeInterval: 0.001)
        }
        
        /* 模拟请求4 */
        concurrentQueue.async(execute: {() -> Void in
            Thread.sleep(forTimeInterval: 0.01)
            print("请求4完成")
        })
        
        DispatchQueue.main.async {
            print("执行完事")
        }
        
    }
    
    //MARK:异步+串行
    func Create_async_serial() {
        let concurrentQueue = DispatchQueue(label: "concurrentQueue.com")
        
        /* 模拟请求1 */
        concurrentQueue.async(execute: {() -> Void in
            Thread.sleep(forTimeInterval: 2)
            print("请求1完成")
        })
        
        /* 模拟请求2 */
        concurrentQueue.async(execute: {() -> Void in
            Thread.sleep(forTimeInterval: 3)
            print("请求2完成")
        })
        
        /* 模拟请求3 */
        concurrentQueue.async(execute: {() -> Void in
            Thread.sleep(forTimeInterval: 0.01)
            print("请求3完成")
        })
    }
    
    //MARK:同步+并行
    func Create_sync_concurrent() {
        let concurrentQueue = DispatchQueue(label: "concurrentQueue.com", qos: .default, attributes: .concurrent, autoreleaseFrequency: .workItem, target: nil)
        
        /* 模拟请求1 */
        concurrentQueue.sync(execute: {() -> Void in
            Thread.sleep(forTimeInterval: 2)
            print("请求1完成")
        })
        
        /* 模拟请求2 */
        concurrentQueue.sync(execute: {() -> Void in
            Thread.sleep(forTimeInterval: 3)
            print("请求2完成")
        })
        
        /* 模拟请求3 */
        concurrentQueue.sync(execute: {() -> Void in
            Thread.sleep(forTimeInterval: 0.01)
            print("请求3完成")
        })
    }
    
    //MARK:同步+串行
    func Create_sync_serial() {
        let concurrentQueue = DispatchQueue(label: "concurrentQueue.com")
        
        /* 模拟请求1 */
        concurrentQueue.sync(execute: {() -> Void in
            Thread.sleep(forTimeInterval: 2)
            print("请求1完成")
        })
        
        /* 模拟请求2 */
        concurrentQueue.sync(execute: {() -> Void in
            Thread.sleep(forTimeInterval: 3)
            print("请求2完成")
        })
        
        /* 模拟请求3 */
        concurrentQueue.sync(execute: {() -> Void in
            Thread.sleep(forTimeInterval: 0.01)
            print("请求3完成")
        })
    }
    
    //MARK:全局队列
    func Create_global() {
        /* 请求1 */
        DispatchQueue.global().async { 
            Thread.sleep(forTimeInterval: 6)
            print("请求1完成")
        }
        
        /* 请求2 */
        DispatchQueue.global().async { 
            Thread.sleep(forTimeInterval: 3)
            print("请求2完成")
        }
        
        /* 请求3 */
        DispatchQueue.global().async { 
            Thread.sleep(forTimeInterval: 0.01)
            print("请求3完成")
        }
    }
    
    //MARK:主队列
    func Create_main() {
        
        for index in 0..<20 {
            print("\(index)")
        }
        
        /* 请求1 */
        DispatchQueue.main.async { 
            Thread.sleep(forTimeInterval: 6)
            print("请求1完成")
        }
        
        /* 请求2 */
        DispatchQueue.main.async { 
            Thread.sleep(forTimeInterval: 4)
            print("请求2完成")
        }
        
        /* 请求3 */
        DispatchQueue.main.async { 
            Thread.sleep(forTimeInterval: 0.01)
            print("请求3完成")
        }
    }
    
    //MARK:延时提交
    func Create_after() {
        let concurrentQueue = DispatchQueue(label: "concurrentQueue.com", qos: .default, attributes: .concurrent, autoreleaseFrequency: .workItem , target: nil)
        
        /* 模拟请求1 */
        concurrentQueue.async(execute: {() -> Void in
            Thread.sleep(forTimeInterval: 2)
            print("请求1完成")
        })
        /* 模拟请求2 */
        concurrentQueue.async(execute: {() -> Void in
            Thread.sleep(forTimeInterval: 3)
            print("请求2完成")
        })
        /* 模拟请求3 */
        concurrentQueue.async(execute: {() -> Void in
            Thread.sleep(forTimeInterval: 0.001)
            print("请求3完成")
        })
        
        concurrentQueue.async(group: nil, qos: .default, flags: .barrier) {
            print("滚犊子")
            Thread.sleep(forTimeInterval: 0.001)
        }
        
        /* 模拟请求4 */
        concurrentQueue.async(execute: {() -> Void in
            Thread.sleep(forTimeInterval: 0.01)
            print("请求4完成")
        })
        
        /* 延时提交 */
        concurrentQueue.asyncAfter(deadline: DispatchTime.now() + 5, execute: { 
            print("执行完事")
        })
    }
    
    //MARK:代码块（DispatchWorkItem）
    func Create_workItem() {
        var value = 10
        let workItem = DispatchWorkItem
        {
            value += 5
        }
//        workItem.perform()/* 这种方法其实<===>DispatchQueue.main.async(execute: workItem) */
    
        let queue = DispatchQueue.global(qos: .utility)
        queue.async(execute: workItem)
        workItem.notify(queue: DispatchQueue.main) {
            print("value = ", value)
        }
        
    }

}
