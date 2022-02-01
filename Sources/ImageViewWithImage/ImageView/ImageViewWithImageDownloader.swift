//
//  File.swift
//  
//
//  Created by Oleksii Danevych on 1/20/22.
//

import UIKit.UIImage
import UIKit.UIActivityIndicatorView
import Foundation

typealias NetworkManager = NetworkProvider & URLProvider

public class ImageViewWithImage: UIImageView {
    
    @Published var activityView = UIActivityIndicatorView(style: .large)
    @Published var localFileManager: LocalFileManager
    @Published var loadManager: NetworkManager
    @Published var imageConfiguration: ImageConfiguration
    @Published var memoryLevel: MemoryLevel
    @Published var imageKey: String
    
    public init(loadManager: NetworkManager,
         imageConfiguration: ImageConfiguration = .square,
         memoryLevel: MemoryLevel = .cacheMemory) {
        self.loadManager = loadManager
        self.imageConfiguration = imageConfiguration
        self.memoryLevel = memoryLevel
        imageKey = loadManager.urlToDownload.absoluteString
        self.localFileManager = LocalFileManager(file: imageKey)
        super.init(frame: .zero)
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func loadImage() {
        var imageData: Data?
        
        switch memoryLevel {
        case .localMemory:
            if let data = localFileManager.getData() {
                imageData = data
            }
        case .cacheMemory:
            if let data = CacheManager.shared.getData(key: self.imageKey) {
                imageData = data
            }
        }
        
        if imageData != nil {
            showActivityIndicator()
            loadManager.startLoad { data, error in
                self.hideActivityIndicator()
                DispatchQueue.main.async {
                    if let data = data {
                        self.addImage(data: data, imageConfiguration: self.imageConfiguration)
                        let imageData = self.image?.pngData()
                        self.saveImage(memoryLevel: self.memoryLevel, data: imageData ?? data as Data)
                    }
                }
            }
        } else {
            if let data = imageData {
                setImage(data: data)
            }
        }
    }
    
    public func clearMemory() {
        CacheManager.shared.clearCache()
        localFileManager.deleteData()
    }
    
    private func setImage(data: Data) {
        if let image = UIImage(data: data) {
            DispatchQueue.main.async {
                self.image = image
            }
        }
    }
    
    private func saveImage(memoryLevel: MemoryLevel, data: Data) {
        switch memoryLevel {
        case .localMemory:
            localFileManager.saveData(data: data)
        case .cacheMemory:
            CacheManager.shared.setData(object: data, key: self.imageKey)
        }
    }
    
    private func addImage(data: Data, imageConfiguration: ImageConfiguration) {
        if let image = UIImage(data: data) {
            switch imageConfiguration {
            case .circle(let radius):
                self.image = roundedRectImageFromImage(image: image, imageSize: image.size, cornerRadius: radius)
            case .square:
                self.image = image
            case .cropped(x: let x, y: let y, width: let width, height: let height):
                self.image = cropImage(image: image, rect: CGRect(x: x, y: y, width: width, height: height))
            }
        }
    }
    
    private func cropImage(image: UIImage, rect: CGRect) -> UIImage {
        let cgImage = image.cgImage!
        let croppedCGImage = cgImage.cropping(to: rect)
        return UIImage(cgImage: croppedCGImage!)
    }
    
    private func roundedRectImageFromImage(image:UIImage, imageSize:CGSize, cornerRadius: Int) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(imageSize, false, 0.0)
        let bounds = CGRect(origin: CGPoint.zero, size: imageSize)
        UIBezierPath(roundedRect: bounds, cornerRadius: CGFloat(cornerRadius)).addClip()
        image.draw(in: bounds)
        let finalImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return finalImage
    }
    
    
    private func showActivityIndicator() {
        self.addSubview(activityView)
        activityView.translatesAutoresizingMaskIntoConstraints = false
        activityView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        activityView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        activityView.startAnimating()
    }
    
    private func hideActivityIndicator(){
        DispatchQueue.main.async {
            self.activityView.stopAnimating()
        }
    }
}
