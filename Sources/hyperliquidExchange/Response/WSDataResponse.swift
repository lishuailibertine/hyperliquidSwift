//
//  WSDataResponse.swift
//  hyperliquidExchange
//
//  Created by li shuai on 2025/8/13.
//
import Foundation
public struct ExchangeActiveAssetCtx: Decodable {
    /// Funding费率（融资费率），通常用于永续合约的资金费率计算
    public var funding: String
    
    /// 持仓量（Open Interest），表示当前市场上该合约的未平仓合约数量
    public var openInterest: String
    
    /// 昨日收盘价（Previous Day Price）
    public var prevDayPx: String
    
    /// 当天净交易量（Day Net Volume），通常以合约或代币计量
    public var dayNtlVlm: String
    
    /// 永续合约溢价（Premium），即合约价格相对于标的资产价格的溢价
    public var premium: String
    
    /// Oracle价格（Oracle Price），来自预言机的参考价格
    public var oraclePx: String
    
    /// 标记价格（Mark Price），用于避免市场操纵触发强平
    public var markPx: String
    
    /// 中间价格（Mid Price），通常为买卖价中间值
    public var midPx: String
    
    /// 影响价格列表（Impact Prices），通常表示根据不同交易量计算的价格影响值
    public var impactPxs: [String]
    
    /// 当天基础交易量（Day Base Volume），通常是基础资产的成交量
    public var dayBaseVlm: String
}

public struct ExchangeActiveAssetCtxResponse: Decodable{
    public var coin: String
    public var ctx: ExchangeActiveAssetCtx
}

public struct ExchangeWSResponse<T: Decodable>: Decodable{
    public var channel: HyperliquidSubscriptionType
    public var data: T
}
