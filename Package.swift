// swift-tools-version:4.2

import PackageDescription

let package = Package(
	name: "PerfectServer",
	products: [
		.executable(name: "PerfectServer", targets: ["PerfectServer"])
	],
	dependencies: [
		.package(url: "git://github.com/PerfectlySoft/Perfect-HTTPServer.git", from: "3.0.0"),
        .package(url: "git://github.com/PerfectlySoft/Perfect-MySQL.git", from: "3.0.0"),
        .package(url: "git://github.com/SwiftORM/MySQL-StORM.git", from: "3.0.0"),
	],
	targets: [
		.target(name: "PerfectServer", dependencies: ["PerfectHTTPServer","PerfectMySQL","MySQLStORM"])
	]
)
