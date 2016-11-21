//
//  Connect.swift
//  NewsServer
//
//  Created by jinbo on 16/10/18.
//
//
import MySQL

struct DB {

    static let Host = server.serverAddress
    static let User = "root"
    static let Password = "root"
    static let DBName = "News"
    static let Port: UInt32 = 3306
    
    static func executeQuery(SQL: String) -> MySQL.Results? {
        print(SQL)
        let mysql = MySQL()
        let connected = mysql.connect(host: Host, user: User, password: Password, db: DBName, port: Port)
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
        let connected = mysql.connect(host: Host, user: User, password: Password, db: DBName, port: Port)
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
        let connected = mysql.connect(host: Host, user: User, password: Password, db: DBName, port: Port)
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
        print(error)
        return ["error": error]
    }
    
    static func ResultDic(data: Any) -> [String: Any] {
        print(data)
        return ["data": data]
    }
}

