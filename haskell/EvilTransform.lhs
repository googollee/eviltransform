> module EvilTransform where

>     type Latitude   = Double
>     type Longitude  = Double
>     type Coordinate = (Latitude, Longitude)

>     outOfChina :: Coordinate -> Bool
>     outOfChina (lat, lng)
>         | lat < 0.8293 || lat > 55.8271  = True
>         | lng < 72.004 || lng > 137.8347 = True
>         | otherwise = False


>     transformLat :: Double -> Double -> Double
>     transformLat x y = sum [i1, i2, i3, i4]
>         where i1 = (-100.0) + 2.0*x + 3.0*y + 0.2*y*y + 0.1*x*y + 0.2*sqrt(abs(x))
>               i2 = (20.0*sin(6.0*x*pi) + 20.0*sin(2.0*x*pi)) * 2.0 / 3.0
>               i3 = (20.0*sin(y*pi) + 40.0*sin(y/3.0*pi)) * 2.0 / 3.0
>               i4 = (160.0*sin(y/12.0*pi) + 320*sin(y*pi/30.0)) * 2.0 / 3.0


>     transformLon :: Double -> Double -> Double
>     transformLon x y = sum [i1, i2, i3, i4]
>         where i1 = 300.0 + x + 2.0*y + 0.1*x*x + 0.1*x*y + 0.1*sqrt(abs(x));
>               i2 = (20.0*sin(6.0*x*pi) + 20.0*sin(2.0*x*pi)) * 2.0 / 3.0
>               i3 = (20.0*sin(x*pi) + 40.0*sin(x/3.0*pi)) * 2.0 / 3.0
>               i4 = (150.0*sin(x/12.0*pi) + 300.0*sin(x/30.0*pi)) * 2.0 / 3.0

>     delte :: Coordinate -> Coordinate
>     delte (lat, lng) = (dLat, dLng)
>         where a         = 6378137.0
>               ee        = 0.00669342162296594323
>               radLat    = lat / 180.0 * pi
>               _magic    = sin radLat
>               magic     = 1 - ee * _magic * _magic
>               sqrtMagic = sqrt magic
>               _dLat     = transformLat (lng-105.0) (lat-35.0)
>               _dLng     = transformLon (lng-105.0) (lat-35.0)
>               dLat      = (_dLat * 180.0) / ((a * (1 - ee)) / (magic * sqrtMagic) * pi)
>               dLng      = (_dLng * 180.0) / (a / sqrtMagic * cos(radLat) * pi)

>     wgs2Gcj :: Coordinate -> Coordinate
>     wgs2Gcj wgscoor
>         | outOfChina wgscoor = wgscoor
>         | otherwise          = (wglat + dlat, wglng + dlng)
>         where (wglat, wglng) = wgscoor
>               (dlat,  dlng)  = delte wgscoor


>     gcj2Wgs :: Coordinate -> Coordinate
>     gcj2Wgs gccoor
>         | outOfChina gccoor  = gccoor
>         | otherwise          = (gcjLat - dLat, gcjLng - dLng)
>         where (gcjLat, gcjLng) = gccoor
>               (dLat, dLng)   = delte gccoor

>     distance :: Coordinate -> Coordinate -> Double
>     distance (latA,lngA) (latB, lngB)
>         | s > 1  = f 1
>         | s < -1 = f (-1)
>         | otherwise =  f s
>         where earchR = 637100
>               x = cos(latA * pi / 180) * cos(latB * pi /180) * cos( (lngA - lngB) * pi /180)
>               y = sin(latA * pi / 180) * sin(latB * pi /180)
>               s = x + y
>               f = (\s -> acos(s) * earchR)


>     gcj2WgsExact :: Coordinate -> Coordinate
>     gcj2WgsExact (gcjLat, gcjLng) = gainOn 0 gcjLat gcjLng mLat mLng pLat pLng
>         where initDelta = 0.01
>               mLat      = gcjLat - initDelta
>               mLng      = gcjLng - initDelta
>               pLat      = gcjLat + initDelta
>               pLng      = gcjLng + initDelta

>     gainOn :: Int    -- times
>            -> Double -- gcjLat
>            -> Double -- gcjLng
>            -> Double -- mLat
>            -> Double -- mLng
>            -> Double -- pLat
>            -> Double -- pLng
>            -> Coordinate
>     gainOn i gcjLat gcjLng mLat mLng pLat pLng
>         | i >= 29  = (wgsLat, wgsLng)
>         | (lessThanThreshold dLat) && (lessThanThreshold dLng) = (wgsLat, wgsLng)
>         | otherwise = let _pLat = if (dLat >  0) then wgsLat else pLat
>                           _mLat = if (dLat <= 0) then wgsLat else mLat
>                           _pLng = if (dLng >  0) then wgsLng else pLng
>                           _mLng = if (dLng <= 0) then wgsLng else mLng
>                       in gainOn (i+1) gcjLat gcjLng _mLat _mLng _pLat _pLng
>         where threshold         = 0.000001
>               wgsLat            = (mLat + pLat) / 2
>               wgsLng            = (mLng + pLng) / 2
>               (tmpLat, tmpLng)  = wgs2Gcj (wgsLat, wgsLng)
>               dLat              = tmpLat - gcjLat
>               dLng              = tmpLng - gcjLng
>               lessThanThreshold = (\x -> abs(x) < threshold)
