//
//  DispatchIO_VC.swift
//  swift(GCD)
//
//  Created by 范云飞 on 2017/8/30.
//  Copyright © 2017年 范云飞. All rights reserved.
//

import UIKit

class DispatchIO_VC: UIViewController {
    var indexPath = IndexPath()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "DispatchIO_VC"
        self.view.backgroundColor = UIColor.white
        if indexPath.row == 0
        {
            Create_io_t_read()
        }
        if indexPath.row == 1
        {
            Create_io_t_write()
        }
        if indexPath.row == 2
        {
            Create_periodic_callback()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:---------------------------- I/O 中的read ------------------------------
    func Create_io_t_read()
    {
        
        /* 获取文件路径 */
        let fileName:NSString = "/Users/fanyunfei/Desktop/iOS学习/swift学习/swift(UI阶段)/swift(GCD)/swift(GCD)/最近iOS学习大致计划.rtf"
        
        /* dispatchfd的本质就是一个 int 型的文件描述 */
        let fd: Int = Int(`open`(fileName.utf8String!, O_RDWR))
        print("read fd:%d",fd)
        
        /* 创建队列 */
        let queue = DispatchQueue(label: "com.io", qos: DispatchQoS.userInitiated, attributes: DispatchQueue.Attributes.concurrent, autoreleaseFrequency: DispatchQueue.AutoreleaseFrequency.inherit, target: nil)
        
        /* dispatchIO可以看成一个异步I/O的处理对象 */

    }
    //MARK:-------------------------------- end ----------------------------------
    
    //MARK:---------------------------- I/O 中的write -----------------------------
    func Create_io_t_write()
    {
        
    }
    //MARK:--------------------------------- end ---------------------------------
    
    //MARK:-------------------------I/O操作中的高低水位与周期性回调 -------------------
    func Create_periodic_callback()
    {
        
    }
    //MARK:--------------------------------- end ---------------------------------
}
