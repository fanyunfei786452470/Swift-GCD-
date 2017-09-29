//
//  DispatchSource_VC.swift
//  swift(GCD)
//
//  Created by 范云飞 on 2017/8/30.
//  Copyright © 2017年 范云飞. All rights reserved.
//

import UIKit
var timerQueue:DispatchQueue? = nil
var Timer:DispatchSource? = nil
class DispatchSource_VC: UIViewController
{
    var indexPath = IndexPath()
    
    //MARK:---------------------创建定时器--------------------
    var timeoutCount:Float = 0 /* 用于超时计数 */
    var timeoutLength:Float = 20 /* 设定20为超时的长度 */
    var timeInterval:Float = 0.0 /* 时间间隔 */
    var isFinish:Bool = false /* 结束任务完成的标志 */
    //MARK:---------------------- end ----------------------
    
    //MARK:--------------------- 文件监听 -------------------
    var path:String = ""
    var vnodeSource:DispatchSource? = nil
    var vnodeQueue:DispatchQueue? = nil
    //MARK:---------------------- end ----------------------
    
    
    //MARK:-------------------- 读取文件 --------------------
    var readSource:DispatchSource? = nil
    //MARK:---------------------- end ----------------------
    
    
    //MARK:-------------------- 写文件 ----------------------
    var pathWirte:String = ""
    
    var writeSource:DispatchSource? = nil
    //MARK:---------------------- end ----------------------
    
    
    //MARK:-------------------- 自定义事件 -------------------
    var customSource:DispatchSource? = nil
    //MARK:---------------------- end ----------------------
    
    
    //MARK:-------------------- 分派源 ----------------------
    
    //MARK:---------------------- end ----------------------
    
    
    //MARK:-------------------- 监听进程 --------------------
    
    //MARK:---------------------- end ----------------------
    
    
    //MARK:-------------------- 监听信号 --------------------
    var signalSource:DispatchSource? = nil
    //MARK:-------------------- end ------------------------
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.title = "DispatchSource_VC"
        self.view.backgroundColor = UIColor.white
        if indexPath.row == 0
        {
            timeInterval = 0.1;
            timeoutCount = 0;
            timeoutLength = 20;
            Create_Timer()
        }
        if indexPath.row == 1
        {
            Create_Read_File()
        }
        if indexPath.row == 2
        {
            Create_Write_File()
        }
        if indexPath.row == 3
        {
            Create_Monitor_File()
        }
        if indexPath.row == 4
        {
            Create_Custom_Event()
        }
        if indexPath.row == 5
        {
            
        }
        if indexPath.row == 6
        {
            Create_Monitor_Signal()
        }
        
        /* 初始化操作按钮 */
        Create_UI()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:初始化操作按钮
    func Create_UI() {
        let button = UIButton()
        button.center = view.center
        button.frame = CGRect(x: 100, y: 100, width: 100, height: 30)
        button.backgroundColor = UIColor.black
        view.addSubview(button)
        button.addTarget(self, action: #selector(self.click), for: .touchUpInside)
    }
    
    func click(_ sender: UIButton) {
        if indexPath.row == 3 {
            try? FileManager.default.removeItem(atPath: path)
        }
    }
    
    //MARK:----------------------- 创建定时器--------------------
    func CreateDispatchTimer(interval:UInt64, leeway:UInt64, queue: DispatchQueue, block:DispatchWorkItem) -> DispatchSource
    {
        if Timer == nil
        {
            Timer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.global()) as? DispatchSource
            if (Timer != nil)
            {
                Timer?.scheduleRepeating(deadline: DispatchTime.now(), interval: DispatchTimeInterval.milliseconds(100), leeway: DispatchTimeInterval.seconds(1))
                Timer?.setEventHandler(handler: block)
                Timer?.resume()
            }
        }
        return Timer!
    }
    
    func MyCreateTimerInterval(timeInterval:Float, block:DispatchWorkItem) -> Void
    {
        if timerQueue == nil
        {
            timerQueue = DispatchQueue(label: "com.timeout.queue")
            let _:DispatchSource = CreateDispatchTimer(interval: (UInt64)(timeInterval) * NSEC_PER_SEC, leeway: (UInt64)(timeInterval) * NSEC_PER_SEC, queue: timerQueue!, block: block)
            print("creating a timeout queue is ok")
        }
    }
    
    /* 创建一个定时器 timer */
    func Create_Timer() {
        let workItem = DispatchWorkItem
        {
            self.checkTimeOut()
        }
        
        
        DispatchQueue(label: "time_out_control").async(execute: {() -> Void in
            DispatchSource_VC.shareInstance.MyCreateTimerInterval(timeInterval: self.timeInterval, block: workItem)
                /* 耗时操作 */
            self.TimeConsumingTasks()
        })
        
        while !isFinish {
            if UIApplication.shared.applicationState != .active {
                break
            }
            else {
                RunLoop.current.run(mode: .defaultRunLoopMode, before: Date.distantFuture)
            }
        }
        
        DispatchQueue.main.async(execute: {() -> Void in
            print("***********timeoutCount:\(self.timeoutCount)*********")
            print("***********timeoutCount * timeInterval:\(self.timeoutCount * (self.timeInterval))*********")
            print("***********\("到此为止")*********")
            self.timeoutCount = 0
        })
    }
    
