import Foundation

public struct LocationTransform {
    static let π = M_PI, latKey = "lat", lonKey = "lon"

    static func isOutOfChina(#lat: Double, lon: Double) -> Bool {
        if lon < 72.004 || lon > 137.8347 {
            return true
        }
        if lat < 0.8293 || lat > 55.8271 {
            return true
        }
        return false
    }

    static func transformLat(#x: Double, y: Double) -> Double {
        var ret = -100.0 + 2.0 * x + 3.0 * y + 0.2 * y * y
        ret += 0.1 * x * y + 0.2 * sqrt(abs(x))
        ret += (20.0 * sin(6.0 * x * π) + 20.0 * sin(2.0 * x * π)) * 2.0 / 3.0
        ret += (20.0 * sin(y * π) + 40.0 * sin(y / 3.0 * π)) * 2.0 / 3.0
        ret += (160.0 * sin(y / 12.0 * π) + 320 * sin(y * π / 30.0)) * 2.0 / 3.0
        return ret
    }

    static func transformLon(#x: Double, y: Double) -> Double {
        var ret = 300.0 + x + 2.0 * y + 0.1 * x * x
        ret += 0.1 * x * y + 0.1 * sqrt(abs(x))
        ret += (20.0 * sin(6.0 * x * π) + 20.0 * sin(2.0 * x * π)) * 2.0 / 3.0
        ret += (20.0 * sin(x * π) + 40.0 * sin(x / 3.0 * π)) * 2.0 / 3.0
        ret += (150.0 * sin(x / 12.0 * π) + 300.0 * sin(x / 30.0 * π)) * 2.0 / 3.0
        return ret
    }

    static func delta(#lat: Double, lon: Double) -> (Double, Double) {
        let r = 6378137.0
        let ee = 0.00669342162296594323
        let radLat = lat / 180.0 * π
        var magic = sin(radLat)
        magic = 1 - ee * magic * magic
        let sqrtMagic = sqrt(magic)
        var dLat = transformLat(x: lon - 105.0, y: lat - 35.0)
        var dLon = transformLon(x: lon - 105.0, y: lat - 35.0)
        dLat = (dLat * 180.0) / ((r * (1 - ee)) / (magic * sqrtMagic) * π)
        dLon = (dLon * 180.0) / (r / sqrtMagic * cos(radLat) * π)
        return (dLat, dLon)
    }

    static func wgs2gcj(wgsLat: Double, wgsLon: Double) -> [String: Double] {
        if isOutOfChina(lat: wgsLat, lon: wgsLon) {
            return [latKey: wgsLat, lonKey: wgsLon]
        }
        let (dLat, dLon) = delta(lat: wgsLat, lon: wgsLon)
        return [latKey: wgsLat + dLat, lonKey: wgsLon + dLon]
    }

    static func gcj2wgs(gcjLat: Double, gcjLon: Double) -> [String: Double] {
        if isOutOfChina(lat: gcjLat, lon: gcjLon) {
            return [latKey: gcjLat, lonKey: gcjLon]
        }
        let (dLat, dLon) = delta(lat: gcjLat, lon: gcjLon)
        return [latKey: gcjLat - dLat, lonKey: gcjLon - dLon]
    }

    static func gcj2wgs_exact(gcjLat: Double, gcjLon: Double) -> [String: Double] {
        let initDelta = 0.01, threshold = 0.000001
        var dLat = initDelta
        var dLon = initDelta
        var mLat = gcjLat - dLat
        var mLon = gcjLon - dLon
        var pLat = gcjLat + dLat
        var pLon = gcjLon + dLon
        var wgsLat = gcjLat, wgsLon = gcjLon
        for (var i = 0; i < 30; i++) {
            wgsLat = (mLat + pLat) / 2
            wgsLon = (mLon + pLon) / 2
            var tmp = wgs2gcj(wgsLat, wgsLon: wgsLon) as [String: Double]
            dLat = tmp[latKey]! - gcjLat
            dLon = tmp[lonKey]! - gcjLon
            if (abs(dLat) < threshold) && (abs(dLon) < threshold) {
                return [latKey: wgsLat, lonKey: wgsLon]
            }
            if dLat > 0 {
                pLat = wgsLat
            } else {
                mLat = wgsLat
            }
            if dLon > 0 {
                pLon = wgsLon
            } else {
                mLon = wgsLon
            }
        }
        return [latKey: wgsLat, lonKey: wgsLon]
    }

    static func gcj2bd(gcjLat: Double, gcjLon: Double) -> [String: Double] {
        if isOutOfChina(lat: gcjLat, lon: gcjLon) {
            return [latKey: gcjLat, lonKey: gcjLon]
        }
        let x = gcjLon, y = gcjLat
        let z = sqrt(x * x + y * y) + 0.00002 * sin(y * π)
        let theta = atan2(y, x) + 0.000003 * cos(x * π)
        let bdLon = z * cos(theta) + 0.0065
        let bdLat = z * sin(theta) + 0.006
        return [latKey: bdLat, lonKey: bdLon]
    }

    static func bd2gcj(bdLat: Double, bdLon: Double) -> [String: Double] {
        if isOutOfChina(lat: bdLat, lon: bdLon) {
            return [latKey: bdLat, lonKey: bdLon]
        }
        let x = bdLon - 0.0065, y = bdLat - 0.006
        let z = sqrt(x * x + y * y) - 0.00002 * sin(y * π)
        let theta = atan2(y, x) - 0.000003 * cos(x * π)
        let gcjLon = z * cos(theta)
        let gcjLat = z * sin(theta)
        return [latKey: gcjLat, lonKey: gcjLon]
    }

    static func wgs2bd(wgsLat: Double, wgsLon: Double) -> [String: Double] {
        let gcj = wgs2gcj(wgsLat, wgsLon: wgsLon) as [String: Double]
        return gcj2bd(gcj[latKey]!, gcjLon: gcj[lonKey]!)
    }

    static func bd2wgs(bdLat: Double, bdLon: Double) -> [String: Double] {
        let gcj = bd2gcj(bdLat, bdLon: bdLon) as [String: Double]
        return gcj2wgs(gcj[latKey]!, gcjLon: gcj[lonKey]!)
    }

}
