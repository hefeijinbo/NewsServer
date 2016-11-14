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
    
    //上传的图片和视频
    mutating func resource() {
        add(uri: "/resources/*") { (request, response) in
            StaticFileHandler(documentRoot: "/Users/jinbo/News/").handleRequest(request: request, response: response)
        }
    }
}
