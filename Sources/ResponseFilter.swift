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
        response.setHeader(.contentType, value: "text/json;charset=utf-8")
        callback(.continue)
    }
    
    func filterBody(response: HTTPResponse, callback: (HTTPResponseFilterResult) -> ()) {
        callback(.continue)
    }
    
}
