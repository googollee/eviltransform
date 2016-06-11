"use strict";

var transform = require('./transform.js');

var tests = [
	// wgsLat, wgsLng, gcjLat, gcjLng
	[31.1774276, 121.5272106, 31.17530398364597, 121.531541859215], // shanghai
	[22.543847, 113.912316, 22.540796131694766, 113.9171774808363], // shenzhen
	[39.911954, 116.377817, 39.91334545536069, 116.38404722455657] // beijing
];

var bdTests = [
	// bdLat, bdLng, wgsLat, wgsLng
	[29.199786, 120.019809, 29.196131605295484, 120.00877901149691],
	[29.210504, 120.036455, 29.206795749156136, 120.0253853970846],
];

function testForward(tests, method) {
	for (var i = 0; i < tests.length; i++) {
		var lat = tests[i][0], lng = tests[i][1];
		var ret = transform[method](lat, lng);
		var got = ret.lat.toFixed(6).toString() + "," + ret.lng.toFixed(6).toString()
		var target = tests[i][2].toFixed(6).toString() + "," + tests[i][3].toFixed(6).toString()
		if (got != target) {
			console.log(method+" test " + i + ": " + got + " != " + target);
		}
	}
}

testForward(tests, "wgs2gcj")
testForward(bdTests, "bd2wgs")

for (var i = 0; i < tests.length; i++) {
	var gcjLat = tests[i][2], gcjLng = tests[i][3];
	var wgs = transform.gcj2wgs(gcjLat, gcjLng);
	var d = transform.distance(wgs.lat, wgs.lng, tests[i][0], tests[i][1]);
	if (d > 5) {
		console.log("gcj2wgs test " + i + ": distance" + d);
	}
}

for (var i = 0; i < tests.length; i++) {
	var gcjLat = tests[i][2], gcjLng = tests[i][3];
	var wgs = transform.gcj2wgs_exact(gcjLat, gcjLng);
	var d = transform.distance(wgs.lat, wgs.lng, tests[i][0], tests[i][1]);
	if (d > 0.5) {
		console.log("gcj2wgs_exact test " + i + ": distance" + d);
	}
}

var b, e, n, t, j;

b = new Date().getTime();
for (var i = 0; i < 100000; i++) {
	transform.wgs2gcj(tests[0][0], tests[0][1]);
}
e = new Date().getTime();
n = (1000 / (e - b) * 100000).toFixed(0);
b = new Date().getTime();
for (var i = 0; i < n; i++) {
	transform.wgs2gcj(tests[0][0], tests[0][1]);
}
e = new Date().getTime();
t = (e - b) * 1e6 / n;
console.log("wgs2gcj\t" + n + "\t" + t.toFixed(0) + " ns/op");

b = new Date().getTime();
for (var i = 0; i < 100000; i++) {
	transform.gcj2wgs(tests[0][0], tests[0][1]);
}
e = new Date().getTime();
n = (1000 / (e - b) * 100000).toFixed(0);
b = new Date().getTime();
for (var i = 0; i < n; i++) {
	transform.gcj2wgs(tests[0][0], tests[0][1]);
}
e = new Date().getTime();
t = (e - b) * 1e6 / n;
console.log("gcj2wgs\t" + n + "\t" + t.toFixed(0) + " ns/op");

b = new Date().getTime();
for (var i = 0; i < 100000; i++) {
	transform.gcj2wgs_exact(tests[0][0], tests[0][1]);
}
e = new Date().getTime();
n = (1000 / (e - b) * 100000).toFixed(0);
b = new Date().getTime();
for (var i = 0; i < n; i++) {
	transform.gcj2wgs_exact(tests[0][0], tests[0][1]);
}
e = new Date().getTime();
t = (e - b) * 1e6 / n;
console.log("gcj2wgs_exact\t" + n + "\t" + t.toFixed(0) + " ns/op");

b = new Date().getTime();
for (var i = 0; i < 100000; i++) {
	transform.distance(tests[0][0], tests[0][1], tests[0][2], tests[0][3]);
}
e = new Date().getTime();
n = (1000 / (e - b) * 100000).toFixed(0);
b = new Date().getTime();
for (var i = 0; i < n; i++) {
	transform.distance(tests[0][0], tests[0][1], tests[0][2], tests[0][3]);
}
e = new Date().getTime();
t = (e - b) * 1e6 / n;
console.log("distance\t" + n + "\t" + t.toFixed(0) + " ns/op");
