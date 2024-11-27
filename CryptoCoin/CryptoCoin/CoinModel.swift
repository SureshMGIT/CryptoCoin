//
//  CoinModel.swift
//  CryptoCoin
//
//  Created by Suresh M on 26/11/24.
//

import Foundation

struct CoinModel: Codable {
    let name, symbol: String
    let isNew, isActive: Bool
    let type: CoinType

    enum CodingKeys: String, CodingKey {
        case name, symbol
        case isNew = "is_new"
        case isActive = "is_active"
        case type
    }
}

enum CoinType: String, Codable {
    case coin = "coin"
    case token = "token"
}
