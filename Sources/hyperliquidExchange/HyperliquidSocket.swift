//
//  HyperliquidSocket.swift
//  hyperliquidExchange
//
//  Created by li shuai on 2025/7/31.
//
import Foundation
import Starscream

public enum HyperliquidSubscriptionType: String, Codable {
    case activeAssetCtx
    case userNonFundingLedgerUpdates
    case userFills
    case error
}

public class HyperliquidSocket: WebSocketDelegate {
    public var socket: WebSocket!
    public var isConnected = false
    private var subscriptions: [String: (Any) -> Void] = [:]
    private var pendingSubscriptions: [[String: Any]] = []
    private var pingTimer: Timer?
    private let pingInterval: TimeInterval = 20.0
    
    public init(url: String = "wss://api.hyperliquid.xyz/ws") {
        var request = URLRequest(url: URL(string: url)!)
        request.timeoutInterval = 5
        self.socket = WebSocket(request: request)
        self.socket.delegate = self
        self.socket.connect()
    }
    
    public func subscribe<T: Decodable>( subscription: ExchangeWSRequest, once: Bool = false, callback: @escaping (_ response: T) -> Void ) throws {
        let key = subscription.type.rawValue
        subscriptions[key] = { [weak self] payload in
            if let jsonData = payload as? Data, let decoded = try? JSONDecoder().decode(ExchangeWSResponse<T>.self, from: jsonData) {
                callback(decoded.data)
                if once { try? self?.unsubscribe(subscription: subscription) }
            }
        }
        let message: [String: Any] = [
            "method": "subscribe",
            "subscription": try subscription.payload()
        ]
        if isConnected {
            send(message)
        } else {
            pendingSubscriptions.append(message)
        }
    }
    
    /// 取消订阅
    public func unsubscribe(subscription: ExchangeWSRequest) throws {
        let message: [String: Any] = [
            "method": "unsubscribe",
            "subscription": try subscription.payload()
        ]
        send(message)
        subscriptions.removeValue(forKey: subscription.type.rawValue)
    }
    
    // MARK: - WebSocketDelegate
    
    public func didReceive(event: WebSocketEvent, client: WebSocketClient) {
        switch event {
        case .connected:
            isConnected = true
            startPing()
            pendingSubscriptions.forEach { send($0) }
            pendingSubscriptions.removeAll()
        case .disconnected:
            isConnected = false
            stopPing()
            reconnect()
        case .cancelled:
            isConnected = false
            stopPing()
        case .text(let string):
            handleTextMessage(string)
        case .error(let error):
            isConnected = false
            stopPing()
            if let e = error {
                handleError(e)
            }
            reconnect()
        default:
            break
        }
    }
    
    // MARK: - Private
    private func send(_ json: [String: Any]) {
        guard let data = try? JSONSerialization.data(withJSONObject: json),
              let text = String(data: data, encoding: .utf8) else {
            return
        }
        socket.write(string: text)
    }
    
    private func handleTextMessage(_ string: String) {
        guard let data = string.data(using: .utf8) else { return }
        guard let baseJson = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let channelString = baseJson["channel"] as? String,
              let type = HyperliquidSubscriptionType(rawValue: channelString) else {
            return
        }
        guard let handler = subscriptions[type.rawValue] else { return }
        if let jsonData = try? JSONSerialization.data(withJSONObject: baseJson) {
            handler(jsonData)
        }
    }
    
    private func handleError(_ error: Error) {
        if let e = error as? WSError {
            debugPrint("WebSocket error: \(e.message)")
        } else {
            debugPrint("WebSocket error: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Ping / Reconnect
    
    private func startPing() {
        stopPing()
        pingTimer = Timer.scheduledTimer(withTimeInterval: pingInterval, repeats: true) { [weak self] _ in
            guard let self = self, self.isConnected else { return }
            self.socket.write(ping: Data()) {
                debugPrint("📡 Ping sent")
            }
        }
    }
    
    private func stopPing() {
        pingTimer?.invalidate()
        pingTimer = nil
    }
    
    private func reconnect() {
        guard !isConnected else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.socket.connect()
        }
    }
}
