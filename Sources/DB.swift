//
//  Connect.swift
//  NewsServer
//
//  Created by jinbo on 16/10/18.
//
//
import Foundation
import MySQL

class DB: NSObject {

    static let Host = "127.0.0.1"
    static let User = "root"
    static let Password = "root"
    static let DB = "News"
    
    static let defaultNickname = "路人甲"
    static let defaultIcon = "http://\(server.serverAddress):\(server.serverPort)/" + "icon.png"
    
    static func executeQuery(SQL: String) -> MySQL.Results? {
        print(SQL)
        let mysql = MySQL()
        let connected = mysql.connect(host: Host, user: User, password: Password, db: DB, port: 3306)
        guard connected else {
            print(mysql.errorMessage())
            return nil
        }
        defer {
            mysql.close()
        }
        guard mysql.query(statement: SQL) else {
            return nil
        }
        return mysql.storeResults()
    }
    
    //返回insertId
    static func executeInsert(SQL: String) -> UInt? {
        print(SQL)
        let mysql = MySQL()
        let connected = mysql.connect(host: Host, user: User, password: Password, db: DB, port: 3306)
        guard connected else {
            print(mysql.errorMessage())
            return nil
        }
        defer {
            mysql.close()
        }
        let stmt = MySQLStmt(mysql)
        guard stmt.prepare(statement: SQL) else {
            return nil
        }
        guard stmt.execute() else {
            return nil
        }
        return stmt.insertId()
    }
    
    //返回affectedRows
    static func executeUpdate(SQL: String) -> UInt? {
        print(SQL)
        let mysql = MySQL()
        let connected = mysql.connect(host: Host, user: User, password: Password, db: DB, port: 3306)
        guard connected else {
            print(mysql.errorMessage())
            return nil
        }
        defer {
            mysql.close()
        }
        let stmt = MySQLStmt(mysql)
        guard stmt.prepare(statement: SQL) else {
            return nil
        }
        guard stmt.execute() else {
            return nil
        }
        return stmt.affectedRows()
    }
    
    static func ResultDic(error: String) -> [String: Any]{
        return ["error": error]
    }
    
    static func ResultDic(data: Any) -> [String: Any] {
        return ["data": data]
    }
}

