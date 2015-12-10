# Transform coordinate between earth(WGS-84) and mars in china(GCJ-02).

GCJ-02 coordiante is used by Google Maps, Autonavi Map and other china map service. (Baidu Map has an extra offset based on GCJ-02)

## WGStoGCJ/wgs2gcj

	func WGStoGCJ(wgsLat, wgsLng float64) (gcjLat, gcjLng float64) // Go/Golang
	void wgs2gcj(double wgsLat, double wgsLng, double *gcjLat, double *gcjLng) // C/C++/Obj-C
	eviltransform.wgs2gcj(wgsLat, wgsLng) // JavaScript/Python
	\larryli\eviltransform\EvilTransform::WGStoGCJ($wgsLat, $wgsLng) // PHP5.4+
	EvilTransform.Transform.WGS2GCJ(wgsLat, wgsLng) // CSharp
	wgs2Gcj (gcjLat, gcjLng) // Haskell

Input WGS-84 coordinate(wgsLat, wgsLng) and convert to GCJ-02 coordinate(gcjLat, gcjLng). The output of JavaScript is like:

	{"lat": xx.xxxx, "lng": yy.yyyy}

## GCJtoWGS/gcj2wgs

	func GCJtoWGS(gcjLat, gcjLng float64) (wgsLat, wgsLng float64) // Go/Golang
	void gcj2wgs(double gcjLat, double gcjLng, double *wgsLat, double *wgsLnt) // C/C++/Obj-C
	eviltransform.gcj2wgs(gcjLat, gcjLng) // JavaScript/Python
	\larryli\eviltransform\EvilTransform::GCJtoWGS($gcjLat, $gcjLng) // PHP5.4+
	EvilTransform.Transform.GCJ2WGS(gcjLat, gcjLng) //CSharp
	gcj2Wgs (gcjLat, gcjLng) // Haskell

Input GCJ-02 coordinate(gcjLat, gcjLng) and convert to WGS-84 coordinate(wgsLat, wgsLng). The output of JavaScript is like:

	{"lat": xx.xxxx, "lng": yy.yyyy}

The output WGS-84 coordinate's accuracy is 1m to 2m. If you want more exactly result, use GCJtoWGSExact/gcj2wgs_exact.

## GCJtoWGSExact/gcj2wgs_exact

	func GCJtoWGSExact(gcjLat, gcjLng float64) (wgsLat, wgsLng float64) // Go/Golang
	void gcj2wgs_exact(double gcjLat, double gcjLng, double *wgsLat, double *wgsLnt) // C/C++/Obj-C
	eviltransform.gcj2wgs_exact(gcjLat, gcjLng) // JavaScript/Python
	\larryli\eviltransform\EvilTransform::GCJtoWGSExact($gcjLat, $gcjLng) // PHP5.4+
	EvilTransform.Transform.GCJ2WGSExact(gcjLat, gcjLng) //CSharp
	gcj2WgsExact (gcjLat, gcjLng) //Haskell

Input GCJ-02 coordinate(gcjLat, gcjLng) and convert to WGS-84 coordinate(wgsLat, wgsLng). The output of JavaScript is like:

	{"lat": xx.xxxx, "lng": yy.yyyy}

The output WGS-84 coordinate's accuracy is less than 0.5m, but much slower than GCJtoWGS/gcj2wgs.

## Distance/distance

	func Distance(latA, lngA, latB, lngB float64) float64 // Go/Golang
	double distance(double latA, double lngA, double latB, double lngB) // C/C++/Obj-C
	eviltransform.distance(latA, lngA, latB, lngB) // JavaScript/Python
	\larryli\eviltransform\EvilTransform::Distance($latA, $lngA, $latB, $lngB) // PHP5.4+
	EvilTransform.Transform.Distance(latA, lngA, latB, lngB) //CSharp
	distance (lat, lng)

Calculate the distance between point(latA, lngA) and point(latB, lngB), unit in meter.

## Original from:

 - https://on4wp7.codeplex.com/SourceControl/changeset/view/21483#353936
 - http://emq.googlecode.com/svn/emq/src/Algorithm/Coords/Converter.java

## See also:

 - http://blog.csdn.net/coolypf/article/details/8686588
 - http://cxzy.people.com.cn/GB/196034/14908095.html
 - https://github.com/Leask/EvilTransform

