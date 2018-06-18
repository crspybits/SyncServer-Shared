import PackageDescription

// When used with the server, this needs to be built with the flag -DSERVER

let package = Package(
    name: "SyncServer_Shared",
    dependencies: [
        // .Package(url: "https://github.com/hkellaway/Gloss.git", majorVersion: 1, minor: 2),
    	.Package(url: "https://github.com/crspybits/Gloss.git", majorVersion: 1, minor: 2),
        .Package(url: "https://github.com/IBM-Swift/Kitura.git", majorVersion: 2, minor: 4),
        
        // Not yet updating to the current version of Perfect, because it looks like it isn't compatible with the current version of Kitura. See https://github.com/PerfectlySoft/Perfect-MySQL/issues/27
        .Package(url: "https://github.com/PerfectlySoft/Perfect.git", majorVersion: 3, minor: 1)
        // .Package(url: "https://github.com/PerfectlySoft/Perfect.git", majorVersion: 2, minor: 0)
    ]
)
