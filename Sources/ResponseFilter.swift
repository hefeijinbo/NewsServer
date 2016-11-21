//
//  HttpResponseFilter.swift
//  NewsServer
//
//  Created by bo on 2016/11/10.
//
//

import PerfectHTTP

class ResponseFilter: HTTPResponseFilter {
    
    func filterHeaders(response: HTTPResponse, callback: (HTTPResponseFilterResult) -> ()) {
        //解决网页中文乱码问题
        if let contentType = response.header(.contentType) {
            response.setHeader(.contentType, value: "\(contentType);charset=utf-8")
        } else {
            response.setHeader(.contentType, value: "text/json;charset=utf-8")
        }
        callback(.continue)
    }
    
    func filterBody(response: HTTPResponse, callback: (HTTPResponseFilterResult) -> ()) {
        callback(.continue)
    }
    
}
