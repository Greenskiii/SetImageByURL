import XCTest
@testable import ImageViewWithImage

final class ImageViewWithImageTests: XCTestCase {
    
    var url: URL!
    var loadManager: NetworkProvider!
    var data: Data! = nil
    
    override func setUp() {
        loadManager = LoadManagerMock()
    }
    
    func testLoadManager() {
        loadManager.startLoad { data, error in
            if let data = data {
                self.data = data
            }
        }
        XCTAssertTrue(self.data != nil)
    }
    
    func testCache() {
        let cacheManager = CacheManager.shared
        let data = Data("some Data".utf8)
        cacheManager.setData(object: data, key: "Key")
        XCTAssertEqual(data, cacheManager.getData(key: "Key"))
    }
    
    func testLocalMemory() {
        let data = Data("some Data".utf8)
        let networkManager = LocalFileManager(file: "Test")
        networkManager.saveData(data: data)
        XCTAssertEqual(data, networkManager.getData())
    }
}
