using System;

namespace EvilTransform
{
    public struct PointLatLng
    {
        public double Lat;
        public double Lng;

        public PointLatLng(double lat, double lng)
        {
            this.Lat = lat;
            this.Lng = lng;
        }
    }
    class Transform
    {
        bool OutOfChina(double lat, double lng)
        {
            if ((lng < 72.004) || (lng > 137.8347))
            {
                return true;
            }
            if ((lat < 0.8293) || (lat > 55.8271))
            {
                return true;
            }
            return false;
        }

        double TransformLat(double x, double y)
        {
            double ret = -100.0 + 2.0 * x + 3.0 * y + 0.2 * y * y + 0.1 * x * y + 0.2 * Math.Sqrt(Math.Abs(x));
            ret += (20.0 * Math.Sin(6.0 * x * Math.PI) + 20.0 * Math.Sin(2.0 * x * Math.PI)) * 2.0 / 3.0;
            ret += (20.0 * Math.Sin(y * Math.PI) + 40.0 * Math.Sin(y / 3.0 * Math.PI)) * 2.0 / 3.0;
            ret += (160.0 * Math.Sin(y / 12.0 * Math.PI) + 320 * Math.Sin(y * Math.PI / 30.0)) * 2.0 / 3.0;
            return ret;
        }

        double TransformLon(double x, double y)
        {
            double ret = 300.0 + x + 2.0 * y + 0.1 * x * x + 0.1 * x * y + 0.1 * Math.Sqrt(Math.Abs(x));
            ret += (20.0 * Math.Sin(6.0 * x * Math.PI) + 20.0 * Math.Sin(2.0 * x * Math.PI)) * 2.0 / 3.0;
            ret += (20.0 * Math.Sin(x * Math.PI) + 40.0 * Math.Sin(x / 3.0 * Math.PI)) * 2.0 / 3.0;
            ret += (150 * Math.Sin(x / 12.0 * Math.PI) + 300.0 * Math.Sin(x / 30.0 * Math.PI)) * 2.0 / 3.0;
            return ret;
        }

        PointLatLng Delta(double lat, double lng)
        {
            PointLatLng ret = new PointLatLng();
            double a = 6378137.0;
            double ee = 0.00669342162296594323;
            double dLat = TransformLat(lng - 105.0, lat - 35.0);
            double dLng = TransformLon(lng - 105.0, lat - 35.0);
            double radLat = lat / 180.0 * Math.PI;
            double magic = Math.Sin(radLat);
            magic = 1 - ee * magic * magic;
            double sqrtMagic = Math.Sqrt(magic);
            dLat = (dLat * 180.0) / ((a * (1 - ee)) / (magic * sqrtMagic) * Math.PI);
            dLng = (dLng * 180.0) / (a / sqrtMagic * Math.Cos(radLat) * Math.PI);
            ret.Lat = dLat;
            ret.Lng = dLng;
            return ret;
        }

        public PointLatLng WGS2GCJ(double wgsLat, double wgsLng)
        {
            if (OutOfChina(wgsLat, wgsLng))
            {
                return new PointLatLng(wgsLat, wgsLng);
            }
            PointLatLng d = Delta(wgsLat, wgsLng);
            return new PointLatLng(wgsLat + d.Lat, wgsLng + d.Lng);
        }

        public PointLatLng GCJ2WGS(double gcjLat, double gcjLng)
        {
            if (OutOfChina(gcjLat, gcjLng))
            {
                return new PointLatLng(gcjLat, gcjLng);
            }
            PointLatLng d = Delta(gcjLat, gcjLng);
            return new PointLatLng(gcjLat - d.Lat, gcjLng - d.Lng);
        }

        public PointLatLng GCJ2WGSExact(double gcjLat, double gcjLng)
        {
            double initDelta = 0.01;
            double threshold = 0.000001;
            double dLat = initDelta;
            double dLng = initDelta;
            double mLat = gcjLat - dLat;
            double mLng = gcjLng - dLng;
            double pLat = gcjLat + dLat;
            double pLng = gcjLng + dLng;
            double wgsLat = 0;
            double wgsLng = 0;

            for (int i = 0; i < 30; i++)
            {
                wgsLat = (mLat + pLat) / 2;
                wgsLng = (mLng + pLng) / 2;
                PointLatLng tmp = WGS2GCJ(wgsLat, wgsLng);
                dLat = tmp.Lat - gcjLat;
                dLng = tmp.Lng - gcjLng;
                if ((Math.Abs(dLat) < threshold) && (Math.Abs(dLng) < threshold))
                {
                    return new PointLatLng(wgsLat, wgsLng);
                }
                if (dLat > 0)
                {
                    pLat = wgsLat;
                }
                else
                {
                    mLat = wgsLat;
                }
                if (dLng > 0)
                {
                    pLng = wgsLng;
                }
                else
                {
                    mLng = wgsLng;
                }
            }
            return new PointLatLng(wgsLat, wgsLng);
        }

        public double Distance(double latA, double lngA, double latB, double lngB)
        {
            double earthR = 6371000;
            double x = Math.Cos(latA * Math.PI / 180) * Math.Cos(latB * Math.PI / 180) * Math.Cos((lngA - lngB) * Math.PI / 180);
            double y = Math.Sin(latA * Math.PI / 180) * Math.Sin(latB * Math.PI / 180);
            double s = x + y;
            if (s > 1)
                s = 1;
            if (s < -1)
                s = -1;
            double alpha = Math.Acos(s);
            var distance = alpha * earthR;
            return distance;
        }
    }
}
