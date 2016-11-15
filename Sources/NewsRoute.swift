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
            
            if let ID = DB.addNews(title: title, detail: detail, images: images, source: source, sourceImage: sourceImage, video: video, catagory: catagory) {
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
