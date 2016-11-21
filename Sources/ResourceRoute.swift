//
//  ResourceRoutes.swift
//  NewsServer
//
//  Created by bo on 2016/11/9.
//
//

import Foundation
import PerfectHTTP

extension Routes {
    
    //上传的图片
    mutating func images() {
        add(uri: "/images/*") { (request, response) in
            StaticFileHandler(documentRoot: "/Users/jinbo/News/").handleRequest(request: request, response: response)
        }
    }
    
    //上传的视频
    mutating func videos() {
        add(uri: "/videos/*") { (request, response) in
            StaticFileHandler(documentRoot: "/Users/jinbo/News/").handleRequest(request: request, response: response)
        }
    }
}
