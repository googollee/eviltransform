#include <math.h>
#include <stdlib.h>

#include "transform.h"

#undef INLINE
#if defined(__STDC_VERSION__) && __STDC_VERSION__ >= 199900L
#define INLINE inline
#else
#define INLINE
#endif /* STDC */

#define fabs(x) __ev_fabs(x)
/* do not use >=, or compiler may not know to optimize this with a simple (x & 0x80...0). */
INLINE static double __ev_fabs(double x){ return x > 0.0 ? x : -x; }

INLINE static int outOfChina(double lat, double lng) {
	if (lng < 72.004 || lng > 137.8347) {
		return 1;
	}
	if (lat < 0.8293 || lat > 55.8271) {
		return 1;
	}
	return 0;
}

#define EARTH_R 6371000

void transform(double x, double y, double *lat, double *lng) {
	double xy = x * y;
	double sqrtX = sqrt(fabs(x));
	double xPi = x * M_PI;
	double yPi = y * M_PI;
	double d = 2.0*sin(6.0*xPi) + 2.0*sin(2.0*xPi);

	*lat = d;
	*lng = d;

	*lat += 2.0*sin(yPi) + 4.0*sin(yPi/3.0);
	*lng += 2.0*sin(xPi) + 4.0*sin(xPi/3.0);

	*lat += 16.0*sin(yPi/12.0) + 32.0*sin(yPi/30.0);
	*lng += 15.0*sin(xPi/12.0) + 30.0*sin(xPi/30.0);

	*lat *= 20.0 / 3.0;
	*lng *= 20.0 / 3.0;

	*lat += -100.0 + 2.0*x + 3.0*y + 0.2*y*y + 0.1*xy + 0.2*sqrtX;
	*lng += 300.0 + x + 2.0*y + 0.1*x*x + 0.1*xy + 0.1*sqrtX;
}

static void delta(double lat, double lng, double *dLat, double *dLng) {
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
	const int n_iter = 3;
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

double distance(double latA, double lngA, double latB, double lngB) {
	double arcLatA = latA * M_PI/180;
	double arcLatB = latB * M_PI/180;
	double x = cos(arcLatA) * cos(arcLatB) * cos((lngA-lngB)*M_PI/180);
	double y = sin(arcLatA) * sin(arcLatB);
	double s = x + y;
	if (s > 1) {
		s = 1;
	}
	if (s < -1) {
		s = -1;
	}
	double alpha = acos(s);
	return alpha * EARTH_R;
}
