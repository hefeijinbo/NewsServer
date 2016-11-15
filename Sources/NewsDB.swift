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
    
    static func getCommentCount(newsID: String) -> [String : Any]{
        if newsID.isEmpty {
            return ResultDic(error: "参数错误")
        }
        let SQL = "select (commentCount) from News where ID = '\(newsID)'"
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
    
    static func addComment(content: String, nickname: String, icon: String, newsID: String) -> [String: Any] {
        let SQL = "insert into Comment(content,nickname,icon,newsID) values('\(content)','\(nickname)','\(icon)','\(newsID)')"
        if let ID = executeInsert(SQL: SQL) {
            DispatchQueue.addCommentCountQueue.async {
                let rows = executeUpdate(SQL: "update News set commentCount=commentCount+1 where ID='\(newsID)'")
                if let _ = rows {
                    print("评论加1")
                }
            }
            return ResultDic(data: ["ID": ID,"content": content,"nickname":nickname,"icon": icon, "newsID": newsID,"updateTime": NSDate().timeIntervalSince1970])
        } else {
            return ResultDic(error: "评论失败")
        }
    }
    
    static func getComments(minTime: Int?, maxTime: Int?, newsID: String, count: Int) -> [String:Any] {
        var SQL = "select * from Comment "
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
        if hasWhere {
            SQL += " and newsID = '\(newsID)'"
        } else {
            SQL += "where newsID = '\(newsID)'"
        }
        SQL += " order by updateTime desc limit \(count)"
        var array = [Any]()
        if let result = executeQuery(SQL: SQL) {
            result.forEachRow(callback: { (element) in
                var commentDic = [String:Any]()
                commentDic["ID"] = element[0]
                commentDic["content"] = element[1]
                commentDic["nickname"] = element[2]
                commentDic["icon"] = element[3]
                commentDic["newsID"] = element[4]
                commentDic["updateTime"] = DateFormatter.shared.date(from: element[5] ?? "")?.timeIntervalSince1970 ?? 0
                array.append(commentDic)
            })
        }
        return ResultDic(data: array)
    }

    
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
