#include <stdio.h>
#include <string.h>
#include <time.h>

#include "transform.h"

double tests[][4] = {
	// wgsLat, wgsLng, gcjLat, gcjLng
	{31.1774276, 121.5272106, 31.17530398364597, 121.531541859215}, // shanghai
	{22.543847, 113.912316, 22.540796131694766, 113.9171764808363}, // shenzhen
	{39.911954, 116.377817, 39.91334545536069, 116.38404722455657}, // beijing
};

int main() {
	size_t s = sizeof(tests) / sizeof(tests[0]);
	int i;

	for (i = 0; i < s; i++) {
		double wgsLat = tests[i][0], wgsLng = tests[i][1];
		double gcjLat, gcjLng;
		wgs2gcj(wgsLat, wgsLng, &gcjLat, &gcjLng);
		char got[1024], target[1024];
		sprintf(got, "%.06f,%.06f", gcjLat, gcjLng);
		sprintf(target, "%.06f,%.06f", tests[i][2], tests[i][3]);
		if (strcmp(got, target) != 0) {
			printf("wgs2gcj test %d: %s != %s\n", i, got, target);
		}
	}

	for (i = 0; i < s; i++) {
		double gcjLat = tests[i][2], gcjLng = tests[i][3];
		double wgsLat, wgsLng;
		gcj2wgs(gcjLat, gcjLng, &wgsLat, &wgsLng);
		double d = distance(wgsLat, wgsLng, tests[i][0], tests[i][1]);
		if (d > 5) {
			printf("gcj2wgs test %d: distance %f\n", i, d);
		}
	}

	for (i = 0; i < s; i++) {
		double gcjLat = tests[i][2], gcjLng = tests[i][3];
		double wgsLat, wgsLng;
		gcj2wgs_exact(gcjLat, gcjLng, &wgsLat, &wgsLng);
		double d = distance(wgsLat, wgsLng, tests[i][0], tests[i][1]);
		if (d > 0.5) {
			printf("gcj2wgs_exact test %d: distance %f\n", i, d);
		}
	}

	clock_t b;
	clock_t e;
	double lat, lng;
	int n, t;

	b = clock();
	for (i = 0; i < 10; i++) {
		wgs2gcj(tests[0][0], tests[0][1], &lat, &lng);
	}
	e = clock();
	n = (int)(CLOCKS_PER_SEC / (e - b)) * 10;
	b = clock();
	for (i = 0; i < n; i++) {
		wgs2gcj(tests[0][0], tests[0][1], &lat, &lng);
	}
	e = clock();
	t = (int)(((double)(e - b) / CLOCKS_PER_SEC) * 1e9 / n);
	printf("wgs2gcj\t%d\t%d ns/op\n", n, t);

	b = clock();
	for (i = 0; i < 10; i++) {
		gcj2wgs(tests[0][0], tests[0][1], &lat, &lng);
	}
	e = clock();
	n = (int)(CLOCKS_PER_SEC / (e - b)) * 10;
	b = clock();
	for (i = 0; i < n; i++) {
		gcj2wgs(tests[0][0], tests[0][1], &lat, &lng);
	}
	e = clock();
	t = (int)(((double)(e - b) / CLOCKS_PER_SEC) * 1e9 / n);
	printf("gcj2wgs\t%d\t%d ns/op\n", n, t);

	b = clock();
	for (i = 0; i < 10; i++) {
		gcj2wgs_exact(tests[0][0], tests[0][1], &lat, &lng);
	}
	e = clock();
	n = (int)(CLOCKS_PER_SEC / (e - b)) * 10;
	b = clock();
	for (i = 0; i < n; i++) {
		gcj2wgs_exact(tests[0][0], tests[0][1], &lat, &lng);
	}
	e = clock();
	t = (int)(((double)(e - b) / CLOCKS_PER_SEC) * 1e9 / n);
	printf("gcj2wgs_exact\t%d\t%d ns/op\n", n, t);

	b = clock();
	for (i = 0; i < 10; i++) {
		distance(tests[0][0], tests[0][1], tests[0][2], tests[0][3]);
	}
	e = clock();
	n = (int)(CLOCKS_PER_SEC / (e - b)) * 10;
	b = clock();
	for (i = 0; i < n; i++) {
		distance(tests[0][0], tests[0][1], tests[0][2], tests[0][3]);
	}
	e = clock();
	t = (int)(((double)(e - b) / CLOCKS_PER_SEC) * 1e9 / n);
	printf("distance\t%d\t%d ns/op\n", n, t);
}