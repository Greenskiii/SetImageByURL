//
//  File.swift
//  
//
//  Created by Oleksii Danevych on 1/30/22.
//

import Foundation

public protocol NetworkProvider {
    public func startLoad(complition: @escaping (Data?, Error?) -> Void)
}

public protocol URLProvider {
    public var urlToDownload: URL { get set }
    public init(urlToDownload: URL)
}
