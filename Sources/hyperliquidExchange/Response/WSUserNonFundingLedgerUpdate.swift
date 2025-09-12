//
//  ExchangeWSUserNonFundingLedgerUpdate.swift
//  hyperliquidExchange
//
//  Created by li shuai on 2025/9/4.
//

import Foundation

public struct WsUserNonFundingLedgerUpdateResponse: Decodable {
    public let isSnapshot: Bool
    public let user: String
    public let nonFundingLedgerUpdates: [WsUserNonFundingLedgerUpdate]
}
// MARK: - WsUserNonFundingLedgerUpdate
public struct WsUserNonFundingLedgerUpdate: Decodable {
    public let time: Int
    public let hash: String
    public let delta: ExchangeWsLedgerUpdate
}

// MARK: - WsLedgerUpdate (union type)
public enum ExchangeWsLedgerUpdate: Decodable {
    case deposit(ExchangeWsDeposit)
    case withdraw(ExchangeWsWithdraw)
    case internalTransfer(ExchangeWsInternalTransfer)
    case subAccountTransfer(ExchangeWsSubAccountTransfer)
    case liquidation(ExchangeWsLedgerLiquidation)
    case vaultDelta(ExchangeWsVaultDelta)
    case vaultWithdraw(ExchangeWsVaultWithdrawal)
    case vaultLeaderCommission(ExchangeWsVaultLeaderCommission)
    case spotTransfer(ExchangeWsSpotTransfer)
    case accountClassTransfer(ExchangeWsAccountClassTransfer)
    case spotGenesis(ExchangeWsSpotGenesis)
    case rewardsClaim(ExchangeWsRewardsClaim)

    private enum CodingKeys: String, CodingKey {
        case type
    }

    // 解码
   public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(String.self, forKey: .type)
        let singleValue = try decoder.singleValueContainer()

        switch type {
        case "deposit":
            self = .deposit(try singleValue.decode(ExchangeWsDeposit.self))
        case "withdraw":
            self = .withdraw(try singleValue.decode(ExchangeWsWithdraw.self))
        case "internalTransfer":
            self = .internalTransfer(try singleValue.decode(ExchangeWsInternalTransfer.self))
        case "subAccountTransfer":
            self = .subAccountTransfer(try singleValue.decode(ExchangeWsSubAccountTransfer.self))
        case "liquidation":
            self = .liquidation(try singleValue.decode(ExchangeWsLedgerLiquidation.self))
        case "vaultCreate", "vaultDeposit", "vaultDistribution":
            self = .vaultDelta(try singleValue.decode(ExchangeWsVaultDelta.self))
        case "vaultWithdraw":
            self = .vaultWithdraw(try singleValue.decode(ExchangeWsVaultWithdrawal.self))
        case "vaultLeaderCommission":
            self = .vaultLeaderCommission(try singleValue.decode(ExchangeWsVaultLeaderCommission.self))
        case "spotTransfer":
            self = .spotTransfer(try singleValue.decode(ExchangeWsSpotTransfer.self))
        case "accountClassTransfer":
            self = .accountClassTransfer(try singleValue.decode(ExchangeWsAccountClassTransfer.self))
        case "spotGenesis":
            self = .spotGenesis(try singleValue.decode(ExchangeWsSpotGenesis.self))
        case "rewardsClaim":
            self = .rewardsClaim(try singleValue.decode(ExchangeWsRewardsClaim.self))
        default:
            throw DecodingError.dataCorruptedError(forKey: .type, in: container, debugDescription: "Unknown type: \(type)")
        }
    }
}

// MARK: - Models

public struct ExchangeWsDeposit: Codable {
    public let type: String // "deposit"
    public let usdc: String
}

public struct ExchangeWsWithdraw: Codable {
    public let type: String // "withdraw"
    public let usdc: String
    public let nonce: Int
    public let fee: String
}

public struct ExchangeWsInternalTransfer: Codable {
    public let type: String // "internalTransfer"
    public let usdc: String
    public let user: String
    public let destination: String
    public let fee: String
}

public struct ExchangeWsSubAccountTransfer: Codable {
    public let type: String // "subAccountTransfer"
    public let usdc: String
    public let user: String
    public let destination: String
}

public struct ExchangeWsLedgerLiquidation: Codable {
    public let type: String // "liquidation"
    public let accountValue: String
    public let leverageType: String // "Cross" | "Isolated"
    public let liquidatedPositions: [ExchangeLiquidatedPosition]
}

public struct ExchangeLiquidatedPosition: Codable {
    public let coin: String
    public let szi: String
}

public struct ExchangeWsVaultDelta: Codable {
    public let type: String // "vaultCreate" | "vaultDeposit" | "vaultDistribution"
    public let vault: String
    public let usdc: String
}

public struct ExchangeWsVaultWithdrawal: Codable {
    public let type: String // "vaultWithdraw"
    public let vault: String
    public let user: String
    public let requestedUsd: String
    public let commission: String
    public let closingCost: String
    public let basis: String
    public let netWithdrawnUsd: Double
}

public struct ExchangeWsVaultLeaderCommission: Codable {
    public let type: String // "vaultLeaderCommission"
    public let user: String
    public let usdc: String
}

public struct ExchangeWsSpotTransfer: Codable {
    public let type: String // "spotTransfer"
    public let token: String
    public let amount: String
    public let usdcValue: String
    public let user: String
    public let destination: String
    public let fee: String
}

public struct ExchangeWsAccountClassTransfer: Codable {
    public let type: String // "accountClassTransfer"
    public let usdc: String
    public let toPerp: Bool
}

public struct ExchangeWsSpotGenesis: Codable {
    public let type: String // "spotGenesis"
    public let token: String
    public let amount: String
}

public struct ExchangeWsRewardsClaim: Codable {
    public let type: String // "rewardsClaim"
    public let amount: String
}
