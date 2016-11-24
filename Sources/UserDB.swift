//
//  NewsDB.swift
//  NewsServer
//
//  Created by bo on 2016/11/9.
//
//

import Foundation

extension DB {
    
    static let defaultNickname = "路人甲"
    static let defaultIcon = "http://\(server.serverAddress):\(server.serverPort)/" + "icon.png"
    
    static func register(username: String, password: String) -> [String: Any]{
        if username.isEmpty {
            return ResultDic(error: "请输入用户名")
        }
        if password.isEmpty {
            return ResultDic(error: "请输入密码")
        }
        let selectSQL = "select * from user where username = '\(username)'"
        let result = executeQuery(SQL: selectSQL)
        if let result = result, result.numRows() > 0 {
            return ResultDic(error: "用户名已存在")
        }
        let token = UUID().uuidString
        let SQL = "insert into user(username,password,token,nickname,icon) values('\(username)','\(password)','\(token)','\(defaultNickname)','')"
        if let affectedRows = executeUpdate(SQL: SQL) {
            if affectedRows > 0 {
                return ResultDic(data: ["nickname": defaultNickname,"icon": defaultIcon,"username": username, "token": token])
            }
        }
        return ResultDic(error: "注册失败")
    }
    
    static func login(username: String, password: String) -> [String: Any]{
        if username.isEmpty {
            return ResultDic(error: "请输入用户名")
        }
        if password.isEmpty {
            return ResultDic(error: "请输入密码")
        }
        let SQL = "select username,nickname,icon,token from User where username='\(username)' and password = '\(password)'"
        if let result = executeQuery(SQL: SQL) {
            if result.numRows() > 0 {
                var dic = [String: Any]()
                result.forEachRow(callback: { (element) in
                    dic["username"] = element[0]
                    dic["nickname"] = element[1]
                    if let icon = element[2] {
                        if icon.isEmpty {
                            dic["icon"] = defaultIcon
                        } else {
                            dic["icon"] = serverImagesPath + icon
                        }
                    } else {
                        dic["icon"] = defaultIcon
                    }
                    dic["token"] = element[3]
                })
                return ResultDic(data: dic)
            } else {
                return ResultDic(error: "用户名或密码错误")
            }
        }
        return ResultDic(error: "登录失败,请稍后重试")
    }
    
    static func getUserInfo(username: String) -> [String: Any]{
        let SQL = "select username,nickname,icon from User where username = '\(username)'"
        if let result = executeQuery(SQL: SQL) {
            if result.numRows() > 0 {
                var dic = [String: Any]()
                result.forEachRow(callback: { (element) in
                    dic["username"] = element[0]
                    dic["nickname"] = element[1]
                    dic["icon"] = element[2]
                })
                return ResultDic(data: dic)
            } else {
                return ResultDic(error: "用户不存在")
            }
        }
        return ResultDic(error: "获取失败")
    }
    
    static func updateUserNickname(username: String, token: String, nickname: String) -> [String: Any]{
        let SQL = "update News set nickname = '\(nickname)' where username = '\(username)' and token = '\(token)'"
        if let affectedRows = executeUpdate(SQL: SQL) {
            if affectedRows == 0 {
                return ResultDic(error: "参数错误")
            } else {
                return ResultDic(data: ["nickname": nickname])
            }
        } else {
            return ResultDic(error: "修改失败")
        }
    }
    
    static func updateUserIcon(username: String, token: String, icon: String) -> [String: Any]{
        let SQL = "update User set icon = '\(icon)' where username = '\(username)' and token = '\(token)'"
        if let affectedRows = executeUpdate(SQL: SQL) {
            if affectedRows == 0 {
                return ResultDic(error: "参数错误")
            } else {
                return ResultDic(data: ["icon": serverImagesPath + icon])
            }
        } else {
            return ResultDic(error: "修改失败")
        }
    }

}
