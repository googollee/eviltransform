# Transform coordinate between earth(WGS-84) and mars in china(GCJ-02).

GCJ-02 coordiante is used by Google Maps, Autonavi Map and other china map service. (Baidu Map has an extra offset based on GCJ-02)

## WGStoGCJ/wgs2gcj

 	func WGStoGCJ(wgsLat, wgsLng float64) (gcjLat, gcjLng float64) // Go/Golang
 	void wgs2gcj(double wgsLat, double wgsLng, double *gcjLat, double *gcjLng) // C/C++/Obj-C
 	eviltransform.wgs2gcj(wgsLat, wgsLng) // javascript

Input WGS-84 coordinate(wgsLat, wgsLng) and convert to GCJ-02 coordinate(gcjLat, gcjLng). The output of javascript is like:

	{"lat": xx.xxxx, "lng": yy.yyyy}

## GCJtoWGS/gcj2wgs

	func GCJtoWGS(gcjLat, gcjLng float64) (wgsLat, wgsLng float64) // Go/Golang
	void gcj2wgs(double gcjLat, double gcjLng, double *wgsLat, double *wgsLnt) // C/C++/Obj-C
	eviltransform.gcj2wgs(gcjLat, gcjLng) // javascript

Input GCJ-02 coordinate(gcjLat, gcjLng) and convert to WGS-84 coordinate(wgsLat, wgsLng). The output of javascript is like:

	{"lat": xx.xxxx, "lng": yy.yyyy}

The output WGS-84 coordinate's accuracy is 1m to 2m. If you want more exactly result, use GCJtoWGSExact/gcj2wgs_exact.

## GCJtoWGSExact/gcj2wgs_exact

	func GCJtoWGSExact(gcjLat, gcjLng float64) (wgsLat, wgsLng float64) // Go/Golang
	void gcj2wgs_exact(double gcjLat, double gcjLng, double *wgsLat, double *wgsLnt) // C/C++/Obj-C
	eviltransform.gcj2wgs_exact(gcjLat, gcjLng) // javascript

Input GCJ-02 coordinate(gcjLat, gcjLng) and convert to WGS-84 coordinate(wgsLat, wgsLng). The output of javascript is like:

	{"lat": xx.xxxx, "lng": yy.yyyy}

The output WGS-84 coordinate's accuracy is less than 0.5m, but much slower than GCJtoWGS/gcj2wgs.

## Distance/distance

	func Distance(latA, lngA, latB, lngB float64) float64 // Go/Golang
	double distance(double latA, double lngA, double latB, double lngB) // C/C++/Obj-C
	eviltransform.distance(latA, lngA, latB, lngB) // javascript

Calculate the distance between point(latA, lngA) and point(latB, lngB), unit in meter.

# 地球坐标（WGS-84）与火星坐标（GCJ－2）转换.

GCJ-02坐标用在谷歌地图，高德地图等中国地图服务。（百度地图要在GCJ-02基础上再加转换）

## WGStoGCJ/wgs2gcj

 	func WGStoGCJ(wgsLat, wgsLng float64) (gcjLat, gcjLng float64) // Go/Golang
 	void wgs2gcj(double wgsLat, double wgsLng, double *gcjLat, double *gcjLng) // C/C++/Obj-C
 	eviltransform#wgs2gcj(wgsLat, wgsLng) // javascript

输入WGS-84地球坐标(wgsLat, wgsLng)，转换为GCJ-02火星坐标(gcjLat, gcjLng)。javascript输出格式如下：

	{"lat": xx.xxxx, "lng": yy.yyyy}

## GCJtoWGS/gcj2wgs

	func GCJtoWGS(gcjLat, gcjLng float64) (wgsLat, wgsLng float64) // Go/Golang
	void gcj2wgs(double gcjLat, double gcjLng, double *wgsLat, double *wgsLnt) // C/C++/Obj-C
	eviltransform#gcj2wgs(gcjLat, gcjLng) // javascript

输入GCJ-02火星坐标(gcjLat, gcjLng)，转换为WGS－84地球坐标(wgsLat, wgsLng)。javascript输出格式如下：

	{"lat": xx.xxxx, "lng": yy.yyyy}

输出的WGS-84坐标精度为1米到2米之间。如果要更精确的结果，使用GCJtoWGSExact/gcj2wgs_exact。

## GCJtoWGSExact/gcj2wgs_exact

	func GCJtoWGSExact(gcjLat, gcjLng float64) (wgsLat, wgsLng float64) // Go/Golang
	void gcj2wgs_exact(double gcjLat, double gcjLng, double *wgsLat, double *wgsLnt) // C/C++/Obj-C
	eviltransform#gcj2wgs_exact(gcjLat, gcjLng) // javascript

输入GCJ-02火星坐标(gcjLat, gcjLng)，转换为WGS－84地球坐标(wgsLat, wgsLng)。javascript输出格式如下：

	{"lat": xx.xxxx, "lng": yy.yyyy}

输出的WGS-84坐标精度为0.5米内，但是计算速度慢于GCJtoWGS/gcj2wgs。

## Distance/distance

	func Distance(latA, lngA, latB, lngB float64) float64 // Go/Golang
	double distance(double latA, double lngA, double latB, double lngB) // C/C++/Obj-C
	eviltransform#distance(latA, lngA, latB, lngB) // javascript

计算点(latA, lngA)和点(latB, lngB)之间的距离，单位为米。

## Usage in browser

```
$ bower install googollee/eviltransform
eviltransform.gcj2wgs(lat, lng)
```

## 百度BD-09

```javascript
bd2wgs(lat, lng)  // BD-09 -> WGS-84
wgs2bd(lat, lng)  // WGS-84 -> BD-09
bd2gcj(lat, lng)  // BD-09 -> GCJ-02
gcj2bd(lat, lng)  // GCJ-02 -> BD-09
```
