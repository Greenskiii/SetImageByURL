//
//  File.swift
//  
//
//  Created by Oleksii Danevych on 1/30/22.
//

import Foundation

protocol NetworkProvider {
    func startLoad(complition: @escaping (Data?, Error?) -> Void)
}

protocol URLProvider {
    var urlToDownload: URL { get set }
}
