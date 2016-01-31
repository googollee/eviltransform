# Easily Transform between nice and evil. <br/> 在善恶间随意转换。

This project contains implementations for conversion between the WGS-84 
"Earth" coordinate system used by GPS and the Evil GCJ-02 "Mars" system
used in China.

此项目提供 WGS-84 GPS 坐标系和中国国家标准 GCJ-02 “火星”坐标系的转换实现。GCJ-02 坐标系由包括谷歌和高德导航在内的很多地图提供商用于中国的地图上。这个坐标系提供一些“加密”功能，通过加上一坨坨三角函数避免了解析解的存在。本项目提供近似算法。欲知详情，请阅读“参见”中的《geoChina》一条。

GCJ-02 is a coordinate system in China's national standard. As a result,
many map providers like Google Maps and Autonavi use this for their Chinese
maps. It features some 'encryption' with bunches of trig functions so no
analytical solutions for the reverse are possible, but approximations are
not too hard. For more info, read *geoChina* in see-also.

Now we have added support for BD-09, a more evil coordinate system with added
offsets from GCJ02 by Baidu.

本项目新增了度娘坐标系 BD-09 的转换算法。这个算法是百度在 GCJ-02 之上再加偏的结果。

## Transformation functions<br/>转换函数

The functions are named like `sysA<to>sysB<exact>`, but we use different
cases and `to`'s in different languages. Here is a table:

函数的命名类似 `sysA<to>sysB<exact>`，但是我们的大小写和表示 `to` 的方法在各个语言内稍有不同（lower 为小写，upper 为大写，camel 为小驼峰）：

Language  | "to" | "exact" | Case   | Naming Example
----------|------|---------|--------|---------------
Golang    | `to` | `Exact` | upper  | `func WGStoGCJExact(wgsLat, wgsLng float64) (gcjLat, gcjLng float64)`
(Obj)C(++)| `2`  | `_exact`| lower  | `void wgs2gcj_exact(double wgsLat, double wgsLng, double *gcjLat, double *gcjLng)`
JS & Py   | `2`  | `_exact`| lower  | `eviltransform.wgs2gcj_exact(wgsLat, wgsLng)`
PHP       | `to` | `Exact` | upper  | `EvilTransform::WGStoGCJExact($wgsLat, $wgsLng)`
C#        | `2`  | `Exact` | upper  | `EvilTransform.Transform.WGS2GCJExact(wgsLat, wgsLng)`
Haskell   | `2`  | `Exact` | camel  | `wgs2GcjExact (gcjLat, gcjLng)`

Mappings between these coordinates has been defined:

我们定义了以下转换函数：

From| To  | API Name in JS | Approx. Error | Remarks
----|-----|----------------|---------------|--------
WGS | GCJ | `wgs2gcj`      | Exact
GCJ | WGS | `gcj2wgs`      | 1m ~ 2m
GCJ | WGS | `gcj2wgs_exact`| 0.5m          | Iterative, much slower. 迭代，慢很多。
GCJ | BD  | `gcj2bd`       | Unknown
BD  | GCJ | `bd2gcj`       | Unknown
BD  | WGS | `bd2wgs`       | Unknown       | BD &rarr; GCJ &rarr; WGS
WGS | BD  | `wgs2bd`       | Unknown       | WGS &rarr; GCJ &rarr; BD

From these you should be able to figure out the names of all the functions.

聪明的你从这两张表格可以脑补出任意语言的任意函数名了。

For all functions, the result looks like this in JavaScript implementation:

每个函数的 JavaScript 返回值格式都如下所示：

```JS
{ "lat": xx.xxxx /* Number */, "lng": yy.yyyy /* Number */}
```

## Misc functions<br/>杂项函数

### `distance`

	func Distance(latA, lngA, latB, lngB float64) float64 // Go/Golang
	double distance(double latA, double lngA, double latB, double lngB) // C/C++/Obj-C
	eviltransform.distance(latA, lngA, latB, lngB) // JavaScript/Python
	EvilTransform::Distance($latA, $lngA, $latB, $lngB) // PHP
	EvilTransform.Transform.Distance(latA, lngA, latB, lngB) //CSharp
	distance (lat, lng)

Calculates the distance between point(latA, lngA) and point(latB, lngB), in meters.
This implementation assumes the Earth to be perfectly round; you may wan to use some
real ellipsoid formulas with the [WGS-84][enwpwgs] model.

计算经纬坐标 A (latA, lngA) 和 B (latB, lngB) 之间的距离，按米计。此函数假定地球为完美圆形，你可能会想用一些真正的椭球体距离计算公式，代入 [WGS-84][enwpwgs] 模型数据使用。

## Original Implmentations<br/>算法来源

 - GCJ-02:
   - https://on4wp7.codeplex.com/SourceControl/changeset/view/21483#353936
   - http://emq.googlecode.com/svn/emq/src/Algorithm/Coords/Converter.java
 - BD-09:
   - http://blog.csdn.net/coolypf/article/details/8686588

## See also<br/>参见

 - All Algos: https://github.com/caijun/geoChina/blob/master/R/cst.R
 - GCJ-02: https://github.com/Leask/EvilTransform
 - GCJ-02: http://cxzy.people.com.cn/GB/196034/14908095.html

[enwpwgs]: https://en.wikipedia.org/wiki/World_Geodetic_System#WGS84
