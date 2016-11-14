//
//  UserRoutes.swift
//  NewsServer
//
//  Created by bo on 2016/11/9.
//
//

import Foundation
import PerfectHTTP

extension Routes {
    
    mutating func register() {
        add(uri: "/register") { (request, response) in
            let username = request.param(name: "username") ?? ""
            let password = request.param(name: "password") ?? ""
            if username.isEmpty {
                try? response.setBody(json: ["error": "请输入用户名"])
            } else if password.isEmpty {
                try? response.setBody(json: ["error": "请输入用户名"])
            } else {
                try? response.setBody(json: DB.register(username: username, password: password))
            }
            response.completed()
        }
    }
    
    mutating func login() {
        add(uri: "/login") { (request, response) in
            let username = request.param(name: "username") ?? ""
            let password = request.param(name: "password") ?? ""
            if username.isEmpty {
                try? response.setBody(json: ["error": "请输入用户名"])
            } else if password.isEmpty {
                try? response.setBody(json: ["error": "请输入用户名"])
            } else {
                
            }
        }
    }
}
