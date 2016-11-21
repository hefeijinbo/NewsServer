//
//  BodySpec+.swift
//  NewsServer
//
//  Created by bo on 2016/11/10.
//
//

import PerfectHTTP

extension String {
    
    var isResource: Bool {
        return hasPrefix("image/") || hasPrefix("video/")
    }
    
    var isImage: Bool {
        return hasPrefix("image/")
    }
    
    var isVideo: Bool {
        return hasPrefix("video/")
    }
}
