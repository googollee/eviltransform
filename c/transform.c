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
	double absX = sqrt(fabs(x));
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
	double dLat, dLng;
	// n_iter=2: centimeter precision, n_iter=5: double precision
	const int n_iter = 2;
	int i;
	if ((wgsLat == NULL) || (wgsLng == NULL)) {
		return;
	}
	*wgsLat = gcjLat;
	*wgsLng = gcjLng;
	if (outOfChina(gcjLat, gcjLng)) {
		return;
	}
	for (i = 0; i < n_iter; i++) {
		delta(*wgsLat, *wgsLng, &dLat, &dLng);
		*wgsLat = gcjLat - dLat;
		*wgsLng = gcjLng - dLng;
	}
}

// 1 - cos(x) == 2 sin^2(x/2)
double oneMinusCos(double x)
{
	double s = sin(x/2);
	return s*s*2;
}

double distance(double latA, double lngA, double latB, double lngB) {
	const double earthR = 6371000;
	latA *= M_PI/180;
	latB *= M_PI/180;
	lngA *= M_PI/180;
	lngB *= M_PI/180;
	return 2*earthR*asin(sqrt(oneMinusCos(latA-latB) + cos(latA)*cos(latB)*(oneMinusCos(lngA - lngB)))/M_SQRT2);
}
