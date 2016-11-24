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
            try? response.setBody(json: DB.register(username: username, password: password))
            response.completed()
        }
    }
    
    mutating func login() {
        add(uri: "/login") { (request, response) in
            let username = request.param(name: "username") ?? ""
            let password = request.param(name: "password") ?? ""
            try? response.setBody(json: DB.login(username: username, password: password))
            response.completed()
        }
    }
    
    mutating func updateUserIcon() {
        add(uri: "/updateUserIcon") { (request, response) in
            let username = request.param(name: "username") ?? ""
            let token = request.param(name: "token") ?? ""
            var icon = ""
            
            if let uploads = request.postFileUploads {
                for upload in uploads {
                    if upload.fieldName == "icon" {
                        if let file = upload.file {
                            let name = NSUUID().uuidString + ".png"
                            if let _ = try? file.moveTo(path: localImagesPath + name, overWrite: true) {
                                icon = name
                            }
                        }
                    }
                }
            }

            try? response.setBody(json: DB.updateUserIcon(username: username, token: token, icon: icon))
            response.completed()
        }
    }
}
