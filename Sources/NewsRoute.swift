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
    
    mutating func getNewsTitles() {
        add(uri: "/getNewsTitles") { (request, response) in
            let key = request.param(name: "key") ?? ""
            try? response.setBody(json: DB.getNewsTitles(key: key))
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
    
    mutating func getNewsCommentCount() {
        add(uri: "/getNewsCommentCount") { (request, response) in
            let newsID = request.param(name: "ID") ?? ""
            try? response.setBody(json: DB.getNewsCommentCount(ID: newsID))
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
            if let uploads = request.postFileUploads {
                for upload in uploads {
                    
                    if upload.fieldName == "images" && upload.contentType.isImage {
                        if let file = upload.file {
                            let name = NSUUID().uuidString + ".png"
                            if let _ = try? file.moveTo(path: localImagesPath + name, overWrite: true) {
                                images += (name + ",")
                            }
                        }
                    }
                    
                    if upload.fieldName == "sourceImage" && upload.contentType.isImage {
                        if let file = upload.file {
                            let name = NSUUID().uuidString + ".png"
                            if let _ = try? file.moveTo(path: localImagesPath + name, overWrite: true) {
                                sourceImage = name
                            }
                        }
                    }
                }
            }
            
            if images.hasSuffix(",") {
                images.remove(at: images.index(before: images.endIndex))
            }
            
            if let ID = DB.addNews(title: title, detail: detail, catagory: catagory, images: images, source: source, sourceImage: sourceImage) {
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
            try? response.setBody(json: DB.getNewsList(minTime: minTime, maxTime: maxTime,catagory: catagory, count: count))
            response.completed()
        }
    }

}
