import XCTest

let accuracy = 0.00001
let lowAccuracy = accuracy * 2

let TESTS = [
    // wgsLat, wgsLng, gcjLat, gcjLng
    (31.1774276, 121.5272106, 31.17530398364597, 121.531541859215),  // shanghai
    (22.543847, 113.912316, 22.540796131694766, 113.9171764808363),  // shenzhen
    (39.911954, 116.377817, 39.91334545536069, 116.38404722455657)  // beijing
]

let TESTS_bd = [
    // bdLat, bdLng, wgsLat, wgsLng
    (29.199786, 120.019809, 29.196131605295484, 120.00877901149691),
    (29.210504, 120.036455, 29.206795749156136, 120.0253853970846)
]

class EvilTransformTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testWgs2gcj() {
        for (wgsLat, wgsLng, gcjLat, gcjLng) in TESTS {
            let ret = LocationTransform.wgs2gcj(wgsLat, wgsLng: wgsLng)
            XCTAssertTrue(fabs(ret.gcjLat - gcjLat) <= accuracy)
            XCTAssertTrue(fabs(ret.gcjLng - gcjLng) <= accuracy)
        }
    }
    
    func testGcj2wgs() {
        for (wgsLat, wgsLng, gcjLat, gcjLng) in TESTS {
            let ret = LocationTransform.gcj2wgs(gcjLat, gcjLng: gcjLng)
            XCTAssertTrue(fabs(ret.wgsLat - wgsLat) < lowAccuracy)
            XCTAssertTrue(fabs(ret.wgsLng - wgsLng) < lowAccuracy)
        }
    }
    
    func testGcj2wgs_exact() {
        for (wgsLat, wgsLng, gcjLat, gcjLng) in TESTS {
            let ret = LocationTransform.gcj2wgs_exact(gcjLat, gcjLng: gcjLng)
            XCTAssertTrue(fabs(ret.wgsLat - wgsLat) <= accuracy)
            XCTAssertTrue(fabs(ret.wgsLng - wgsLng) <= accuracy)
        }
    }
    
    func testPerformanceWgs2gcj() {
        self.measureBlock {
            let (wgsLat, wgsLng, _, _) = TESTS[0]
            LocationTransform.wgs2gcj(wgsLat, wgsLng: wgsLng)
        }
    }
    
    func testPerformanceGcj2wgs() {
        self.measureBlock {
            let (_, _, gcjLat, gcjLng) = TESTS[0]
            LocationTransform.gcj2wgs(gcjLat, gcjLng: gcjLng)
        }
    }
    
    func testPerformanceGcj2wgs_exact() {
        self.measureBlock {
            let (_, _, gcjLat, gcjLng) = TESTS[0]
            LocationTransform.gcj2wgs_exact(gcjLat, gcjLng: gcjLng)
        }
    }
    
    
    func testWgs2bd() {
        for (bdLat, bdLng, wgsLat, wgsLng) in TESTS_bd {
            let ret = LocationTransform.wgs2bd(wgsLat, wgsLng: wgsLng)
            XCTAssertTrue(fabs(ret.bdLat - bdLat) < lowAccuracy)
            XCTAssertTrue(fabs(ret.bdLng - bdLng) < lowAccuracy)
        }
    }
    
    func testBd2wgs() {
        for (bdLat, bdLng, wgsLat, wgsLng) in TESTS_bd {
            let ret = LocationTransform.bd2wgs(bdLat, bdLng: bdLng)
            XCTAssertTrue(fabs(ret.wgsLat - wgsLat) <= accuracy)
            XCTAssertTrue(fabs(ret.wgsLng - wgsLng) <= accuracy)
        }
    }
    
    func testPerformanceWgs2bd() {
        self.measureBlock {
            let (_, _, wgsLat, wgsLng) = TESTS_bd[0]
            LocationTransform.wgs2bd(wgsLat, wgsLng: wgsLng)
        }
    }
    
    func testPerformanceBd2wgs() {
        self.measureBlock {
            let (bdLat, bdLng, _, _) = TESTS_bd[0]
            LocationTransform.bd2wgs(bdLat, bdLng: bdLng)
        }
    }
}
