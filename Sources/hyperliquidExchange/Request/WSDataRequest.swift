//
//  ExchangeWebData.swift
//  hyperliquidExchange
//
//  Created by li shuai on 2025/7/31.
//
public protocol ExchangeWSRequest: ExchangeEncodePayload{
    var type: HyperliquidSubscriptionType { get }
}
public struct ExchangeActiveAssetCtxRequest: ExchangeWSRequest, Encodable {
    public var type: HyperliquidSubscriptionType
    public var coin: String
    public init(type: HyperliquidSubscriptionType = .activeAssetCtx, coin: String) {
        self.type = type
        self.coin = coin
    }
}

public struct UserNonFundingLedgerUpdatesRequest: ExchangeWSRequest, Encodable {
    public var type: HyperliquidSubscriptionType
    public var user: String
    public init(type: HyperliquidSubscriptionType = .userNonFundingLedgerUpdates, user: String) {
        self.type = type
        self.user = user
    }
}

public struct WsUserFillsRequest: ExchangeWSRequest, Encodable {
    public var type: HyperliquidSubscriptionType
    public var user: String
    public init(type: HyperliquidSubscriptionType = .userFills, user: String) {
        self.type = type
        self.user = user
    }
}
