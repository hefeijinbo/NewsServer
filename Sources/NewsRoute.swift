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
            response.setHeader(.contentType, value: "application/json")
            try? response.setBody(json: DB.getNewsJSON(minTime: minTime, maxTime: maxTime,catagory: catagory, count: count))
            response.completed()
        }
    }
}
