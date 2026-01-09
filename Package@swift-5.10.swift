// swift-tools-version: 5.10

import PackageDescription

let package = Package(
	name: "swift-equated",
	products: [
		.library(
			name: "Equated",
			targets: ["Equated"]
		),
	],
	targets: [
		.target(name: "Equated"),
		.testTarget(
			name: "EquatedTests",
			dependencies: ["Equated"]
		),
	]
)