    /* 检查超时的方法 */
    func checkTimeOut()
    {
        timeoutCount += 1
        if timeoutCount * (timeInterval) >= timeoutLength
        {
            print("**********************你大爷的已经超时了*****************")
            return
        }
    }
    
    /* 耗时方法 */
    func TimeConsumingTasks()
    {
        for index in 0..<100000
        {
            print("*****************执行任务中\(index)*****************")
            /* 此处判断是否超时，超时直接终止耗时操作 */
            if timeoutCount * (timeInterval) >= timeoutLength
            {
                DispatchSource_VC.shareInstance.stopTimer()
                self.performSelector(onMainThread: #selector(endRunLoop), with: nil, waitUntilDone: false)
                break
            }
        }
        
        /* 此处唤醒 runloop(没有超时) */
        if isFinish == false
        {
            DispatchSource_VC.shareInstance.stopTimer()
            self.performSelector(onMainThread: #selector(endRunLoop), with: nil, waitUntilDone: false)
        }
    }
    
    /* 注销Timer */
    func stopTimer()
    {
        let Condition = NSCondition()
        Condition.lock()
        do {
            if (Timer != nil)
            {
                Timer!.setCancelHandler(handler: {() -> Void in
                })
                Timer!.cancel()
                Timer = nil
                do {
                    if (timerQueue != nil)
                    {
                        Timer = nil
                        timerQueue = nil
                    }
                }
            }
        }
        Condition.unlock()
    }
    
    /* 结束runloop的跑圈 */
    func endRunLoop()
    {
        isFinish = true
    }
    //MARK:-------------------------- end -----------------------
    
    //MARK:----------------------- 文件读取 ----------------------
    func Create_Read_File()
    {
        if readSource != nil
        {
            readSource?.cancel()
        }
        let fileName:NSString = "/Users/fanyunfei/Desktop/iOS学习/swift学习/swift(UI阶段)/swift(GCD)/swift(GCD)/最近iOS学习大致计划.rtf"
        let fd: Int = Int(`open`(fileName.utf8String!, O_RDONLY))
        print("read fd:%d",fd)
        
        if fd == -1
        {
            return
        }
        let result:Int32 = fcntl(Int32(fd), F_SETFL, O_NONBLOCK)
        print("result %d",result)
        
        let queue = DispatchQueue(label: "readfile.com")
        let reSource = DispatchSource.makeReadSource(fileDescriptor: Int32(fd), queue: queue) as? DispatchSource
        
        if reSource == nil
        {
            close(Int32(fd))
            return
        }
        
        /* 只要文件写入新内容，就会自动读入新内容 */
        reSource?.setEventHandler(handler: {
            let estimated:UInt = (reSource?.data)!
            print("Read From File, estimated length: %ld",estimated)
            
            if (estimated <= 0)
            {
                print("Read Error:")
                reSource?.cancel()/*如果文件发生了截短，事件处理器会一直不停地重复 */
            }
            
            /* 把数据读入buffer */
            let buffer = malloc(Int(estimated))
            if (buffer != nil)
            {
                let actual:ssize_t = read(Int32(fd), buffer, Int(estimated))
                print("Read From File, actual length: %ld",actual)
                print(type(of: buffer))
                print("Readed Data: \n%s",buffer!)
                free(buffer)
            }
        })

        reSource?.setCancelHandler(handler: { 
            print("Read from file Cancenled")
            close(Int32(fd))
        })
        
        reSource?.resume()
        
        readSource = reSource;
    }
    //MARK:-------------------------- end -----------------------
    
    //MARK:----------------------- 写文件 ------------------------
    func Create_Write_File()
    {
        if writeSource != nil
        {
            return
        }
        
        /* 监听文件事件 */
        let fm = FileManager.default
        pathWirte = "/Users/fanyunfei/Desktop/iOS学习/swift学习/swift(UI阶段)/OC(GCD)/OC(GCD)/write.txt"
        print("\n path \(pathWirte)")
        (fm.createFile(atPath: pathWirte, contents: nil, attributes: nil)) ? print("创建文件成功") : print("创建文件失败")
        let fd: Int = Int(`open`(pathWirte, O_WRONLY | O_CREAT | O_TRUNC, (S_IRUSR | S_IWUSR | S_ISUID | S_ISGID)))
        print("Write fd:\(fd)")
        
        if fd == -1
        {
            return
        }
        fcntl(Int32(fd), F_SETFL)
        
        let wSource = DispatchSource.makeWriteSource(fileDescriptor: Int32(fd), queue: DispatchQueue.global()) as? DispatchSource
        
        wSource?.setEventHandler {
            let buffetSize:size_t = 100
            let buffer = malloc(buffetSize)
            var content:String = "Write Data Action: "
            content = content.appending("=new info=")
            
            let writeContent:String = content.appending("你大爷的快点\n")
            let actual = strlen(writeContent)
            memcpy(buffer, writeContent, Int(actual))
            write(Int32(fd), buffer, Int(actual))
            print("Write to file Finished")
            free(buffer)
            wSource?.suspend()
        }
        
        wSource?.setCancelHandler { 
            print("Write to file Canceled")
            close(Int32(fd))
        }
        if wSource == nil
        {
            close(Int32(fd))
            return
        }
        wSource?.resume()
        
        writeSource = wSource
    }
    //MARK:-------------------------- end -----------------------
    
    //MARK:----------------------- 文件监听 ----------------------
    func applicationDocumentsDirectory() -> String
    {
        return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last!
    }
    
    func Create_Monitor_File()
    {
        /* 监听文件事件 */
        let fm = FileManager.default
        path = "/Users/fanyunfei/Desktop/iOS学习/swift学习/swift(UI阶段)/OC(GCD)/OC(GCD)/write.txt"
        print("\n path \(path)")
        
        (fm.createFile(atPath: path, contents: nil, attributes: nil)) ? print("创建文件成功") : print("创建文件失败")
        let infd: Int = Int(`open`((path as NSString).fileSystemRepresentation, O_EVTONLY))
        vnodeQueue = DispatchQueue(label: "file.com", qos: DispatchQoS.userInitiated, attributes: DispatchQueue.Attributes.concurrent, autoreleaseFrequency: DispatchQueue.AutoreleaseFrequency.inherit, target: nil)
        
        /* 监听文件 */
        vnodeSource = DispatchSource.makeFileSystemObjectSource(fileDescriptor: Int32(infd), eventMask: DispatchSource.FileSystemEvent.delete, queue: vnodeQueue) as? DispatchSource
        vnodeSource!.setEventHandler(handler: {() -> Void in
            let flag: UInt = self.vnodeSource!.data
            if flag != 0
            {
                print("监听到文件删除")
            }
        })
        /* 不在监听时关闭文件 */
        vnodeSource!.setCancelHandler(handler: {() -> Void in
            close(Int32(infd))
        })
        /* 启动 */
        vnodeSource?.resume()
        
    }
    //MARK:-----------------------  end -------------------------
    
    //MARK:--------------------- 自定义事件------------------------
    func Create_Custom_Event()
    {
        if customSource != nil
        {
            customSource = nil
        }
        let queue = DispatchQueue(label: "custom.event.com", qos: DispatchQoS.userInitiated, attributes: DispatchQueue.Attributes.concurrent, autoreleaseFrequency: DispatchQueue.AutoreleaseFrequency.inherit, target: nil)
        customSource = DispatchSource.makeUserDataAddSource(queue: queue) as? DispatchSource
        
        /* 监听后台任务设置 */
        customSource?.setEventHandler(handler: { 
            let value :UInt = self.customSource!.data
            print("监听到数据：%ld   当前线程：%@",value,Thread.current)
        })
        
        customSource?.setCancelHandler(handler: { 
            print("取消监听")
        })
        
        /* 恢复任务，必须调用 */
        customSource?.resume()
        
        /* 发送一个数据1000 进行测试 */
        customSource?.add(data: 1000)
    }
    //MARK:------------------------ end -------------------------
    
    //MARK:----------------------- 监听进程 ----------------------
    
    //MARK:-------------------------- end -----------------------
    
    //MARK:----------------------- 监听信号 ----------------------
    func Create_Monitor_Signal()
    {
        if signalSource != nil
        {
            signalSource?.cancel()
        }
        signal(SIGCHLD, SIG_IGN)
        let queue = DispatchQueue(label: "com.signal", qos: DispatchQoS.userInitiated, attributes: DispatchQueue.Attributes.concurrent, autoreleaseFrequency: DispatchQueue.AutoreleaseFrequency.inherit, target: nil)
        let sSource = DispatchSource.makeSignalSource(signal: Int32(DispatchSource.ProcessEvent.signal.rawValue), queue: queue) as? DispatchSource
        if sSource != nil
        {
            sSource?.setEventHandler(handler: { 
                var i: Int = 0
                i += 1
                print("signal Detected:%ld",i)
            })
            
            sSource?.setCancelHandler(handler: { 
                print("signal canceled")
            })
            
            sSource?.resume()
        }
        
        signalSource = sSource;
    }
    //MARK:------------------------  end ------------------------
}

//MARK:DispatchSource_VC的扩展
let sourceSingle = DispatchSource_VC()
extension DispatchSource_VC
{
    static var shareInstance:DispatchSource_VC
    {
        return sourceSingle
    }
}

