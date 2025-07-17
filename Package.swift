// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftMpg123",
    platforms: [
        .macOS(.v12),
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "SwiftMpg123",
            targets: ["SwiftMpg123"]
        ),
        .executable(
            name: "MP3PlayerDemo",
            targets: ["MP3PlayerDemo"]
        ),
    ],
    targets: [
        .systemLibrary(
            name: "mpg123",
            pkgConfig: "libmpg123",
            providers: [
                .brew(["mpg123"]),
            ]
        ),
        .target(
            name: "SwiftMpg123",
            dependencies: ["mpg123"],
            linkerSettings: [
                .linkedLibrary("mpg123"),
            ]
        ),
        .executableTarget(
            name: "MP3PlayerDemo",
            dependencies: ["SwiftMpg123"],
            path: "Sources/MP3PlayerDemo"
        ),
        .testTarget(
            name: "SwiftMpg123Tests",
            dependencies: ["SwiftMpg123"]
        ),
    ]
)
