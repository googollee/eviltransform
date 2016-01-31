# Easily Transform between nice and evil. <br/> 在善恶间随意转换。[![npm version](https://badge.fury.io/js/eviltransform.svg)](https://badge.fury.io/js/eviltransform)

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

Mappings between these coordinates has been defined:

我们定义了以下转换函数：

From| To  | API Name in JS | Approx. Error | Remarks
----|-----|----------------|---------------|--------
WGS | GCJ | `wgs2gcj`      | Exact
GCJ | WGS | `gcj2wgs`      | 1m ~ 2m
GCJ | WGS | `gcj2wgs_exact`| 0.5m          | Iterative, slower. 迭代，稍慢。
GCJ | BD  | `gcj2bd`       | Unknown
BD  | GCJ | `bd2gcj`       | Unknown
BD  | WGS | `bd2wgs`       | Unknown       | BD &rarr; GCJ &rarr; WGS
WGS | BD  | `wgs2bd`       | Unknown       | WGS &rarr; GCJ &rarr; BD

For all functions, the input are just two `Number`s for latitude and longitude
respectively, e.g.:

每个函数的输入参数都只是分别表示经纬度的两个数字：

```JS
exports.wgs2gcj = function(wgsLat, wgsLng) { /* ... */ }
```

For all functions, the result looks like this:

每个函数的 JavaScript 返回值格式都如下所示：

```JS
{ "lat": xx.xxxx /* Number */, "lng": yy.yyyy /* Number */}
```

## Misc functions<br/>杂项函数

### `distance`

```JS
exports.distance = function (latA, lngA, latB, lngB) { /* ... */ }
```

Calculates the distance between point(latA, lngA) and point(latB, lngB), in meters.
This implementation assumes the Earth to be perfectly round; you may wan to use some
real [ellipsoid formulas][geodesics] with the [WGS-84][enwpwgs] model.

计算经纬坐标 A (latA, lngA) 和 B (latB, lngB) 之间的距离，按米计。此函数假定地球为完美圆形，你可能会想用一些真正的[椭球体距离][geodesics]计算公式，代入 [WGS-84][enwpwgs] 模型数据使用。

## Usage in browser

```
$ bower install googollee/eviltransform
eviltransform.gcj2wgs(lat, lng)
```

## See also<br/>参见

 - All Algos: https://github.com/caijun/geoChina/blob/master/R/cst.R
 - GCJ-02: http://blog.csdn.net/coolypf/article/details/8686588
 - BD-09: http://blog.csdn.net/coolypf/article/details/8569813

[enwpwgs]: https://en.wikipedia.org/wiki/World_Geodetic_System#WGS84
[geodesics]: https://en.wikipedia.org/wiki/Geodesics_on_an_ellipsoid#Software_implementations
