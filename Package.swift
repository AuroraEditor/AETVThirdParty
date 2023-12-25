// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AETextViewThirdParty",
    platforms: [.macOS(.v12)],
    products: [
        .library(
            name: "AETextViewThirdParty",
            targets: ["AETextViewThirdParty"]),
    ],
    targets: [
        .target(
            name: "AETextViewThirdPartyInternal",
            publicHeadersPath: "."
        ),
        .target(
            name: "AETextViewThirdParty",
            dependencies: [
                "AETextViewThirdPartyInternal"
            ]),
    ]
)
