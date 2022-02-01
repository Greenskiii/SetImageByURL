//
//  File.swift
//  
//
//  Created by Oleksii Danevych on 1/25/22.
//

enum ImageConfiguration {
    case square
    case circle(radius: Int)
    case cropped(x: Int, y: Int, width: Int, height: Int)
}
