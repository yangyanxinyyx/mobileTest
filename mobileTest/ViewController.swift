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
        let openButton = UIButton()
        openButton.frame = CGRect(x: 300, y: 50, width: 44, height: 44)
        openButton.setTitle("open", for: .normal)
        openButton.setTitleColor(.blue, for: .normal)
        openButton.addTarget(self, action: #selector(openBookingVC), for: .touchUpInside)
        view.addSubview(openButton)
    }

    @objc func openBookingVC() {
        print("即将进入测试数据页面")
        let bookingVC = MTBookingViewController()
        self.present(bookingVC, animated: true, completion: nil)
    }
}

