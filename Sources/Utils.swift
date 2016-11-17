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

    //通过视频URL获取缩略图并写入本地,同时获取视频的duration
    static func getThumbnailAndDuration(videoURL : String) -> (String,TimeInterval) {
        let asset = AVURLAsset(url: URL(string: videoURL)!)
        let duration = Double(asset.duration.value) / Double(asset.duration.timescale)
        let gen = AVAssetImageGenerator(asset: asset)
        gen.appliesPreferredTrackTransform = true
        guard let image = try? gen.copyCGImage(at : kCMTimeZero, actualTime: nil) else {
            return ("",duration)
        }
        
        let fileName = NSUUID().uuidString + ".png"
        let url = URL(fileURLWithPath: localResPath + fileName) as CFURL
        guard let dest = CGImageDestinationCreateWithURL(url, kUTTypePNG, 1, nil) else {
            return ("",duration)
        }
        CGImageDestinationAddImage(dest, image, nil)
        if CGImageDestinationFinalize(dest) {
            return (serverResPath + fileName,duration)
        } else {
            return ("",duration)
        }
    }
    
    static func getDuration(videoURL: String) -> TimeInterval {
        let asset = AVURLAsset(url: URL(string: videoURL)!)
        return Double(asset.duration.value) / Double(asset.duration.timescale)
    }
}
