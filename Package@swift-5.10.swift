// swift-tools-version: 5.10
//
//  Package@swift-5.10.swift

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
      targets: ["BZUtil"],
    ),
  ],
  dependencies: [
    .package(
      url: "https://github.com/Alamofire/Alamofire.git",
      exact: "5.10.2"
    ),
  ],
  targets: [
    .target(
      name: "BZConnectionChecker",
      dependencies: ["BZUtil"]
    ),
    .target(
      name: "BZUtil",
      dependencies: ["Alamofire"]
    ),
    .testTarget(
      name: "BZConnectionCheckerTests",
      dependencies: ["BZConnectionChecker"]
    ),
  ],
  swiftLanguageModes: [.v5]
)
