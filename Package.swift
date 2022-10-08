// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "UnicodeNames",
    platforms: [
            .macOS(.v10_15),
        ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "UnicodeNames",
            targets: ["UnicodeNames"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        
        .package(
          url: "https://github.com/apple/swift-collections.git",
          .upToNextMajor(from: "1.0.0") // or `.upToNextMinor
        )
    ],
    targets: [
        .target(
            name: "UnicodeNames",
            dependencies: [
                .product(name: "Collections", package: "swift-collections")
            ],
            resources: [
                .copy("UnicodeData")
            ]
            
        ),
        .testTarget(
            name: "UnicodeNamesTests",
            dependencies: ["UnicodeNames"]),
    ]
)
