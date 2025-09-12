//
//  ExchangeResponse.swift
//  hyperliquidExchange
//
//  Created by li shuai on 2025/7/28.
//
public enum ExchangeResponseError: Error {
    case InvalidResponse
    case Other(String)
}

public struct ExchangeResponseStatuses<T: Decodable>: Decodable{
    public var statuses: [T]
}
public struct ExchangeResponseResult<T: Decodable>: Decodable{
    public var type: String
    public var data: ExchangeResponseStatuses<T>?
}

public enum ExchangeResponseResultOrError<T: Decodable>: Decodable {
    case result(ExchangeResponseResult<T>)
    case errorMessage(String)
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let result = try? container.decode(ExchangeResponseResult<T>.self) {
            self = .result(result)
        } else if let message = try? container.decode(String.self) {
            self = .errorMessage(message)
        } else {
            throw DecodingError.typeMismatch(
                ExchangeResponseResultOrError.self,
                DecodingError.Context(
                    codingPath: decoder.codingPath,
                    debugDescription: "Expected either ExchangeResponseResult<T> or String"
                )
            )
        }
    }
}
public struct ExchangeResponse<T: Decodable>: Decodable{
    public var status: String
    public var response: ExchangeResponseResultOrError<T>
}
public struct ExchangeOrderErrorStatus: Decodable {
    public let error: String
}
// Order
public struct ExchangeOrderFilledStatus: Decodable {
    public let totalSz: String
    public let avgPx: String
    public let oid: Int
}

public struct ExchangeOrderRestingStatus: Decodable {
    public let oid: Int
}

public enum ExchangeOrderStatusItem: Decodable {
    case resting(ExchangeOrderRestingStatus)
    case filled(ExchangeOrderFilledStatus)
    case error(String)
    case success(String)
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let str = try? container.decode(String.self), str == "success" {
            self = .success(str)
            return
        }
        if let object = try? container.decode([String: ExchangeOrderRestingStatus].self),
           let value = object["resting"] {
            self = .resting(value)
            return
        }
        if let object = try? container.decode([String: ExchangeOrderFilledStatus].self),
           let value = object["filled"] {
            self = .filled(value)
            return
        }
        
        if let object = try? container.decode([String: String].self),
           let value = object["error"] {
            self = .error(value)
            return
        }
        throw DecodingError.dataCorruptedError(in: container, debugDescription: "Unknown status format")
    }
}
// Meta
public struct ExchangeMetaUniverse: Codable {
    public var szDecimals: String
    public var name: String
    public var maxLeverage: String
    public var marginTableId: String
    public var assetId: UInt16 = 0
    public var isDelisted: Bool?
    enum CodingKeys: String, CodingKey {
        case szDecimals
        case name
        case maxLeverage
        case marginTableId
        case isDelisted
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        func decodeStringOrInt(forKey key: CodingKeys) throws -> String {
            if let str = try? container.decode(String.self, forKey: key) {
                return str
            } else if let intVal = try? container.decode(Int.self, forKey: key) {
                return String(intVal)
            } else {
                return ""
            }
        }
        szDecimals = try decodeStringOrInt(forKey: .szDecimals)
        maxLeverage = try decodeStringOrInt(forKey: .maxLeverage)
        marginTableId = try decodeStringOrInt(forKey: .marginTableId)
        isDelisted = try container.decodeIfPresent(Bool.self, forKey: .isDelisted)
    }
}

public struct ExchangeMarginTier: Codable {
    public var lowerBound: String
    public var maxLeverage: Int
}

public struct ExchangeMarginTiers: Codable {
    private struct Detail: Codable {
        var marginTiers: [ExchangeMarginTier]
    }
    public var marginTableId: String
    public var marginTiers: [ExchangeMarginTier]
    public init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        func decodeStringOrInt() throws -> String {
            if let str = try? container.decode(String.self) {
                return str
            } else if let intVal = try? container.decode(Int.self) {
                return String(intVal)
            } else {
                return ""
            }
        }
        marginTableId = try decodeStringOrInt()
        let detail = try container.decode(Detail.self)
        marginTiers = detail.marginTiers
    }
    
    public init(marginTableId: String = "", marginTiers: [ExchangeMarginTier] = []) {
        self.marginTableId = marginTableId
        self.marginTiers = marginTiers
    }
}

public struct ExchangeMetaResponse: Codable {
    public var universe: [ExchangeMetaUniverse]
    public var marginTables: [ExchangeMarginTiers]
    public init(universe: [ExchangeMetaUniverse], marginTables: [ExchangeMarginTiers]) {
        self.universe = universe
        self.marginTables = marginTables
    }
}

public struct ExchangeSpotMetaUniverse: Decodable {
    public var tokens: [Int]
    public var name: String
    public var index: Int
    public var isCanonical: Bool
}

public struct ExchangeSpotTokenContract: Decodable {
    public var address: String
    public var evm_extra_wei_decimals: Int
}

public struct ExchangeSpotToken : Decodable {
    public var name: String
    public var szDecimals: Int
    public var weiDecimals: Int
    public var index: Int
    public var tokenId: String
    public var isCanonical: Bool
    public var evmContract: ExchangeSpotTokenContract?
    public var fullName: String?
    public var deployerTradingFeeShare: String
}

public struct ExchangeSpotMetaResponse: Decodable {
    public var universe: [ExchangeSpotMetaUniverse]
    public var tokens: [ExchangeSpotToken]
}
