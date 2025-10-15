// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "hyperliquidExchange",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "hyperliquidExchange",
            targets: ["hyperliquidExchange"]),
    ],
    dependencies: [
        .package(url: "https://github.com/mathwallet/web3swift", from: "3.5.3"),
        .package(url: "https://github.com/Alamofire/Alamofire.git", from: "5.9.1"),
        .package(url: "https://github.com/lishuailibertine/Blake2.swift", from: "0.1.3"),
        .package(url: "https://github.com/nnabeyang/swift-msgpack.git", exact: "0.7.0"),
        .package(url: "https://github.com/kishikawakatsumi/KeychainAccess", from: "4.2.2")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "hyperliquidExchange",
            dependencies: [
                "web3swift",
                "Alamofire",
                .product(name: "Blake2", package: "Blake2.swift"),
                "KeychainAccess",
                .product(name: "SwiftMsgpack", package: "swift-msgpack")
            ]
        ),
        .testTarget(
            name: "hyperliquidExchangeTests",
            dependencies: ["hyperliquidExchange"]
        ),
    ]
)
