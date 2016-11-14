//
//  NewsDB.swift
//  NewsServer
//
//  Created by bo on 2016/11/9.
//
//

import Foundation

//新闻
extension DB {
    
    static func addNews(title: String, detail: String, images: String,source: String,sourceImage: String, video: String,catagory: String) -> UInt? {
        let SQL = "insert into News(title,detail,images,source,sourceImage,video,catagory) values('\(title)','\(detail)','\(images)','\(source)','\(sourceImage)','\(video)','\(catagory)')"
        return executeInsert(SQL: SQL)
    }
    
    static func getNewsJSON(minTime: Int?, maxTime: Int?, catagory: String?, count: Int) -> [String:Any] {
        var SQL = "select * from News "
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
                var newsDic = [String:Any]()
                newsDic["ID"] = element[0]
                newsDic["title"] = element[1]
                if let images = element[2], !images.isEmpty {
                    newsDic["images"] = images.components(separatedBy: ",")
                } else {
                    newsDic["images"] = [String]()
                }
                newsDic["source"] = element[3]
                newsDic["sourceImage"] = element[4]
                newsDic["updateTime"] = DateFormatter.shared.date(from: element[5] ?? "")?.timeIntervalSince1970 ?? 0
                newsDic["video"] = element[6]
                newsDic["catagory"] = element[7]
                newsDic["commentCount"] = element[8]
                newsDic["detail"] = element[9]
                array.append(newsDic)
            })
        }
        return ResultDic(data: array)
    }
}