---

# 地球坐标（WGS-84）与火星坐标（GCJ－2）转换.

GCJ-02坐标用在谷歌地图，高德地图等中国地图服务。（百度地图要在GCJ-02基础上再加转换）

## WGStoGCJ/wgs2gcj

	func WGStoGCJ(wgsLat, wgsLng float64) (gcjLat, gcjLng float64) // Go/Golang
	void wgs2gcj(double wgsLat, double wgsLng, double *gcjLat, double *gcjLng) // C/C++/Obj-C
	eviltransform.wgs2gcj(wgsLat, wgsLng) // JavaScript/Python
	\larryli\eviltransform\EvilTransform::WGStoGCJ($wgsLat, $wgsLng) // PHP5.4+
	EvilTransform.Transform.WGS2GCJ(wgsLat, wgsLng) // CSharp
	wgs2Gcj (gcjLat, gcjLng) // Haskell

输入WGS-84地球坐标(wgsLat, wgsLng)，转换为GCJ-02火星坐标(gcjLat, gcjLng)。JavaScript输出格式如下：

	{"lat": xx.xxxx, "lng": yy.yyyy}

## GCJtoWGS/gcj2wgs

	func GCJtoWGS(gcjLat, gcjLng float64) (wgsLat, wgsLng float64) // Go/Golang
	void gcj2wgs(double gcjLat, double gcjLng, double *wgsLat, double *wgsLnt) // C/C++/Obj-C
	eviltransform.gcj2wgs(gcjLat, gcjLng) // JavaScript/Python
	\larryli\eviltransform\EvilTransform::GCJtoWGS($gcjLat, $gcjLng) // PHP5.4+
	EvilTransform.Transform.GCJ2WGS(gcjLat, gcjLng) //CSharp
	gcj2Wgs (gcjLat, gcjLng) // Haskell

输入GCJ-02火星坐标(gcjLat, gcjLng)，转换为WGS－84地球坐标(wgsLat, wgsLng)。JavaScript输出格式如下：

	{"lat": xx.xxxx, "lng": yy.yyyy}

输出的WGS-84坐标精度为1米到2米之间。如果要更精确的结果，使用GCJtoWGSExact/gcj2wgs_exact。

## GCJtoWGSExact/gcj2wgs_exact

	func GCJtoWGSExact(gcjLat, gcjLng float64) (wgsLat, wgsLng float64) // Go/Golang
	void gcj2wgs_exact(double gcjLat, double gcjLng, double *wgsLat, double *wgsLnt) // C/C++/Obj-C
	eviltransform.gcj2wgs_exact(gcjLat, gcjLng) // JavaScript/Python
	\larryli\eviltransform\EvilTransform::GCJtoWGSExact($gcjLat, $gcjLng) // PHP5.4+
	EvilTransform.Transform.GCJ2WGSExact(gcjLat, gcjLng) //CSharp
	gcj2WgsExact (gcjLat, gcjLng) //Haskell

输入GCJ-02火星坐标(gcjLat, gcjLng)，转换为WGS－84地球坐标(wgsLat, wgsLng)。JavaScript 输出格式如下：

	{"lat": xx.xxxx, "lng": yy.yyyy}

输出的WGS-84坐标精度为0.5米内，但是计算速度慢于GCJtoWGS/gcj2wgs。

## Distance/distance

	func Distance(latA, lngA, latB, lngB float64) float64 // Go/Golang
	double distance(double latA, double lngA, double latB, double lngB) // C/C++/Obj-C
	eviltransform.distance(latA, lngA, latB, lngB) // JavaScript/Python
	\larryli\eviltransform\EvilTransform::Distance($latA, $lngA, $latB, $lngB) // PHP5.4+
	EvilTransform.Transform.Distance(latA, lngA, latB, lngB) //CSharp
	distance (lat, lng)

计算点(latA, lngA)和点(latB, lngB)之间的距离，单位为米。


## 算法来源:

 - https://on4wp7.codeplex.com/SourceControl/changeset/view/21483#353936
 - http://emq.googlecode.com/svn/emq/src/Algorithm/Coords/Converter.java

## 参考:

 - http://blog.csdn.net/coolypf/article/details/8686588
 - http://cxzy.people.com.cn/GB/196034/14908095.html
 - https://github.com/Leask/EvilTransform
