//
//  WSUserFills.swift
//  hyperliquidExchange
//
//  Created by li shuai on 2025/9/4.
//
import Foundation

// MARK: - WsUserFills
struct WsUserFillsResponse: Codable {
    let isSnapshot: Bool?
    let user: String
    let fills: [WsFill]
}

// MARK: - WsFill
struct WsFill: Codable {
    let coin: String
    let px: String        // price
    let sz: String        // size
    let side: String
    let time: Int
    let startPosition: String
    let dir: String       // frontend display direction
    let closedPnl: String
    let hash: String      // L1 transaction hash
    let oid: Int          // order id
    let crossed: Bool     // taker flag
    let fee: String       // negative means rebate
    let tid: Int          // unique trade id
    let liquidation: FillLiquidation?
    let feeToken: String  // fee token
    let builderFee: String?

    enum CodingKeys: String, CodingKey {
        case coin, px, sz, side, time, startPosition, dir, closedPnl, hash, oid, crossed, fee, tid, liquidation, feeToken, builderFee
    }
}

// MARK: - FillLiquidation
struct FillLiquidation: Codable {
    let liquidatedUser: String?
    let markPx: Double
    let method: String    // "market" | "backstop"
}
