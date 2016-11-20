//
//  NewsRoutes.swift
//  NewsServer
//
//  Created by bo on 2016/11/9.
//
//

import Foundation
import PerfectHTTP

extension Routes {
    
    mutating func getTitles() {
        add(uri: "/getTitles") { (request, response) in
            let key = request.param(name: "key") ?? ""
            try? response.setBody(json: DB.getTitles(key: key))
            response.completed()
        }
    }
    
    mutating func getNews() {
        add(uri: "/getNews") { (request, response) in
            let ID = request.param(name: "ID") ?? ""
            try? response.setBody(json: DB.getNews(ID: ID))
            response.completed()
        }
    }
    
    mutating func getCommentCount() {
        add(uri: "/getCommentCount") { (request, response) in
            let newsID = request.param(name: "newsID") ?? ""
            try? response.setBody(json: DB.getCommentCount(newsID: newsID))
            response.completed()
        }
    }
    
    mutating func addComment() {
        add(uri: "/addComment") { (request, response) in
            let content = request.param(name: "content") ?? ""
            let nickname = request.param(name: "nickname") ?? ""
            let icon = request.param(name: "icon") ?? ""
            let newsID = request.param(name: "newsID") ?? ""
            try? response.setBody(json: DB.addComment(content: content, nickname: nickname, icon: icon, newsID: newsID))
            response.completed()
        }
    }
    
    mutating func getComments() {
        add(uri: "/getComments") { (request, response) in
            let minTime = Int(request.param(name: "minTime") ?? "")
            let maxTime = Int(request.param(name: "maxTime") ?? "")
            let newsID = request.param(name: "newsID") ?? "0"
            let count = Int(request.param(name: "count") ?? "") ?? 10
            try? response.setBody(json: DB.getComments(minTime: minTime, maxTime: maxTime, newsID: newsID, count: count))
            response.completed()
        }
    }
    
    mutating func addNews() {
        add(uri: "/addNews") { (request, response) in
            let title = request.param(name: "title") ?? ""
            let detail = request.param(name: "detail") ?? ""
            let source = request.param(name: "source") ?? ""
            let catagory = request.param(name: "catagory") ?? ""
            var images = ""
            var sourceImage = ""
            var video = ""
            var duration = 0.0 //视频时长
            if let uploads = request.postFileUploads {
                for upload in uploads {
                    
                    if upload.fieldName == "images" && upload.isValidImage {
                        if let file = upload.file {
                            let name = NSUUID().uuidString + ".png"
                            if let _ = try? file.moveTo(path: localResPath + name, overWrite: true) {
                                images += "\(serverResPath + name),"
                            }
                        }
                    }
                    
                    if upload.fieldName == "sourceImage" && upload.isValidImage {
                        if let file = upload.file {
                            let name = NSUUID().uuidString + ".png"
                            if let _ = try? file.moveTo(path: localResPath + name, overWrite: true) {
                                sourceImage = serverResPath + name
                            }
                        }
                    }
                    
                    if upload.fieldName == "video" && upload.isValidVideo {
                        if let file = upload.file {
                            let name = NSUUID().uuidString + ".mp4"
                            if let _ = try? file.moveTo(path: localResPath + name, overWrite: true) {
                                video = serverResPath + name
                            }
                        }
                    }
                }
            }
            
            if images.hasSuffix(",") {
                images.remove(at: images.index(before: images.endIndex))
            }
            
            //获取视频缩略图作为image
            if !video.isEmpty {
                if images.isEmpty {
                    let tuple = Utils.getThumbnailAndDuration(videoURL: video)
                    images = tuple.0
                    duration = tuple.1
                } else {
                    duration = Utils.getDuration(videoURL: video)
                }
            }
            
            if let ID = DB.addNews(title: title, detail: detail, images: images, source: source, sourceImage: sourceImage, video: video,duration: duration,catagory: catagory) {
                response.setBody(string: "添加成功,新闻ID为\(ID)")
            } else {
                response.setBody(string: "添加失败")
            }
            response.completed()
        }
    }

    mutating func getNewsList() {
        add(uri: "/getNewsList") { (request, response) in
            let minTime = Int(request.param(name: "minTime") ?? "")
            let maxTime = Int(request.param(name: "maxTime") ?? "")
            let count = Int(request.param(name: "count") ?? "") ?? 10
            let catagory = request.param(name: "catagory")
            try? response.setBody(json: DB.getNewsJSON(minTime: minTime, maxTime: maxTime,catagory: catagory, count: count))
            response.completed()
        }
    }

}
