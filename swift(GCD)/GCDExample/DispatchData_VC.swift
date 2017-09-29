//
//  DispatchData.swift
//  swift(GCD)
//
//  Created by 范云飞 on 2017/8/30.
//  Copyright © 2017年 范云飞. All rights reserved.
//

import UIKit
#if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
    
    extension Data
    {
        
        init(referencing data: DispatchData)
        {
            self = (data as AnyObject) as! Data
        }
        
    }
    
    extension DispatchData
    {
        
        init(referencing data: Data)
        {
            guard !data.isEmpty else
            {
                self = .empty
                return
            }
            
            // will perform a copy if needed
            let nsData = data as NSData
            
            if let dispatchData = ((nsData as AnyObject) as? DispatchData)
            {
                self = dispatchData
            }
            else
            {
                self = .empty
                nsData.enumerateBytes { (bytes, byteRange, _) in
                    let innerData = Unmanaged.passRetained(nsData)
                    let buffer = UnsafeBufferPointer(start: bytes.assumingMemoryBound(to: UInt8.self), count: byteRange.length)
                    let chunk = DispatchData(bytesNoCopy: buffer, deallocator: .custom(nil, innerData.release))
                    append(chunk)
                }
            }
        }
        
    }
    
#endif

class DispatchData_VC: UIViewController {
    var indexPath = IndexPath()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "DispatchData_VC"
        self.view.backgroundColor = UIColor.white
        Create_data_t()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func Create_data_t()
    {
        /* 转化成bytes */
        let nsData1 = "Hello,".data(using: .utf8)
        let nsData2 = "world!".data(using: .utf8)
        
        /* 转化成DispatchData */
        var dData = DispatchData(referencing: nsData1!)
        let dData2 = DispatchData(referencing: nsData2!)
        
        /* 将两个DispatchData拼接 */
        dData.append(dData2)
        
        print("dData.count:\(dData.count)")/* 12个字节 */
        
        /* 遍历dData */

        
        
        let combinedNsData = Data(referencing: dData) /* 12个字节 */
        print(type(of: combinedNsData as NSData)) /* 打印对象的类型 */
    }
}
