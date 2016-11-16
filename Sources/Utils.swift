//
//  Utils.swift
//  NewsServer
//
//  Created by bo on 2016/11/16.
//
//

import AVFoundation
import CoreServices

class Utils: NSObject {

    //通过视频URL获取缩略图并写入本地
    static func getThumbnail(videoURL : String) -> String {
        let asset = AVURLAsset(url: URL(string: videoURL)!)
        let gen = AVAssetImageGenerator(asset: asset)
        gen.appliesPreferredTrackTransform = true
        let time = CMTimeMakeWithSeconds(0.0, 600)
        guard let image = try? gen.copyCGImage(at : time, actualTime: nil) else {
            return ""
        }
        
        let fileName = NSUUID().uuidString + ".png"
        let url = URL(fileURLWithPath: localResPath + fileName) as CFURL
        guard let dest = CGImageDestinationCreateWithURL(url, kUTTypePNG, 1, nil) else {
            return ""
        }
        CGImageDestinationAddImage(dest, image, nil)
        if CGImageDestinationFinalize(dest) {
            return serverResPath + fileName
        } else {
            return ""
        }
    }
}
