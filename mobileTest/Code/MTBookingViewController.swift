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

        let backBtn = UIButton()
        backBtn.frame = CGRectMake(10, 50, 44, 44)
        backBtn.setTitle("back", for: .normal)
        backBtn.setTitleColor(.blue, for: .normal)
        backBtn.addTarget(self, action: #selector(backToHome), for: .touchUpInside)
        view.addSubview(backBtn)

        tableView.frame = CGRectMake(0, 100, 300, 200)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        view.addSubview(tableView)

        let refreshBtn = UIButton()
        refreshBtn.frame = CGRectMake(100, 50, 64, 44)
        refreshBtn.setTitle("refresh", for: .normal)
        refreshBtn.setTitleColor(.blue, for: .normal)
        refreshBtn.addTarget(self, action: #selector(refreshData), for: .touchUpInside)
        view.addSubview(refreshBtn)

        //清除内存缓存按钮
        let clearCacheBtn = UIButton()
        clearCacheBtn.frame = CGRectMake(200, 50, 100, 44)
        clearCacheBtn.setTitle("clearCache", for: .normal)
        clearCacheBtn.setTitleColor(.blue, for: .normal)
        clearCacheBtn.addTarget(self, action: #selector(clearMemoryCache), for: .touchUpInside)
        view.addSubview(clearCacheBtn)
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
