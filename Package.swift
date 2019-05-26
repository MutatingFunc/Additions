// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "Additions",
	platforms: [
		.iOS(.v12)
	],
	products: [
		.library(
			name: "Additions",
			targets: ["Additions"]
		),
		.library(
			name: "UITestAdditions",
			targets: ["UITestAdditions"]
		),
	],
	dependencies: [
		// Dependencies declare other packages that this package depends on.
		// .package(url: /* package url */, from: "1.0.0"),
	],
	targets: [
		.target(
			name: "Additions",
			dependencies: [],
			exclude: ["Inactive", "UIKit/Inactive"]
		),
		.testTarget(
			name: "AdditionsTests",
			dependencies: ["Additions"]
		),
		.target(
			name: "UITestAdditions",
			dependencies: ["Additions"]
		),
	]
)
