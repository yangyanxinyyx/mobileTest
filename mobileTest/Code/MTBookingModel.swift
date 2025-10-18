//
//  MTBookingModel.swift
//  mobileTest
//
//  Created by 杨焱鑫 on 2025/10/18.
//

import Foundation

class MTBookingModel: Codable {
    let shipReference: String
    let shipToken: String
    let canIssueTicketChecking: Bool
    var expiryTime: String  
    let duration: Int
    let segments: [Segment]
}

struct Segment: Codable {
    let id: Int
    let originAndDestinationPair: OriginDestinationPair
}

struct OriginDestinationPair: Codable {
    let destination: Destination
    let destinationCity: String
    let origin: Destination
    let originCity: String
}

struct Destination: Codable {
    let code: String
    let displayName: String
    let url: String
}
