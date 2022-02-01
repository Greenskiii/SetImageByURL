//
//  File.swift
//  
//
//  Created by Oleksii Danevych on 1/30/22.
//

import Foundation
import UIKit.UIImage

struct LoadManagerMock: NetworkProvider {
    func startLoad(complition: @escaping (Data?, Error?) -> Void) {
        let image = UIImage(systemName: "plus")!
        let data = image.pngData()
        complition(data, nil)
    }
}
