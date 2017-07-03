import PackageDescription

// When used with the server, this needs to be built with the flag -DSERVER

let package = Package(
    name: "SyncServer_Shared",
    dependencies: [
    	.Package(url: "https://github.com/crspybits/Gloss.git", majorVersion: 1, minor: 2),
        .Package(url: "https://github.com/IBM-Swift/Kitura.git", majorVersion: 1, minor: 7),
        .Package(url: "https://github.com/PerfectlySoft/Perfect.git", majorVersion: 2, minor: 0)
    ]
)
