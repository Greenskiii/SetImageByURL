//
//  File.swift
//  
//
//  Created by Oleksii Danevych on 1/27/22.
//

import Foundation

class LocalFileManager {
    
    var file: String
    var fileURL: URL
    var fileName: String
    
    init(file: String) {
        self.file = file
        self.fileName = String(file.suffix(7))
        fileURL = URL(fileURLWithPath: fileName,
                      relativeTo: FileManager.default.urls(for: .documentDirectory,
                                                              in: .userDomainMask)[0]).appendingPathExtension("txt")
    }
    
    func saveData(data: Data) {
        do {
            try data.write(to: fileURL)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func getData() -> Data? {
        var savedData: Data?
        do {
            savedData = try Data(contentsOf: fileURL)
        } catch {
            savedData = nil
        }
        return savedData
    }
    
    func deleteData() {
        do{
            try FileManager.default.removeItem(at: fileURL)
        }catch{
            print(error)
        }
    }
}
