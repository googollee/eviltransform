#include <math.h>
#include <stdlib.h>

#include "transform.h"

int outOfChina(double lat, double lng) {
	if (lng < 72.004 || lng > 137.8347) {
		return 1;
	}
	if (lat < 0.8293 || lat > 55.8271) {
		return 1;
	}
	return 0;
}

void transform(double x, double y, double *lat, double *lng) {
	double xy = x * y;
	double absX = sqrt(abs(x));
	double d = (20.0*sin(6.0*x*M_PI) + 20.0*sin(2.0*x*M_PI)) * 2.0 / 3.0;

	*lat = -100.0 + 2.0*x + 3.0*y + 0.2*y*y + 0.1*xy + 0.2*absX;
	*lng = 300.0 + x + 2.0*y + 0.1*x*x + 0.1*xy + 0.1*absX;

	*lat += d;
	*lng += d;

	*lat += (20.0*sin(y*M_PI) + 40.0*sin(y/3.0*M_PI)) * 2.0 / 3.0;
	*lng += (20.0*sin(x*M_PI) + 40.0*sin(x/3.0*M_PI)) * 2.0 / 3.0;

	*lat += (160.0*sin(y/12.0*M_PI) + 320*sin(y/30.0*M_PI)) * 2.0 / 3.0;
	*lng += (150.0*sin(x/12.0*M_PI) + 300.0*sin(x/30.0*M_PI)) * 2.0 / 3.0;
}

void delta(double lat, double lng, double *dLat, double *dLng) {
	if ((dLat == NULL) || (dLng == NULL)) {
		return;
	}
	const double a = 6378245.0;
	const double ee = 0.00669342162296594323;
	transform(lng-105.0, lat-35.0, dLat, dLng);
	double radLat = lat / 180.0 * M_PI;
	double magic = sin(radLat);
	magic = 1 - ee*magic*magic;
	double sqrtMagic = sqrt(magic);
	*dLat = (*dLat * 180.0) / ((a * (1 - ee)) / (magic * sqrtMagic) * M_PI);
	*dLng = (*dLng * 180.0) / (a / sqrtMagic * cos(radLat) * M_PI);
}

void wgs2gcj(double wgsLat, double wgsLng, double *gcjLat, double *gcjLng) {
	if ((gcjLat == NULL) || (gcjLng == NULL)) {
		return;
	}
	if (outOfChina(wgsLat, wgsLng)) {
		*gcjLat = wgsLat;
		*gcjLng = wgsLng;
		return;
	}
	double dLat, dLng;
	delta(wgsLat, wgsLng, &dLat, &dLng);
	*gcjLat = wgsLat + dLat;
	*gcjLng = wgsLng + dLng;
}

void gcj2wgs(double gcjLat, double gcjLng, double *wgsLat, double *wgsLng) {
	if ((wgsLat == NULL) || (wgsLng == NULL)) {
		return;
	}
	if (outOfChina(gcjLat, gcjLng)) {
		*wgsLat = gcjLat;
		*wgsLng = gcjLng;
		return;
	}
	double dLat, dLng;
	delta(gcjLat, gcjLng, &dLat, &dLng);
	*wgsLat = gcjLat - dLat;
	*wgsLng = gcjLng - dLng;
}

void gcj2wgs_exact(double gcjLat, double gcjLng, double *wgsLat, double *wgsLng) {
	const double initDelta = 0.01;
	const double threshold = 0.000001;
	double dLat = initDelta, dLng = initDelta;
	double mLat = gcjLat-dLat, mLng = gcjLng-dLng;
	double pLat = gcjLat+dLat, pLng = gcjLng+dLng;
	int i;
	for (i = 0; i < 30; i++) {
		*wgsLat = (mLat+pLat)/2;
		*wgsLng = (mLng+pLng)/2;
		double tmpLat, tmpLng;
		wgs2gcj(*wgsLat, *wgsLng, &tmpLat, &tmpLng);
		dLat = tmpLat - gcjLat;
		dLng = tmpLng - gcjLng;
		if ((fabs(dLat) < threshold) && (fabs(dLng) < threshold)) {
			return;
		}
		if (dLat > 0) {
			pLat = *wgsLat;
		} else {
			mLat = *wgsLat;
		}
		if (dLng > 0) {
			pLng = *wgsLng;
		} else {
			mLng = *wgsLng;
		}
	}
}

double distance(double latA, double lngA, double latB, double lngB) {
	const double earthR = 6371000;
	double x = cos(latA*M_PI/180) * cos(latB*M_PI/180) * cos((lngA-lngB)*M_PI/180);
	double y = sin(latA*M_PI/180) * sin(latB*M_PI/180);
	double s = x + y;
	if (s > 1) {
		s = 1;
	}
	if (s < -1) {
		s = -1;
	}
	double alpha = acos(s);
	double distance = alpha * earthR;
	return distance;
}
