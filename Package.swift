// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import CompilerPluginSupport

let package = Package(
    name: "Actuator",
    platforms: [.macOS(.v12), .iOS(.v13), .tvOS(.v13), .watchOS(.v6), .macCatalyst(.v13)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "ActuatorMacros",
            targets: ["ActuatorMacros"]),
        .library(
            name: "Actuator",
            targets: ["Actuator"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/apple/swift-syntax.git", from: "509.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .macro(
            name: "ActuatorMacrosImplementation",
            dependencies: [
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax")
            ]),
        .target(
            name: "ActuatorMacros",
            dependencies: ["ActuatorMacrosImplementation"]),
        .target(
            name: "Actuator",
            dependencies: ["ActuatorMacros"]),
        .testTarget(
            name: "ActuatorTests",
            dependencies: ["Actuator"]),
    ]
)
