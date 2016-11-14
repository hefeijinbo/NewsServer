//
//  DateFormatter+.swift
//  NewsServer
//
//  Created by bo on 2016/11/9.
//
//

import Foundation

extension DateFormatter {
    public static var shared: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        return dateFormatter
    }
}
