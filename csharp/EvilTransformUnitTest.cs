using EvilTransform;
using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace EvilTransformTest
{
    [TestClass]
    public class EvilTransformUnitTest
    {

        Transform transformer = new Transform();
        PointLatLng[][] tests = new PointLatLng[][]{
            new PointLatLng[]{new PointLatLng(31.1774276, 121.5272106), new PointLatLng(31.17530398364597, 121.531541859215)},//shanghai
            new PointLatLng[]{new PointLatLng(22.543847, 113.912316), new PointLatLng(22.540796131694766, 113.9171764808363)},//shenzhen
            new PointLatLng[]{new PointLatLng(39.911954, 116.377817), new PointLatLng(39.91334545536069, 116.38404722455657)},//beijing
        };
        [TestMethod]
        public void TestWGS2GCJ()
        {
            for (int i = 0; i < tests.GetLength(0); i++)
            {
                PointLatLng wgs = tests[i][0];
                PointLatLng gcj = transformer.WGS2GCJ(wgs.Lat, wgs.Lng);
                PointLatLng gcjExpected = tests[i][1];
                Assert.AreEqual(gcjExpected.Lat, gcj.Lat, 0.000001, "WGS2GCJ test " + i + ", Lat:" + gcj.Lat + " != " + gcjExpected.Lat);
                Assert.AreEqual(gcjExpected.Lng, gcj.Lng, 0.000001, "WGS2GCJ test " + i + ", Lng:" + gcj.Lng + " != " + gcjExpected.Lng);
            }
        }

        [TestMethod]
        public void TestGCJ2WGS()
        {
            for (int i = 0; i < tests.GetLength(0); i++)
            {
                PointLatLng wgsExpected = tests[i][0];
                PointLatLng gcj = tests[i][1];
                PointLatLng wgs = transformer.GCJ2WGS(gcj.Lat, gcj.Lng);
                double d = transformer.Distance(wgs.Lat, wgs.Lng, wgsExpected.Lat, wgsExpected.Lng);
                Assert.IsTrue(d < 5, "GCJ2WGS test" + i + ": distance " + d);
            }
        }

        [TestMethod]
        public void TestGCJ2WGSExact()
        {
            for (int i = 0; i < tests.GetLength(0); i++)
            {
                PointLatLng wgsExpected = tests[i][0];
                PointLatLng gcj = tests[i][1];
                PointLatLng wgs = transformer.GCJ2WGSExact(gcj.Lat, gcj.Lng);
                double d = transformer.Distance(wgs.Lat, wgs.Lng, wgsExpected.Lat, wgsExpected.Lng);
                Assert.IsTrue(d < 0.5, "GCJ2WGSExact test" + i + ": distance " + d);
            }
        }
    }
}
