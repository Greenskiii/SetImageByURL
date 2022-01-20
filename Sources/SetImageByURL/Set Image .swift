//
//  Set Image .swift
//  TestingPod
//
//  Created by Oleksii Danevych on 1/20/22.
//

import UIKit.UIImage

extension UIImageView {
    
    public func setImage(from urlString: String) {
        let url = URL(string: urlString)!
        
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url) {
                DispatchQueue.main.async {
                    self.image = UIImage(data: data)
                }
            }
        }
    }
}

