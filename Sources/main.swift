//
//  main.swift
//  NewsServer
//
//  Created by jinbo on 2015-11-05.
//	Copyright (C) 2015 huami, Inc.
//

import PerfectLib
import PerfectHTTP
import PerfectHTTPServer

let server = HTTPServer()
server.serverPort = 8181
server.documentRoot = "./webroot"

//配置路径
let serverImagesPath = "http://\(server.serverAddress):\(server.serverPort)/" + "images/"
let serverVideosPath = "http://\(server.serverAddress):\(server.serverPort)/" + "videos/"
let localImagesPath = "/Users/jinbo/News/images/"
let localVideosPath = "/Users/jinbo/News/videos/"

var routes = Routes()

//用户接口
routes.login()
routes.register()

//资源
routes.images()
routes.videos()

//新闻
routes.addNews()
routes.getNewsList()
routes.getNewsCommentCount()
routes.getNewsTitles()
routes.getNews()

//视频
routes.addVideo()
routes.getVideos()
routes.getVideoCommentCount()
routes.getVideoTitles()
routes.getVideo()

//评论
routes.addComment()
routes.getComments()

server.addRoutes(routes)

server.setResponseFilters([(ResponseFilter(), .medium)])
configureServer(server)

do {
    try server.start()
} catch PerfectError.networkError(let err, let msg) {
    print("Network error thrown: \(err) \(msg)")
}
