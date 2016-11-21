//
//  VideoDB.swift
//  NewsServer
//
//  Created by bo on 2016/11/9.
//
//

import Foundation

//视频
extension DB {
    //使用关键字搜索视频
    static func getVideoTitles(key: String) -> [String:Any]{
        if key.isEmpty {
            return ResultDic(error: "参数错误")
        }
        let SQL = "select ID,title from Video where title like '%\(key)%'"
        if let result = executeQuery(SQL: SQL) {
            var array = [[String:Any]]()
            result.forEachRow(callback: { (element) in
                var videoDic = [String:Any]()
                videoDic["ID"] = element[0]
                videoDic["title"] = element[1]
                array.append(videoDic)
            })
            return ResultDic(data: array)
        } else {
            return ResultDic(error: "请求错误")
        }
    }
    
    //使用ID获取视频
    static func getVideo(ID: String) -> [String:Any] {
        if ID.isEmpty {
            return ResultDic(error: "参数错误")
        }
        let SQL = "select * from Video where ID = '\(ID)'"
        if let result = executeQuery(SQL: SQL) {
            var dic = [String: Any]()
            result.forEachRow(callback: { (element) in
                dic["ID"] = element[0]
                dic["title"] = element[1]
                dic["catagory"] = element[2]
                dic["image"] = element[3]
                dic["source"] = element[4]
                dic["sourceImage"] = element[5]
                dic["updateTime"] = DateFormatter.shared.date(from: element[6] ?? "")?.timeIntervalSince1970 ?? 0
                dic["url"] = element[7]
                dic["commentCount"] = element[8]
                dic["duration"] = element[9]
                dic["playCount"] = element[10]
            })
            return ResultDic(data: dic)
        } else {
            return ResultDic(error: "请求错误")
        }
    }
    
    static func getVideoCommentCount(ID: String) -> [String : Any]{
        if ID.isEmpty {
            return ResultDic(error: "参数错误")
        }
        let SQL = "select (commentCount) from Video where ID = '\(ID)'"
        if let result = executeQuery(SQL: SQL){
            if result.numRows() == 0 {
                return ResultDic(error: "无此数据")
            } else {
                var count = "0"
                result.forEachRow(callback: { (element) in
                    count = element[0] ?? "0"
                })
                return ResultDic(data: ["count": count])
            }
        } else {
            return ResultDic(error: "查询错误")
        }
    }
    
    static func addVideo(title: String,catagory: String,image: String,source: String,sourceImage: String, url: String,duration: TimeInterval) -> UInt? {
        let SQL = "insert into Video(title,catagory,image,source,sourceImage,url,duration) values('\(title)','\(catagory)','\(image)','\(source)','\(sourceImage)','\(url)','\(duration)')"
        return executeInsert(SQL: SQL)
    }
    
    static func getVideos(minTime: Int?, maxTime: Int?, catagory: String?, count: Int) -> [String:Any] {
        var SQL = "select * from Video "
        var hasWhere = true
        if let minTime = minTime,let maxTime = maxTime {
            SQL += "where updateTime > from_unixtime(\(minTime)) and updateTime < from_unixtime(\(maxTime))"
        } else if let minTime = minTime{
            SQL += "where updateTime > from_unixtime(\(minTime))"
        } else if let maxTime = maxTime {
            SQL += "where updateTime < from_unixtime(\(maxTime))"
        } else {
            hasWhere = false
        }
        if let catagory = catagory {
            if hasWhere {
                SQL += " and catagory = '\(catagory)'"
            } else {
                SQL += "where catagory = '\(catagory)'"
            }
        }
        SQL += " order by updateTime desc limit \(count)"
        var array = [Any]()
        if let result = executeQuery(SQL: SQL) {
            result.forEachRow(callback: { (element) in
                var dic = [String:Any]()
                dic["ID"] = element[0]
                dic["title"] = element[1]
                dic["catagory"] = element[2]
                dic["image"] = element[3]
                dic["source"] = element[4]
                dic["sourceImage"] = element[5]
                dic["updateTime"] = DateFormatter.shared.date(from: element[6] ?? "")?.timeIntervalSince1970 ?? 0
                dic["url"] = element[7]
                dic["commentCount"] = element[8]
                dic["duration"] = element[9]
                dic["playCount"] = element[10]
                array.append(dic)
            })
        }
        return ResultDic(data: array)
    }
}
