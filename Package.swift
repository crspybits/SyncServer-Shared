// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "SyncServer_Shared",
    products: [
        .library(name: "SyncServer_Shared", targets: ["SyncServer_Shared"]),
    ],
    dependencies: [
        // .Package(url: "https://github.com/hkellaway/Gloss.git", majorVersion: 1, minor: 2),
        .package(url: "https://github.com/crspybits/Gloss.git", from: "1.2.0"),
        .package(url: "https://github.com/IBM-Swift/Kitura.git", from: "2.4.0"),
        .package(url: "https://github.com/PerfectlySoft/Perfect.git", from: "3.1.0")
    ],
    targets: [
        .target(name: "SyncServer_Shared")
    ]
)
