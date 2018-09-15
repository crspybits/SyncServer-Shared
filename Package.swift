// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "SyncServerShared",
    products: [
        .library(name: "SyncServerShared", targets: ["SyncServerShared"]),
    ],
    dependencies: [
        // .Package(url: "https://github.com/hkellaway/Gloss.git", majorVersion: 1, minor: 2),
        .package(url: "https://github.com/crspybits/Gloss.git", from: "1.2.0"),
        .package(url: "https://github.com/IBM-Swift/Kitura.git", from: "2.4.0"),
        .package(url: "https://github.com/PerfectlySoft/Perfect.git", from: "3.1.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "SyncServerShared",
            dependencies: ["PerfectLib", "Kitura", "Gloss"],
            path: "Sources/SyncServerShared"
        ),
    ]
)
