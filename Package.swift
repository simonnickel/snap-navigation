// swift-tools-version: 6.3

import PackageDescription

let package = Package(
    name: "snap-navigation",
	platforms: [
		.iOS(.v18), .macOS(.v15)
	],
    products: [
        .library(
            name: "SnapNavigation",
            targets: ["SnapNavigation"]),
    ],
	dependencies: [
		.package(url: "https://github.com/simonnickel/snap-foundation.git", branch: "main"),
	],
    targets: [
        .target(
            name: "SnapNavigation",
			dependencies: [
				.product(name: "SnapFoundation", package: "snap-foundation")
			]
		),
    ]
)
