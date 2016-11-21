//
//  CommentRoute.swift
//  NewsServer
//
//  Created by bo on 2016/11/21.
//
//

import Foundation
import PerfectHTTP

extension Routes {

    mutating func addComment() {
        add(uri: "/addComment") { (request, response) in
            let content = request.param(name: "content") ?? ""
            let nickname = request.param(name: "nickname") ?? ""
            let icon = request.param(name: "icon") ?? ""
            let newsID = request.param(name: "newsID") ?? ""
            let videoID = request.param(name: "videoID") ?? ""
            try? response.setBody(json: DB.addComment(content: content, nickname: nickname, icon: icon, newsID: newsID,videoID: videoID))
            response.completed()
        }
    }
    
    mutating func getComments() {
        add(uri: "/getComments") { (request, response) in
            let minTime = Int(request.param(name: "minTime") ?? "")
            let maxTime = Int(request.param(name: "maxTime") ?? "")
            let newsID = request.param(name: "newsID") ?? ""
            let videoID = request.param(name: "videoID") ?? ""
            let count = Int(request.param(name: "count") ?? "") ?? 10
            try? response.setBody(json: DB.getComments(minTime: minTime, maxTime: maxTime, newsID: newsID, videoID: videoID, count: count))
            response.completed()
        }
    }

}
