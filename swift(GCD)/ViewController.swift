//
//  ViewController.swift
//  swift(GCD)
//
//  Created by 范云飞 on 2017/8/21.
//  Copyright © 2017年 范云飞. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource
{
    
    var dataSource = [[String()]]
    var titleArr = [String]()
    
    var classArray = [UIViewController]()
    

    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.title = "swift(GCD)"
        self.view.backgroundColor = UIColor.white
        setUp()
        setData()
    }
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:初始化控件
    func setUp() {
        self.view.addSubview(self.tableView)
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
    }
    
    //MARK:初始化数据
    func setData() {
        self.titleArr =   ["DispatchQueue",
                           "DispatchGroup",
                           "DispatchSemaphore",
                           "DispatchSource",
                           "DispatchTime",
                           "DispatchBlock",
                           "DispatchOnce",
                           "DispatchData",
                           "DispatchIO",
                           "DispatchObject",
                           "DispatchWalltime",
                          ]
        self.dataSource = [["异步+并行",
                            "异步+串行",
                            "同步+并行",
                            "同步+串行",
                            "全局队列",
                            "主队列",
                            "延时提交",
                            "代码块"
                            ],
                           ["多组网络并发请求"
                            ],
                           ["解决资源竞争的例子(可变数组添加数据)",
                            "车子占位的问题",
                            "控制并发数"
                            ],
                           ["定时器(和runloop结合)",
                            "文件读取",
                            "文件写数据",
                            "文件监听",
                            "自定义事件",
                            "监听进程",
                            "监听信号"
                            ],
                           ["创建定时器"
                            ],
                           ["简单应用"
                            ],
                           ["代码只执行一次",
                            "单例"
                            ],
                           ["data操作的简单例子"
                            ],
                           ["I/O读数据",
                            "I/O写数据",
                            "I/O操作中的高低水位与周期性回调"
                            ],
                           ["object操作"
                            ],
                           []
                          ];

    }
    
    //MARK:tableView 的代理方法
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return self.titleArr.count;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.dataSource[section].count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        cell.textLabel?.text = self.dataSource[indexPath.section][indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 44
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        return self.titleArr[section];
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if indexPath.section == 0
        {
            let object_VC = DispatchQueue_VC()
            object_VC.indexPath = indexPath
            self.navigationController?.pushViewController(object_VC, animated: true)
        }
        if indexPath.section == 1
        {
            let object_VC = DispatchGroup_VC()
            object_VC.indexPath = indexPath
            self.navigationController?.pushViewController(object_VC, animated: true)
        }
        if indexPath.section == 2
        {
            let object_VC = DispatchSemaphore_VC()
            object_VC.indexPath = indexPath
            self.navigationController?.pushViewController(object_VC, animated: true)
        }
        if indexPath.section == 3
        {
            let object_VC = DispatchSource_VC()
            object_VC.indexPath = indexPath
            self.navigationController?.pushViewController(object_VC, animated: true)
        }
        if indexPath.section == 4
        {
            let object_VC = DispatchTime_VC()
            object_VC.indexPath = indexPath
            self.navigationController?.pushViewController(object_VC, animated: true)
        }
        if indexPath.section == 5
        {
            let object_VC = DispatchBlock_VC()
            object_VC.indexPath = indexPath
            self.navigationController?.pushViewController(object_VC, animated: true)
        }
        if indexPath.section == 6
        {
            let object_VC = DispatchOnce_VC()
            object_VC.indexPath = indexPath
            self.navigationController?.pushViewController(object_VC, animated: true)
        }
        if indexPath.section == 7
        {
            let object_VC = DispatchData_VC()
            object_VC.indexPath = indexPath
            self.navigationController?.pushViewController(object_VC, animated: true)
        }
        if indexPath.section == 8
        {
            let object_VC = DispatchIO_VC()
            object_VC.indexPath = indexPath
            self.navigationController?.pushViewController(object_VC, animated: true)
        }
        if indexPath.section == 9
        {
            let object_VC = DispatchObject_VC()
            object_VC.indexPath = indexPath
            self.navigationController?.pushViewController(object_VC, animated: true)
        }
        if indexPath.section == 10
        {
            let object_VC = DispatchWalltime_VC()
            object_VC.indexPath = indexPath
            self.navigationController?.pushViewController(object_VC, animated: true)
        }
    }
    
    //MARK:tableView 懒加载
    lazy var tableView: UITableView =
        {
        let tableView = UITableView(frame: self.view.frame, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()

}

