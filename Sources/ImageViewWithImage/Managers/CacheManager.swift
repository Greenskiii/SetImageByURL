//
//  File.swift
//  
//
//  Created by Oleksii Danevych on 1/25/22.
//

import Foundation

class CacheManager {
    
    lazy var imagesCache: NSCache<NSString, NSData> = {
        return NSCache<NSString, NSData>()
    }()
    
    static var shared = CacheManager()
    
    func setData(object: Data, key: String) {
        self.imagesCache.setObject(object as NSData, forKey: key as NSString)
    }
    
    func getData(key: String) -> Data? {
        let data = self.imagesCache.object(forKey: key as NSString) as Data?
        return data
    }
    
    func clearCache() {
        self.imagesCache.removeAllObjects()
    }
}
