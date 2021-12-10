// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "NotificationObserving",
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "NotificationObserving",
            targets: ["NotificationObserving"]),
    ],
    dependencies: [
        .package(
            name: "AssociatedValues",
            url: "https://github.com/EdgarDegas/AssociatedValues",
            .upToNextMajor(from: "0.0.1")
        ),
        .package(name: "Quick", url: "https://github.com/Quick/Quick", .upToNextMajor(from: "3.1.2")),
        .package(name: "Nimble", url: "https://github.com/Quick/Nimble", .upToNextMajor(from: "9.0.0")),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "NotificationObserving",
            dependencies: [
                .byName(name: "AssociatedValues")
            ]
        ),
        .testTarget(
            name: "NotificationObservingTests",
            dependencies: [
                "NotificationObserving",
                .byName(name: "Quick"),
                .byName(name: "Nimble"),
            ]),
    ]
)
