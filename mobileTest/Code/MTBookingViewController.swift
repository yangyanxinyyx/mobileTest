//
//  MTBookingViewController.swift
//  mobileTest
//
//  Created by 杨焱鑫 on 2025/10/18.
//

import UIKit

class MTBookingViewController: UIViewController {

    private let tableView = UITableView()
    private let modelManager:MTDataManager = MTDataManager()
    private var viewModel:MTBookingModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initData()
    }

    func initViews() {
        view.backgroundColor = .white

        let backButton = UIButton()
        backButton.frame = CGRect(x: 10, y: 50, width: 44, height: 44)
        backButton.setTitle("back", for: .normal)
        backButton.setTitleColor(.blue, for: .normal)
        backButton.addTarget(self, action: #selector(backToHome), for: .touchUpInside)
        view.addSubview(backButton)

        tableView.frame = CGRect(x: 0, y: 100, width: 300, height: 200)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        view.addSubview(tableView)

        let refreshButton = UIButton()
        refreshButton.frame = CGRect(x: 100, y: 50, width: 64, height: 44)
        refreshButton.setTitle("refresh", for: .normal)
        refreshButton.setTitleColor(.blue, for: .normal)
        refreshButton.addTarget(self, action: #selector(refreshData), for: .touchUpInside)
        view.addSubview(refreshButton)

        //清除内存缓存按钮
        let clearCacheButton = UIButton()
        clearCacheButton.frame = CGRect(x: 200, y: 50, width: 100, height: 44)
        clearCacheButton.setTitle("clearCache", for: .normal)
        clearCacheButton.setTitleColor(.blue, for: .normal)
        clearCacheButton.addTarget(self, action: #selector(clearMemoryCache), for: .touchUpInside)
        view.addSubview(clearCacheButton)
    }

    func initData()  {
        print("初始化数据")
        modelManager.loadData {[weak self] bookingModel in
            self?.viewModel = bookingModel
            self?.tableView.reloadData()
        }
    }

    @objc func backToHome() {
        print("返回首页")
        self.dismiss(animated: true)
    }

    @objc func refreshData() {
        print("点击刷新数据")
        modelManager.loadData {[weak self] bookingModel in
            self?.viewModel = bookingModel
            self?.tableView.reloadData()
            print("刷新数据列表")
        }
    }

    ///点击清除内存缓存 用于使用磁盘缓存
    @objc func clearMemoryCache() {
        print("点击清除内存缓存数据")
        modelManager.clearCache()
    }
}

extension MTBookingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.segments.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if let viewModel = viewModel {
            let segment = viewModel.segments[indexPath.row]
            cell.textLabel?.text = segment.originAndDestinationPair.originCity + " to " + segment.originAndDestinationPair.destinationCity
            print("\(segment)")
        }
        return cell
    }
}
