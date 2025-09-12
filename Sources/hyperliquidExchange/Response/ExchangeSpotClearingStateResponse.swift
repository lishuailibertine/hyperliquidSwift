//
//  ExchangeSpotClearingStateResponse.swift
//  hyperliquidExchange
//
//  Created by li shuai on 2025/9/1.
//
import Foundation
public struct ExchangeSpotBalanceModel: Decodable {
    public var coin: String
    public var token: Int
    public var total: String
    public var hold: String
    public var entryNtl: String
}

public struct ExchangeSpotClearingStateResponse: Decodable {
    public var balances: [ExchangeSpotBalanceModel]
}
