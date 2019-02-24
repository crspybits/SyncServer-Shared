// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "SyncServerShared",
    products: [
        .library(name: "SyncServerShared", targets: ["SyncServerShared"]),
    ],
    dependencies: [
        .package(url: "https://github.com/IBM-Swift/Kitura.git", from: "2.4.0"),
        .package(url: "https://github.com/PerfectlySoft/Perfect.git", from: "3.1.0")
    ],
    targets: [
        .target(
            name: "SyncServerShared",
            dependencies: ["PerfectLib", "Kitura"],
            path: "Sources/SyncServerShared"
        ),
    ]
)
