//
//  ExchangeFees.swift
//  hyperliquidExchange
//
//  Created by li shuai on 2025/8/18.
//

import Foundation

// MARK: - Root Model
public struct ExchangeUserFeeData: Codable {
    public let dailyUserVlm: [ExchangeDailyUserVolume]
    public let feeSchedule: ExchangeFeeSchedule
    public let userCrossRate: String
    public let userAddRate: String
    public let userSpotCrossRate: String
    public let userSpotAddRate: String
    public let activeReferralDiscount: String
    public let trial: String?
    public let feeTrialReward: String
    public let nextTrialAvailableTimestamp: String?
    public let stakingLink: String?
    public let activeStakingDiscount: ExchangeStakingDiscount
}

// MARK: - Daily User Volume
public struct ExchangeDailyUserVolume: Codable {
    public let date: String
    public let userCross: String
    public let userAdd: String
    public let exchange: String
}

// MARK: - Fee Schedule
public struct ExchangeFeeSchedule: Codable {
    public let cross: String
    public let add: String
    public let spotCross: String
    public let spotAdd: String
    public let tiers: ExchangeFeeTiers
    public let referralDiscount: String
    public let stakingDiscountTiers: [ExchangeStakingDiscount]
}

// MARK: - Fee Tiers
public struct ExchangeFeeTiers: Codable {
    public let vip: [ExchangeVIPTier]
    public let mm: [ExchangeMMTier]
}

// MARK: - VIP Tier
public struct ExchangeVIPTier: Codable {
    public let ntlCutoff: String
    public  let cross: String
    public let add: String
    public let spotCross: String
    public  let spotAdd: String
}

// MARK: - Market Maker Tier
public struct ExchangeMMTier: Codable {
    public let makerFractionCutoff: String
    public let add: String
}

// MARK: - Staking Discount Tier
public struct ExchangeStakingDiscount: Codable {
    public let bpsOfMaxSupply: String
    public let discount: String
}
