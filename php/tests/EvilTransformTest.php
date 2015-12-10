<?php

namespace larryli\eviltransform\tests;

use larryli\eviltransform\EvilTransform;
use PHPUnit_Framework_TestCase;

/**
 * Class EvilTransformTest
 * @package larryli\eviltransform\tests
 */
class EvilTransformTest extends PHPUnit_Framework_TestCase
{
    private $tests;

    protected function setUp()
    {
        $this->tests = array(
            new EvilTransformTest_Test(31.1774276, 121.5272106, 31.17530398364597, 121.531541859215), // shanghai
            new EvilTransformTest_Test(22.543847, 113.912316, 22.540796131694766, 113.9171764808363), // shenzhen
            new EvilTransformTest_Test(39.911954, 116.377817, 39.91334545536069, 116.38404722455657), // beijing)
        );
    }

    protected function tearDown()
    {
        $this->tests = array();
    }

    private function latLngToString($lat, $lng)
    {
        return sprintf("%.5f,%.5f", $lat, $lng);
    }

    public function testWtoG()
    {
        foreach ($this->tests as $i => $test) {
            list($gcjLat, $gcjLng) = EvilTransform::WGStoGCJ($test->wgsLat, $test->wgsLng);
            $got = self::latLngToString($gcjLat, $gcjLng);
            $target = self::latLngToString($test->gcjLat, $test->gcjLng);
            $this->assertEquals($got, $target, "test {$i}");
        }
    }

    public function testGtoW()
    {
        foreach ($this->tests as $i => $test) {
            list($wgsLat, $wgsLng) = EvilTransform::GCJtoWGS($test->gcjLat, $test->gcjLng);
            $d = EvilTransform::Distance($wgsLat, $wgsLng, $test->wgsLat, $test->wgsLng);
            $this->assertEquals($d < 5, true, "test {$i}, distance: {$d}");
        }
    }

    public function testGtoWExact()
    {
        foreach ($this->tests as $i => $test) {
            list($wgsLat, $wgsLng) = EvilTransform::GCJtoWGSExact($test->gcjLat, $test->gcjLng);
            $d = EvilTransform::Distance($wgsLat, $wgsLng, $test->wgsLat, $test->wgsLng);
            $this->assertEquals($d < 0.5, true, "test {$i}, distance: {$d}");
        }
    }
}

/**
 * Class EvilTransformTest_Test
 * @package larryli\eviltransform\tests
 */
class EvilTransformTest_Test
{
    public $wgsLat, $wgsLng;
    public $gcjLat, $gcjLng;

    public function __construct($wgsLat, $wgsLng, $gcjLat, $gcjLng)
    {
        $this->wgsLat = $wgsLat;
        $this->wgsLng = $wgsLng;
        $this->gcjLat = $gcjLat;
        $this->gcjLng = $gcjLng;
    }
}
