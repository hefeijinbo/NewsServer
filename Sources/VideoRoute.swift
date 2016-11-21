//
//  VideoRoutes.swift
//  NewsServer
//
//  Created by bo on 2016/11/9.
//
//

import Foundation
import PerfectHTTP

extension Routes {
    
    mutating func getVideoTitles() {
        add(uri: "/getVideoTitles") { (request, response) in
            let key = request.param(name: "key") ?? ""
            try? response.setBody(json: DB.getVideoTitles(key: key))
            response.completed()
        }
    }
    
    mutating func getVideo() {
        add(uri: "/getVideo") { (request, response) in
            let ID = request.param(name: "ID") ?? ""
            try? response.setBody(json: DB.getVideo(ID: ID))
            response.completed()
        }
    }
    
    mutating func getVideoCommentCount() {
        add(uri: "/getVideoCommentCount") { (request, response) in
            let ID = request.param(name: "ID") ?? ""
            try? response.setBody(json: DB.getVideoCommentCount(ID: ID))
            response.completed()
        }
    }
    
    mutating func addVideo() {
        add(uri: "/addVideo") { (request, response) in
            let title = request.param(name: "title") ?? ""
            let source = request.param(name: "source") ?? ""
            let catagory = request.param(name: "catagory") ?? ""
            var image = ""
            var sourceImage = ""
            var duration = 0.0 //视频时长
            var url = ""
            if let uploads = request.postFileUploads {
                for upload in uploads {
                    
                    if upload.fieldName == "sourceImage" && upload.contentType.isImage {
                        if let file = upload.file {
                            let name = NSUUID().uuidString + ".png"
                            if let _ = try? file.moveTo(path: localImagesPath + name, overWrite: true) {
                                sourceImage = name
                            }
                        }
                    }
                    
                    if upload.fieldName == "video" && upload.contentType.isVideo {
                        if let file = upload.file {
                            let name = NSUUID().uuidString + ".mp4"
                            if let _ = try? file.moveTo(path: localVideosPath + name, overWrite: true) {
                                url = name
                            }
                        }
                    }
                }
            }
            
            //获取视频缩略图作为image
            if !url.isEmpty {
                let tuple = Utils.getThumbnailAndDuration(videoURL: localVideosPath + url)
                image = tuple.0
                duration = tuple.1
            }
            
            if let ID = DB.addVideo(title: title, catagory: catagory, image: image, source: source, sourceImage: sourceImage, url: url, duration: duration) {
                response.setBody(string: "添加成功,视频ID为\(ID)")
            } else {
                response.setBody(string: "添加失败")
            }
            response.completed()
        }
    }

    mutating func getVideos() {
        add(uri: "/getVideos") { (request, response) in
            let minTime = Int(request.param(name: "minTime") ?? "")
            let maxTime = Int(request.param(name: "maxTime") ?? "")
            let count = Int(request.param(name: "count") ?? "") ?? 10
            let catagory = request.param(name: "catagory")
            try? response.setBody(json: DB.getVideos(minTime: minTime, maxTime: maxTime,catagory: catagory, count: count))
            response.completed()
        }
    }

}
