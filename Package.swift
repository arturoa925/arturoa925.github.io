// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "Portfolio",
    platforms: [.macOS(.v13)],
    dependencies: [
        // Pinned to a known-good revision so an Ignite API change can't break the build.
        .package(url: "https://github.com/twostraws/Ignite.git", revision: "f97f33c734b3eb1862d5dc92b4a9c913cf24e3b5")
    ],
    targets: [
        .executableTarget(
            name: "Portfolio",
            dependencies: ["Ignite"],
            path: "Sources"
        )
    ]
)
