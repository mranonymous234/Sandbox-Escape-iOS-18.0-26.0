// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "ExploitApp",
    platforms: [.iOS(.v17)], // Compatible with your iOS 18.2
    products: [.executable(name: "ExploitApp", targets: ["ExploitApp"])],
    targets: [
        .executableTarget(
            name: "ExploitApp",
            path: "Sources"
        )
    ]
)
