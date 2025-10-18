//
//  ViewController.swift
//  mobileTest
//
//  Created by 杨焱鑫 on 2025/10/18.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        initViews()
    }

    func initViews() {
        view.backgroundColor = .white

        let btn = UIButton()
        btn.frame = CGRectMake(300, 50, 44, 44)
        btn.setTitle("open", for: .normal)
        btn.setTitleColor(.blue, for: .normal)
        btn.addTarget(self, action: #selector(pressToOpenBookingVC), for: .touchUpInside)
        view.addSubview(btn)
    }

    @objc func pressToOpenBookingVC() {
        print("即将进入测试数据页面")
        let vc = MTBookingViewController()
        self.present(vc, animated: true, completion: nil)
    }
}

