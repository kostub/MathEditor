// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MathEditor",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "MathEditor",
            targets: ["MathEditor"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/chbeer/iosMath.git", from: "0.9.5"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "MathEditor",
            dependencies: [
                "iosMath"
            ],
            path: "mathEditor",
            resources: [
                .process("../MathKeyboardResources/KeyboardAssests.xcassets"),
                .process("../MathKeyboardResources/MTKeyboard.xib"),
                .process("../MathKeyboardResources/MTKeyboardTab2.xib"),
                .process("../MathKeyboardResources/MTKeyboardTab3.xib"),
                .process("../MathKeyboardResources/MTKeyboardTab4.xib"),
                .process("../MathKeyboardResources/MTMathKeyboardRootView.xib"),
                .process("../MathKeyboardResources/NewKeyboardAssets.xcassets"),
                .process("../MathKeyboardResources/WhiteBGKeyboardTab.xcassets"),
                .process("../MathKeyboardResources/lmroman10-bolditalic.otf"),
            ]
        ),
        .testTarget(
            name: "MathEditorTests",
            dependencies: ["MathEditor"],
            path: "Tests"
        ),
    ]
)
