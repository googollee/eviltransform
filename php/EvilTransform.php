<?php

namespace larryli\eviltransform;

/**
 * Package transform coordinate between earth(WGS-84) and mars in china(GCJ-02).
 * @package larryli\eviltransform
 */
class EvilTransform
{
    /**
     * outOfChina
     * @param float $lat
     * @param float $lng
     * @return bool
     */
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

    /**
     * transform
     * @param float $x
     * @param float $y
     * @return float[]
     */
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

        return [$lat, $lng];
    }

    /**
     * delta
     * @param float $lat
     * @param float $lng
     * @return float[] [$lat, $lng]
     */
    private static function delta($lat, $lng)
    {
        $a = 6378137.0;
        $ee = 0.00669342162296594323;
        list($dLat, $dLng) = self::transform($lng - 105.0, $lat - 35.0);
        $radLat = $lat / 180.0 * pi();
        $magic = sin($radLat);
        $magic = 1 - $ee * $magic * $magic;
        $sqrtMagic = sqrt($magic);
        $dLat = ($dLat * 180.0) / (($a * (1 - $ee)) / ($magic * $sqrtMagic) * pi());
        $dLng = ($dLng * 180.0) / ($a / $sqrtMagic * cos($radLat) * pi());
        return [$dLat, $dLng];
    }

    /**
     * WGStoGCJ convert WGS-84 coordinate(wgsLat, wgsLng) to GCJ-02 coordinate(gcjLat, gcjLng).
     * @param float $wgsLat
     * @param float $wgsLng
     * @return float[] [$gcjLat, $gcjLng]
     */
    public static function WGStoGCJ($wgsLat, $wgsLng)
    {
        if (self::outOfChina($wgsLat, $wgsLng)) {
            return [$wgsLat, $wgsLng];
        }
        list($dLat, $dLng) = self::delta($wgsLat, $wgsLng);
        return [$wgsLat + $dLat, $wgsLng + $dLng];
    }

    /**
     * GCJtoWGS convert GCJ-02 coordinate(gcjLat, gcjLng) to WGS-84 coordinate(wgsLat, wgsLng).
     *
     * The output WGS-84 coordinate's accuracy is 1m to 2m. If you want more exactly result, use GCJtoWGSExact/gcj2wgs_exact.
     * @param float $gcjLat
     * @param float $gcjLng
     * @return float[] [$wgsLat, $wgsLng]
     */
    public static function GCJtoWGS($gcjLat, $gcjLng)
    {
        if (self::outOfChina($gcjLat, $gcjLng)) {
            return [$gcjLat, $gcjLng];
        }
        list($dLat, $dLng) = self::delta($gcjLat, $gcjLng);
        return [$gcjLat - $dLat, $gcjLng - $dLng];
    }

    /**
     * GCJtoWGSExact convert GCJ-02 coordinate(gcjLat, gcjLng) to WGS-84 coordinate(wgsLat, wgsLng).
     *
     * The output WGS-84 coordinate's accuracy is less than 0.5m, but much slower than GCJtoWGS/gcj2wgs.
     * @param float $gcjLat
     * @param float $gcjLng
     * @return float[] [$wgsLat, $wgsLng]
     */
    public static function GCJtoWGSExact($gcjLat, $gcjLng)
    {
        $initDelta = 0.01;
        $threshold = 0.000001;
        // list($tmpLat, $tmpLng) = self::GCJtoWGS($gcjLat, $gcjLng);
        // list($tryLat, $tryLng) = self::WGStoGCJ($tmpLat, $tmpLng);
        // list($dLat, $dLng) = [abs($tmpLat-$tryLat), abs($tmpLng-$tryLng)];
        list($dLat, $dLng) = [$initDelta, $initDelta];
        list($mLat, $mLng) = [$gcjLat - $dLat, $gcjLng - $dLng];
        list($pLat, $pLng) = [$gcjLat + $dLat, $gcjLng + $dLng];
        list($wgsLat, $wgsLng) = [false, false];
        for ($i = 0; $i < 30; $i++) {
            list($wgsLat, $wgsLng) = [($mLat + $pLat) / 2, ($mLng + $pLng) / 2];
            list($tmpLat, $tmpLng) = self::WGStoGCJ($wgsLat, $wgsLng);
            list($dLat, $dLng) = [$tmpLat - $gcjLat, $tmpLng - $gcjLng];
            if (abs($dLat) < $threshold && abs($dLng) < $threshold) {
                // echo("i:", $i);
                return [$wgsLat, $wgsLng];
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
        return [$wgsLat, $wgsLng];
    }

    /**
     * Distance calculate the distance between point(latA, lngA) and point(latB, lngB), unit in meter.
     * @param float $latA lat of the point A
     * @param float $lngA lng of the point A
     * @param float $latB lat of the point B
     * @param float $lngB lng of the point B
     * @return float distance, unit in meter
     */
    public static function Distance($latA, $lngA, $latB, $lngB)
    {
        $earthR = 6371000;
        $latA *= pi() / 180;
        $lngA *= pi() / 180;
        $latB *= pi() / 180;
        $lngB *= pi() / 180;
        $x = cos($latA) * cos($latB) * cos($lngA - $lngB);
        $y = sin($latA) * sin($latB);
        $s = $x + $y;
        if ($s > 1) {
            $s = 1;
        }
        if ($s < -1) {
            $s = -1;
        }
        return acos($s) * $earthR;
    }
}
