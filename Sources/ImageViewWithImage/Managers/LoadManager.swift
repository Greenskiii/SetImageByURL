//
//  File 2.swift
//  
//
//  Created by Oleksii Danevych on 1/20/22.
//
import Foundation

struct LoadManager: NetworkProvider, URLProvider {
    
    var urlToDownload: URL
    
    func startLoad(complition: @escaping (Data?, Error?) -> Void) {
        let dataTask = URLSession.shared.dataTask(with: urlToDownload) { data, response, error in
            if let error = error {
                complition(nil, error)
            }
            if let data = data {
                complition(data, nil)
            }
        }
        dataTask.resume()
    }
}
