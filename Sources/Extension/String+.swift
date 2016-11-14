//
//  String+.swift
//  NewsServer
//
//  Created by bo on 2016/11/9.
//
//

import Foundation

extension String {
    var md5 : String{
        let str = cString(using: String.Encoding.utf8) ?? []
        let strLen = CC_LONG(lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen);
        CC_MD5(str, strLen, result);
        var hash = "";
        for i in 0 ..< digestLen {
            hash = hash.appendingFormat("%02x", result[i])
        }
        result.deinitialize();
        return hash
    }
}
