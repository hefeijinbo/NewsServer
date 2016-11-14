//
//  Package.swift
//  NewsServer
//
//  Created by jinbo on 4/20/16.
//	Copyright (C) 2016 huami, Inc.
//

import PackageDescription

let package = Package(
	name: "NewsServer",
	targets: [],
	dependencies: [
		.Package(url: "https://github.com/PerfectlySoft/Perfect-HTTPServer.git", majorVersion: 2, minor: 0),
        .Package(url:"https://github.com/PerfectlySoft/Perfect-MySQL.git", majorVersion: 2, minor: 0),
    ]
)
