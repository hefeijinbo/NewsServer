//
//  main.swift
//  NewsServer
//
//  Created by jinbo on 2015-11-05.
//	Copyright (C) 2015 huami, Inc.
//

import Foundation
import PerfectLib
import PerfectHTTP
import PerfectHTTPServer

let server = HTTPServer()
server.serverPort = 8181
server.documentRoot = "./webroot/"

//配置路径
let serverResPath = "http://\(server.serverAddress):\(server.serverPort)/" + "resources/"
let localResPath = "/Users/jinbo/News/resources/"

var routes = Routes()

routes.addNews()
routes.getNewsList()
routes.login()
routes.register()
routes.resource()

server.setResponseFilters([(ResponseFilter(), .medium)])
server.addRoutes(routes)
configureServer(server)

do {
    try server.start()
} catch PerfectError.networkError(let err, let msg) {
    print("Network error thrown: \(err) \(msg)")
}
