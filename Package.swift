import PackageDescription

let package = Package(
    name: "SyncServer_Shared",
    dependencies: [
    	.Package(url: "https://github.com/crspybits/Gloss.git", majorVersion: 1, minor: 2),
    ]
)