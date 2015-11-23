#!/usr/bin/env python
# -*- coding: utf-8 -*-

import math


__all__ = ['wgs2gcj', 'gcj2wgs', 'gcj2wgs_exact',
           'distance', 'gcj2bd', 'bd2gcj', 'wgs2bd', 'bd2wgs']


def outOfChina(lat, lng):
    return not (72.004 <= lng <= 137.8347 and 0.8293 <= lat <= 55.8271)


def transformLat(x, y):
    ret = (-100.0 + 2.0 * x + 3.0 * y + 0.2 * y *
           y + 0.1 * x * y + 0.2 * math.sqrt(abs(x)))
    ret += (20.0 * math.sin(6.0 * x * math.pi) + 20.0 *
            math.sin(2.0 * x * math.pi)) * 2.0 / 3.0
    ret += (20.0 * math.sin(y * math.pi) + 40.0 *
            math.sin(y / 3.0 * math.pi)) * 2.0 / 3.0
    ret += (160.0 * math.sin(y / 12.0 * math.pi) + 320 *
            math.sin(y * math.pi / 30.0)) * 2.0 / 3.0
    return ret


def transformLon(x, y):
    ret = (300.0 + x + 2.0 * y + 0.1 * x * x +
           0.1 * x * y + 0.1 * math.sqrt(abs(x)))
    ret += (20.0 * math.sin(6.0 * x * math.pi) + 20.0 *
            math.sin(2.0 * x * math.pi)) * 2.0 / 3.0
    ret += (20.0 * math.sin(x * math.pi) + 40.0 *
            math.sin(x / 3.0 * math.pi)) * 2.0 / 3.0
    ret += (150.0 * math.sin(x / 12.0 * math.pi) + 300.0 *
            math.sin(x / 30.0 * math.pi)) * 2.0 / 3.0
    return ret


def delta(lat, lng):
    a = 6378245.0
    ee = 0.00669342162296594323
    dLat = transformLat(lng - 105.0, lat - 35.0)
    dLng = transformLon(lng - 105.0, lat - 35.0)
    radLat = lat / 180.0 * math.pi
    magic = math.sin(radLat)
    magic = 1 - ee * magic * magic
    sqrtMagic = math.sqrt(magic)
    dLat = (dLat * 180.0) / ((a * (1 - ee)) / (magic * sqrtMagic) * math.pi)
    dLng = (dLng * 180.0) / (a / sqrtMagic * math.cos(radLat) * math.pi)
    return dLat, dLng


def wgs2gcj(wgsLat, wgsLng):
    if outOfChina(wgsLat, wgsLng):
        return wgsLat, wgsLng
    else:
        dlat, dlng = delta(wgsLat, wgsLng)
        return wgsLat + dlat, wgsLng + dlng


def gcj2wgs(gcjLat, gcjLng):
    if outOfChina(gcjLat, gcjLng):
        return gcjLat, gcjLng
    else:
        dlat, dlng = delta(gcjLat, gcjLng)
        return gcjLat - dlat, gcjLng - dlng


def gcj2wgs_exact(gcjLat, gcjLng):
    initDelta = 0.01
    threshold = 0.000001
    dLat = dLng = initDelta
    mLat = gcjLat - dLat
    mLng = gcjLng - dLng
    pLat = gcjLat + dLat
    pLng = gcjLng + dLng
    for i in range(30):
        wgsLat = (mLat + pLat) / 2
        wgsLng = (mLng + pLng) / 2
        tmplat, tmplng = wgs2gcj(wgsLat, wgsLng)
        dLat = tmplat - gcjLat
        dLng = tmplng - gcjLng
        if abs(dLat) < threshold and abs(dLng) < threshold:
            return wgsLat, wgsLng
        if dLat > 0:
            pLat = wgsLat
        else:
            mLat = wgsLat
        if dLng > 0:
            pLng = wgsLng
        else:
            mLng = wgsLng
    return wgsLat, wgsLng


def distance(latA, lngA, latB, lngB):
    earthR = 6371000
    x = (math.cos(latA * math.pi / 180) * math.cos(latB * math.pi / 180) *
         math.cos((lngA - lngB) * math.pi / 180))
    y = math.sin(latA * math.pi / 180) * math.sin(latB * math.pi / 180)
    s = x + y
    if s > 1:
        s = 1
    if s < -1:
        s = -1
    alpha = math.acos(s)
    distance = alpha * earthR
    return distance


def gcj2bd(gcjLat, gcjLng):
    if outOfChina(gcjLat, gcjLng):
        return gcjLat, gcjLng

    x = gcjLng
    y = gcjLat
    z = math.hypot(x, y) + 0.00002 * math.sin(y * math.pi)
    theta = math.atan2(y, x) + 0.000003 * math.cos(x * math.pi)
    bdLng = z * math.cos(theta) + 0.0065
    bdLat = z * math.sin(theta) + 0.006
    return bdLat, bdLng


def bd2gcj(bdLat, bdLng):
    if outOfChina(bdLat, bdLng):
        return bdLat, bdLng

    x = bdLng - 0.0065
    y = bdLat - 0.006
    z = math.hypot(x, y) - 0.00002 * math.sin(y * math.pi)
    theta = math.atan2(y, x) - 0.000003 * math.cos(x * math.pi)
    gcjLng = z * math.cos(theta)
    gcjLat = z * math.sin(theta)
    return gcjLat, gcjLng


def wgs2bd(wgsLat, wgsLng):
    return gcj2bd(*wgs2gcj(wgsLat, wgsLng))


def bd2wgs(bdLat, bdLng):
    return gcj2wgs(*bd2gcj(bdLat, bdLng))
