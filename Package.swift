// swift-tools-version: 5.6

import PackageDescription

let package = Package(
  name: "MathEditor",
  defaultLocalization: "en",
  platforms: [.iOS(.v13)],
  products: [
    .library(
      name: "MathEditor",
      targets: ["MathEditor"])
  ],
  dependencies: [
    .package(url: "https://github.com/maitbayev/iosMath.git", branch: "master")
  ],
  targets: [
    .target(
      name: "MathEditor",
      dependencies: [.product(name: "iosMath", package: "iosMath")],
      path: "./mathEditor",
      resources: [.process("MathKeyboardResources")],
      cSettings: [
        .headerSearchPath("./editor"),
        .headerSearchPath("./keyboard"),
        .headerSearchPath("./internal"),
      ]
    ),
    .testTarget(
      name: "MathEditorTests",
      dependencies: ["MathEditor"],
      path: "Tests",
      cSettings: [ 
        .headerSearchPath("../mathEditor/editor"),
        .headerSearchPath("../mathEditor/keyboard"),
        .headerSearchPath("../mathEditor/internal"),
      ]
    ),
  ]
)
