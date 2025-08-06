// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "BezetQit",
  platforms: [.iOS(.v13)],
  products: [
    .library(
      name: "BZConnectionChecker",
      targets: ["BZConnectionChecker"]
    ),
    .library(
      name: "BZNetwork",
      targets: ["BZNetwork"]
    ),
  ],
  targets: [    
    .target(
      name: "BZConnectionChecker"
    ),
    .target(
      name: "BZNetwork"
    ),
    .testTarget(
      name: "BZConnectionCheckerTests",
      dependencies: ["BZConnectionChecker"]
    ),
  ]
)
