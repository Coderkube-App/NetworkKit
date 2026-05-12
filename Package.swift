// swift-tools-version: 6.2
import PackageDescription

let package = Package(
  name: "NetworkKit",
  defaultLocalization: "en",
  platforms: [
    .iOS(.v15),
    .macOS(.v12)
  ],
  products: [
    .library(
      name: "NetworkKit",
      targets: ["NetworkKit"]
    )
  ],
  dependencies: [
    .package(url: "https://github.com/Alamofire/Alamofire.git", .upToNextMajor(from: "5.6.0"))
  ],
  targets: [
    .target(
      name: "NetworkKit",
      dependencies: ["Alamofire"]
    ),
    .testTarget(
      name: "NetworkKitTests",
      dependencies: ["NetworkKit"]
    )
  ]
)
