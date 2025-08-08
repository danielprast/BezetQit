// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "BezetQit",
  platforms: [.iOS(.v15)],
  products: [
    .library(
      name: "BZConnectionChecker",
      targets: ["BZConnectionChecker"]
    ),
    .library(
      name: "BZUtil",
      targets: ["BZUtil"]
    ),
  ],
  targets: [    
    .target(
      name: "BZConnectionChecker",
      dependencies: ["BZUtil"]
    ),
    .target(
      name: "BZUtil"
    ),
    .testTarget(
      name: "BZConnectionCheckerTests",
      dependencies: ["BZConnectionChecker"]
    ),
  ]
)
