//  transform.swift
//  Created by HerrKaefer on 15/6/26.

import Darwin

struct EvilTransform {
    
    static func outOfChina(#lat: Double, lng: Double) -> Bool {
        return lng < 72.004 || lng > 137.8347 || lat < 0.8293 || lat > 55.8271
    }

    static private func transform(#x: Double, y: Double) -> (lat: Double, lng: Double) {
        var lat: Double
        var lng: Double
        
        let xy = x * y
        let absX = sqrt(fabs(x))
        let d = (20.0*sin(6.0*x*M_PI) + 20.0*sin(2.0*x*M_PI)) * 2.0 / 3.0
        
        lat = -100.0 + 2.0*x + 3.0*y + 0.2*y*y + 0.1*xy + 0.2*absX
        lng = 300.0 + x + 2.0*y + 0.1*x*x + 0.1*xy + 0.1*absX
        
        lat += d
        lng += d
        
        lat += (20.0*sin(y*M_PI) + 40.0*sin(y/3.0*M_PI)) * 2.0 / 3.0
        lng += (20.0*sin(x*M_PI) + 40.0*sin(x/3.0*M_PI)) * 2.0 / 3.0
        
        lat += (160.0*sin(y/12.0*M_PI) + 320*sin(y/30.0*M_PI)) * 2.0 / 3.0
        lng += (150.0*sin(x/12.0*M_PI) + 300.0*sin(x/30.0*M_PI)) * 2.0 / 3.0
        
        return (lat, lng)
    }

    static private func delta(#lat: Double, lng: Double) -> (dLat: Double, dLng: Double) {
        var dLat: Double
        var dLng: Double
        
        let a = 6378245.0
        let ee = 0.00669342162296594323
        (dLat, dLng) = transform(x: lng-105.0, y: lat-35.0)
        let radLat = lat / 180.0 * M_PI
        var magic = sin(radLat)
        magic = 1 - ee*magic*magic
        let sqrtMagic = sqrt(magic)
        dLat = (dLat * 180.0) / ((a * (1 - ee)) / (magic * sqrtMagic) * M_PI)
        dLng = (dLng * 180.0) / (a / sqrtMagic * cos(radLat) * M_PI)
        return (dLat, dLng)
    }

    static func wgs2gcj(#wgsLat: Double, wgsLng: Double) -> (gcjLat: Double, gcjLng: Double) {
        if outOfChina(lat: wgsLat, lng: wgsLng) {
            return (wgsLat, wgsLng)
        }
        var dCoordinate = delta(lat: wgsLat, lng: wgsLng)
        return (wgsLat + dCoordinate.dLat, wgsLng + dCoordinate.dLng)
    }

    static func gcj2wgs(#gcjLat: Double, gcjLng: Double) -> (wgsLat: Double, wgsLng: Double) {
        if outOfChina(lat: gcjLat, lng: gcjLng) {
            return (gcjLat, gcjLng)
        }
        var dCoordinate = delta(lat: gcjLat, lng: gcjLng)
        return (gcjLat - dCoordinate.dLat, gcjLng - dCoordinate.dLng)
    }

    // nIter=2: centimeter precision, nIter=5: double precision
    static func gcj2wgs_exact(#gcjLat: Double, gcjLng: Double, nIter: Int = 2) -> (wgsLat: Double, wgsLng: Double) {
        if outOfChina(lat: gcjLat, lng: gcjLng) {
            return (gcjLat, gcjLng)
        }
        var wgsLat = gcjLat
        var wgsLng = gcjLng
        for _ in 0..<nIter {
            var dCoordinate = delta(lat: wgsLat, lng: wgsLng)
            wgsLat = gcjLat - dCoordinate.dLat
            wgsLng = gcjLng - dCoordinate.dLng
        }
        return (wgsLat, wgsLng)
    }

    // 1 - cos(x) == 2 sin^2(x/2)
    static private func oneMinusCos(x: Double) -> Double
    {
        let s = sin(x/2)
        return s*s*2
    }

    static func distance(#latA: Double, lngA: Double, latB: Double, lngB: Double) -> Double {
        let earthR: Double = 6371000
        let dLatA = latA * M_PI / 180
        let dLatB = latB * M_PI / 180
        let dLngA = lngA * M_PI / 180
        let dLngB = lngB * M_PI / 180
        return 2 * earthR * asin(sqrt(oneMinusCos(dLatA-dLatB) + cos(dLatA)*cos(dLatB)*(oneMinusCos(dLngA - dLngB)))/M_SQRT2)
    }
}

func testEvilTransform() {
    let testCoordinates = [
        // wgsLat, wgsLng, gcjLat, gcjLng
        [31.1774276, 121.5272106, 31.17530398364597, 121.531541859215], // shanghai
        [22.543847, 113.912316, 22.540796131694766, 113.9171764808363], // shenzhen
        [39.911954, 116.377817, 39.91334545536069, 116.38404722455657], // beijing
    ]
    
    for coord in testCoordinates {
        let wgsLat = coord[0]
        let wgsLng = coord[1]
        let gcjLat = coord[2]
        let gcjLng = coord[3]
    
        println("wgs2gcj:")
        var gcjCoord = EvilTransform.wgs2gcj(wgsLat: wgsLat, wgsLng: wgsLng)
        println("gcj         : \(gcjLat), \(gcjLng)")
        println("gcj computed: \(gcjCoord.gcjLat), \(gcjCoord.gcjLng)")

        println("gcj2wgs:")
        var wgsCoord = EvilTransform.gcj2wgs(gcjLat: gcjLat, gcjLng: gcjLng)
        var d = EvilTransform.distance(latA: wgsCoord.wgsLat, lngA: wgsCoord.wgsLng, latB: wgsLat, lngB: wgsLng)
        if d > 5 {
            println("gcj2wgs test \(coord): distance \(d)")
        }
    
        println("gcj2wgs_exact:")
        wgsCoord = EvilTransform.gcj2wgs_exact(gcjLat: gcjLat, gcjLng: gcjLng)
        d = EvilTransform.distance(latA: wgsCoord.wgsLat, lngA: wgsCoord.wgsLng, latB: wgsLat, lngB: wgsLng)
        if d > 0.5 {
            println("gcj2wgs_exact test \(coord): distance \(d)")
        }
    }
}
