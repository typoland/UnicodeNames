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
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "UnicodeNames",
            dependencies: [
                .product(name: "Collections", package: "swift-collections")
            ]),
        .testTarget(
            name: "UnicodeNamesTests",
            dependencies: ["UnicodeNames"]),
        
        .target(
            name: "flatUnicode.txt",
            dependencies: ["UnicodeNames"]),
        
        // Define the target for the package.
        .target(
            name: "glyphNamesToUnicodeAndCategories.txt",
            dependencies: ["UnicodeNames"]),
        
    ]
)
