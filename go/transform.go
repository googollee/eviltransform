// Package transform coordinate between earth(WGS-84) and mars in china(GCJ-02).
package transform

import (
	"math"
)

const earthR = 6378137

func outOfChina(lat, lng float64) bool {
	if lng < 72.004 || lng > 137.8347 {
		return true
	}
	if lat < 0.8293 || lat > 55.8271 {
		return true
	}
	return false
}

func transform(x, y float64) (lat, lng float64) {
	xy := x * y
	absX := math.Sqrt(math.Abs(x))
	xPi := x * math.Pi
	yPi := y * math.Pi
	d := 20.0*math.Sin(6.0*xPi) + 20.0*math.Sin(2.0*xPi)

	lat = d
	lng = d

	lat += 20.0*math.Sin(yPi) + 40.0*math.Sin(yPi/3.0)
	lng += 20.0*math.Sin(xPi) + 40.0*math.Sin(xPi/3.0)

	lat += 160.0*math.Sin(yPi/12.0) + 320*math.Sin(yPi/30.0)
	lng += 150.0*math.Sin(xPi/12.0) + 300.0*math.Sin(xPi/30.0)

	lat *= 2.0 / 3.0
	lng *= 2.0 / 3.0

	lat += -100.0 + 2.0*x + 3.0*y + 0.2*y*y + 0.1*xy + 0.2*absX
	lng += 300.0 + x + 2.0*y + 0.1*x*x + 0.1*xy + 0.1*absX

	return
}

func delta(lat, lng float64) (dLat, dLng float64) {
	const ee = 0.00669342162296594323
	dLat, dLng = transform(lng-105.0, lat-35.0)
	radLat := lat / 180.0 * math.Pi
	magic := math.Sin(radLat)
	magic = 1 - ee*magic*magic
	sqrtMagic := math.Sqrt(magic)
	dLat = (dLat * 180.0) / ((earthR * (1 - ee)) / (magic * sqrtMagic) * math.Pi)
	dLng = (dLng * 180.0) / (earthR / sqrtMagic * math.Cos(radLat) * math.Pi)
	return
}

// WGStoGCJ convert WGS-84 coordinate(wgsLat, wgsLng) to GCJ-02 coordinate(gcjLat, gcjLng).
func WGStoGCJ(wgsLat, wgsLng float64) (gcjLat, gcjLng float64) {
	if outOfChina(wgsLat, wgsLng) {
		gcjLat, gcjLng = wgsLat, wgsLng
		return
	}
	dLat, dLng := delta(wgsLat, wgsLng)
	gcjLat, gcjLng = wgsLat+dLat, wgsLng+dLng
	return
}

// GCJtoWGS convert GCJ-02 coordinate(gcjLat, gcjLng) to WGS-84 coordinate(wgsLat, wgsLng).
// The output WGS-84 coordinate's accuracy is 1m to 2m. If you want more exactly result, use GCJtoWGSExact/gcj2wgs_exact.
func GCJtoWGS(gcjLat, gcjLng float64) (wgsLat, wgsLng float64) {
	if outOfChina(gcjLat, gcjLng) {
		wgsLat, wgsLng = gcjLat, gcjLng
		return
	}
	dLat, dLng := delta(gcjLat, gcjLng)
	wgsLat, wgsLng = gcjLat-dLat, gcjLng-dLng
	return
}

// GCJtoWGSExact convert GCJ-02 coordinate(gcjLat, gcjLng) to WGS-84 coordinate(wgsLat, wgsLng).
// The output WGS-84 coordinate's accuracy is less than 0.5m, but much slower than GCJtoWGS/gcj2wgs.
func GCJtoWGSExact(gcjLat, gcjLng float64) (wgsLat, wgsLng float64) {
	const initDelta = 0.01
	const threshold = 0.000001
	dLat, dLng := initDelta, initDelta
	mLat, mLng := gcjLat-dLat, gcjLng-dLng
	pLat, pLng := gcjLat+dLat, gcjLng+dLng
	for i := 0; i < 30; i++ {
		wgsLat, wgsLng = (mLat+pLat)/2, (mLng+pLng)/2
		tmpLat, tmpLng := WGStoGCJ(wgsLat, wgsLng)
		dLat, dLng = tmpLat-gcjLat, tmpLng-gcjLng
		if math.Abs(dLat) < threshold && math.Abs(dLng) < threshold {
			return
		}
		if dLat > 0 {
			pLat = wgsLat
		} else {
			mLat = wgsLat
		}
		if dLng > 0 {
			pLng = wgsLng
		} else {
			mLng = wgsLng
		}
	}
	return
}

// Distance calculate the distance between point(latA, lngA) and point(latB, lngB), unit in meter.
func Distance(latA, lngA, latB, lngB float64) float64 {
	pi180 := math.Pi / 180
	arcLatA := latA * pi180
	arcLatB := latB * pi180
	x := math.Cos(arcLatA) * math.Cos(arcLatB) * math.Cos((lngA-lngB)*pi180)
	y := math.Sin(arcLatA) * math.Sin(arcLatB)
	s := x + y
	if s > 1 {
		s = 1
	}
	if s < -1 {
		s = -1
	}
	alpha := math.Acos(s)
	distance := alpha * earthR
	return distance
}
