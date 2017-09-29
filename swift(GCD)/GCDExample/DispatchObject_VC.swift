//
//  DispatchObject.swift
//  swift(GCD)
//
//  Created by 范云飞 on 2017/8/30.
//  Copyright © 2017年 范云飞. All rights reserved.
//

import UIKit

class DispatchObject_VC: UIViewController {
    var indexPath = IndexPath()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "DispatchObject_VC"
        self.view.backgroundColor = UIColor.white
        if self.indexPath.row == 0 {
            Create_async_concurrent()
        }
    }
    
    func Create_async_concurrent() {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
