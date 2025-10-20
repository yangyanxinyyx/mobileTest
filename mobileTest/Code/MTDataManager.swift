//
//  MTDataManager.swift
//  mobileTest
//
//  Created by 杨焱鑫 on 2025/10/18.
//

import Foundation
class MTDataManager : NSObject{
    private var viewModel: MTBookingModel? = nil
    private let service = MTBookingService()
    private let cache = MTBookingCache.shared

    func loadData(_ completion: ((_ bookingModel: MTBookingModel) -> Void)?) {
        let currentTime = Int(Date().timeIntervalSince1970)
        let currentDateString = self.changeTimestampToTime(currentTime)
        print("当前时间: \(currentDateString)")

        if let viewModel = viewModel,
           let expiryTime = Int(viewModel.expiryTime),
           expiryTime > currentTime {

            print("内存缓存在有效期内 使用内存缓存")
            completion?(viewModel)

        } else if let cachedBookings = cache.getValidBookings(),
                  let expiryTime = Int(cachedBookings.expiryTime),
                  expiryTime > currentTime {

            print("磁盘缓存在有效期内 使用磁盘缓存")
            viewModel = cachedBookings
            completion?(cachedBookings)

        } else {

            print("没有在有效期内的缓存 请求新的数据")
            service.fetchBookings { [weak self] result in
                switch result {
                case .success(let response):
                    guard let self = self else { return }
                    self.viewModel = response
                    //有效期15秒
                    let newExpiryTime = Int(Date().timeIntervalSince1970) + 15
                    guard let viewModel = self.viewModel else { return }
                    viewModel.expiryTime = String(newExpiryTime)
                    self.cache.save(bookings: viewModel)
                    let dateString = self.changeTimestampToTime(newExpiryTime)
                    print("获取新数据成功 记录新有效期: \(dateString)")
                    completion?(response)
                case .failure(let error):
                    print("请求数据失败: \(error.localizedDescription)")
                }
            }
        }
    }

    func changeTimestampToTime(_ timestamp: Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        // 使用当前地区（避免时区问题）
        formatter.locale = Locale.current
        // 使用当前时区
        formatter.timeZone = TimeZone.current
        return formatter.string(from: date)
    }

    ///点击清除内存缓存 用于使用磁盘缓存
    func clearCache()  {
        viewModel = nil
    }
}


class MTBookingCache {
    static let shared = MTBookingCache()
    //使用沙盒目录cache文件夹
    private let fileManager = FileManager.default

    private var cacheFilePath: URL? {
        guard let cacheDir = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            return nil
        }
        return cacheDir.appendingPathComponent("booking_cache.json")
    }

    func save(bookings: MTBookingModel) {
        guard let filePath = cacheFilePath else {
            print("缓存路径无效")
            return
        }
        do {
            let data = try JSONEncoder().encode(bookings)
            try data.write(to: filePath)
        } catch {
            print("缓存保存失败: \(error)")
        }
    }

    func getValidBookings() -> MTBookingModel? {
        guard let filePath = cacheFilePath,
              fileManager.fileExists(atPath: filePath.path) else {
            return nil
        }
        do {
            let data = try Data(contentsOf: filePath)
            return try JSONDecoder().decode(MTBookingModel.self, from: data)
        } catch {
            print("缓存解析失败: \(error)")
            return nil
        }
    }

    func clear() {
        guard let filePath = cacheFilePath,
              fileManager.fileExists(atPath: filePath.path) else {
            return
        }
        do {
            try fileManager.removeItem(at: filePath)
            print("清除磁盘缓存")
        } catch {
            print("缓存清除失败: \(error)")
        }
    }
}

class MTBookingService {
    func fetchBookings(completion: @escaping (Result<MTBookingModel, Error>) -> Void) {
        guard let path = Bundle.main.path(forResource: "booking", ofType: "json"),
              let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
            let error = NSError(domain: "BookingService", code: -1, userInfo: [NSLocalizedDescriptionKey: "JSON文件不存在"])
            completion(.failure(error))
            return
        }

        do {
            let response = try JSONDecoder().decode(MTBookingModel.self, from: data)
            completion(.success(response))
        } catch {
            let error = NSError(domain: "BookingService", code: -2, userInfo: [NSLocalizedDescriptionKey: "JSON文件解析失败"])
            completion(.failure(error))
        }
    }
}

