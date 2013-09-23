#ifndef TRANSFORM_HEADER
#define TRANSFORM_HEADER

void wgs2gcj(double wgsLat, double wgsLng, double *gcjLat, double *gcjLng);
void gcj2wgs(double gcjLat, double gcjLng, double *wgsLat, double *wgsLnt);
void gcj2wgs_exact(double gcjLat, double gcjLng, double *wgsLat, double *wgsLnt);
double distance(double latA, double lngA, double latB, double lngB);

#endif