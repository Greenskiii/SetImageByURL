//
//  File.swift
//  
//
//  Created by Oleksii Danevych on 1/30/22.
//

import Foundation

public protocol NetworkProvider {
    func startLoad(complition: @escaping (Data?, Error?) -> Void)
}

public protocol URLProvider {
    var urlToDownload: URL { get set }
}
