<?php

// Package transform coordinate between earth(WGS-84) and mars in china(GCJ-02).
class EvilTransform
{

    private static function outOfChina($lat, $lng)
    {
        if ($lng < 72.004 || $lng > 137.8347) {
            return true;
        }
        if ($lat < 0.8293 || $lat > 55.8271) {
            return true;
        }
        return false;
    }

    private static function transform($x, $y)
    {
        $xy = $x * $y;
        $absX = sqrt(abs($x));
        $d = (20.0 * sin(6.0 * $x * pi()) + 20.0 * sin(2.0 * $x * pi())) * 2.0 / 3.0;

        $lat = -100.0 + 2.0 * $x + 3.0 * $y + 0.2 * $y * $y + 0.1 * $xy + 0.2 * $absX;
        $lng = 300.0 + $x + 2.0 * $y + 0.1 * $x * $x + 0.1 * $xy + 0.1 * $absX;

        $lat += $d;
        $lng += $d;

        $lat += (20.0 * sin($y * pi()) + 40.0 * sin($y / 3.0 * pi())) * 2.0 / 3.0;
        $lng += (20.0 * sin($x * pi()) + 40.0 * sin($x / 3.0 * pi())) * 2.0 / 3.0;

        $lat += (160.0 * sin($y / 12.0 * pi()) + 320 * sin($y / 30.0 * pi())) * 2.0 / 3.0;
        $lng += (150.0 * sin($x / 12.0 * pi()) + 300.0 * sin($x / 30.0 * pi())) * 2.0 / 3.0;

        return array($lat, $lng);
    }

    private static function delta($lat, $lng)
    {
        /*const */$a = 6378245.0;
        /*const */$ee = 0.00669342162296594323;
        list($dLat, $dLng) = self::transform($lng - 105.0, $lat - 35.0);
        $radLat = $lat / 180.0 * pi();
        $magic = sin($radLat);
        $magic = 1 - $ee * $magic * $magic;
        $sqrtMagic = sqrt($magic);
        $dLat = ($dLat * 180.0) / (($a * (1 - $ee)) / ($magic * $sqrtMagic) * pi());
        $dLng = ($dLng * 180.0) / ($a / $sqrtMagic * cos($radLat) * pi());
        return array($dLat, $dLng);
    }

    // WGStoGCJ convert WGS-84 coordinate(wgsLat, wgsLng) to GCJ-02 coordinate(gcjLat, gcjLng).
    public static function WGStoGCJ($wgsLat, $wgsLng)
    {
        if (self::outOfChina($wgsLat, $wgsLng)) {
            list($gcjLat, $gcjLng) = array($wgsLat, $wgsLng);
            return array($gcjLat, $gcjLng);
        }
        list($dLat, $dLng) = self::delta($wgsLat, $wgsLng);
        list($gcjLat, $gcjLng) = array($wgsLat + $dLat, $wgsLng + $dLng);
        return array($gcjLat, $gcjLng);
    }

    // GCJtoWGS convert GCJ-02 coordinate(gcjLat, gcjLng) to WGS-84 coordinate(wgsLat, wgsLng).
    // The output WGS-84 coordinate's accuracy is 1m to 2m. If you want more exactly result, use GCJtoWGSExact/gcj2wgs_exact.
    public static function GCJtoWGS($gcjLat, $gcjLng)
    {
        if (self::outOfChina($gcjLat, $gcjLng)) {
            list($wgsLat, $wgsLng) = array($gcjLat, $gcjLng);
            return array($wgsLat, $wgsLng);
        }
        list($dLat, $dLng) = self::delta($gcjLat, $gcjLng);
        list($wgsLat, $wgsLng) = array($gcjLat - $dLat, $gcjLng - $dLng);
        return array($wgsLat, $wgsLng);
    }

    // GCJtoWGSExact convert GCJ-02 coordinate(gcjLat, gcjLng) to WGS-84 coordinate(wgsLat, wgsLng).
    // The output WGS-84 coordinate's accuracy is less than 0.5m, but much slower than GCJtoWGS/gcj2wgs.
    public static function GCJtoWGSExact($gcjLat, $gcjLng)
    {
        /*const */$initDelta = 0.01;
        /*const */$threshold = 0.000001;
        // list($tmpLat, $tmpLng) = self::GCJtoWGS($gcjLat, $gcjLng);
        // list($tryLat, $tryLng) = self::WGStoGCJ($tmpLat, $tmpLng);
        // list($dLat, $dLng) = array(abs($tmpLat-$tryLat), abs($tmpLng-$tryLng));
        list($dLat, $dLng) = array($initDelta, $initDelta);
        list($mLat, $mLng) = array($gcjLat - $dLat, $gcjLng - $dLng);
        list($pLat, $pLng) = array($gcjLat + $dLat, $gcjLng + $dLng);
        for ($i = 0; $i < 30; $i++) {
            list($wgsLat, $wgsLng) = array(($mLat + $pLat) / 2, ($mLng + $pLng) / 2);
            list($tmpLat, $tmpLng) = self::WGStoGCJ($wgsLat, $wgsLng);
            list($dLat, $dLng) = array($tmpLat - $gcjLat, $tmpLng - $gcjLng);
            if (abs($dLat) < $threshold && abs($dLng) < $threshold) {
                // echo("i:", $i);
                return array($wgsLat, $wgsLng);
            }
            if ($dLat > 0) {
                $pLat = $wgsLat;
            } else {
                $mLat = $wgsLat;
            }
            if ($dLng > 0) {
                $pLng = $wgsLng;
            } else {
                $mLng = $wgsLng;
            }
        }
        return array($wgsLat, $wgsLng);
    }

    // Distance calculate the distance between point(latA, lngA) and point(latB, lngB), unit in meter.
    public static function Distance($latA, $lngA, $latB, $lngB)
    {
        /*const */$earthR = 6371000;
        $x = cos($latA * pi() / 180) * cos($latB * pi() / 180) * cos(($lngA - $lngB) * pi() / 180);
        $y = sin($latA * pi() / 180) * sin($latB * pi() / 180);
        $s = $x + $y;
        if ($s > 1) {
            $s = 1;
        }
        if ($s < -1) {
            $s = -1;
        }
        $alpha = acos($s);
        $distance = $alpha * $earthR;
        return $distance;
    }

}
