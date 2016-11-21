//
//  CommentDB.swift
//  NewsServer
//
//  Created by bo on 2016/11/21.
//
//

import Foundation

//评论
extension DB {
    
    //增加评论
    static func addComment(content: String, nickname: String, icon: String, newsID: String, videoID: String) -> [String: Any] {
        let SQL = "insert into Comment(content,nickname,icon,newsID,videoID) values('\(content)','\(nickname)','\(icon)','\(newsID)','\(videoID)')"
        if let ID = executeInsert(SQL: SQL) {
            DispatchQueue.addCommentCountQueue.async {
                if !newsID.isEmpty {
                    if let ID = executeUpdate(SQL: "update News set commentCount=commentCount+1 where ID='\(newsID)'") {
                        print("新增\(ID)的新闻")
                    }
                } else {
                    if let ID = executeUpdate(SQL: "update Video set commentCount=commentCount+1 where ID='\(videoID)'") {
                        print("新增\(ID)的视频")
                    }
                }
            }
            return ResultDic(data: ["ID": ID,"content": content,"nickname":nickname,"icon": icon, "newsID": newsID,"videoID": videoID,"updateTime": NSDate().timeIntervalSince1970])
        } else {
            return ResultDic(error: "评论失败")
        }
    }
    
    //获取评论数组
    static func getComments(minTime: Int?, maxTime: Int?, newsID: String,videoID: String, count: Int) -> [String:Any] {
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
        let name = newsID.isEmpty ? "videoID" : "newsID"
        if hasWhere {
            SQL += " and \(name) = '\(newsID)'"
        } else {
            SQL += "where \(name) = '\(videoID)'"
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
                commentDic["videoID"] = element[5]
                commentDic["updateTime"] = DateFormatter.shared.date(from: element[6] ?? "")?.timeIntervalSince1970 ?? 0
                array.append(commentDic)
            })
        }
        return ResultDic(data: array)
    }
}
