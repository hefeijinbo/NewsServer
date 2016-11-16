//
//  BodySpec+.swift
//  NewsServer
//
//  Created by bo on 2016/11/10.
//
//

import PerfectHTTP

extension MimeReader.BodySpec {
    var isValidImage: Bool {
        return contentType.hasPrefix("image/")
    }
    
    var isValidVideo: Bool {
        return contentType.hasPrefix("video/")
    }
}
