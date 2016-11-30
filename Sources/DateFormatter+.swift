//
//  DateFormatter+.swift
//  NewsServer
//
//  Created by bo on 2016/11/9.
//
//

import Foundation

extension DateFormatter {
    static var shared: DateFormatter{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter
    }
}
