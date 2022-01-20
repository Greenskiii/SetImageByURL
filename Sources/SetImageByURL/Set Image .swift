//
//  Set Image .swift
//  TestingPod
//
//  Created by Oleksii Danevych on 1/20/22.
//

import UIKit.UIImage
import UIKit.UIActivityIndicator

class CustomImageView: UIImageView {
    
    var activityView = UIActivityIndicatorView(style: .large)
    let loadManager: LoadManager
    
    init(loadManager: LoadManager) {
        self.loadManager = loadManager
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadImage() {
        showActivityIndicator()
        loadManager.startLoad { data, error in
            self.hideActivityIndicator()
            DispatchQueue.main.sync {
                if let image = UIImage(data: data!) {
                    self.image = image
                } else {
                    self.image = UIImage(systemName: "exclamationmark.triangle")
                    self.tintColor = .red
                    self.contentMode = .scaleAspectFit
                }
            }
        }
    }
    
    func showActivityIndicator() {
        self.addSubview(activityView)
        activityView.translatesAutoresizingMaskIntoConstraints = false
        activityView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        activityView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        activityView.startAnimating()
    }
    
    func hideActivityIndicator(){
        DispatchQueue.main.async {
            self.activityView.stopAnimating()
        }
    }
}

struct LoadManager {
    let urlToDownload: URL
    
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

