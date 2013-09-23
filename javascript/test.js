var transform = require('./transform.js');

var tests = [
	// wgsLat, wgsLng, gcjLat, gcjLng
	[31.1774276, 121.5272106, 31.17530398364597, 121.531541859215], // shanghai
	[22.543847, 113.912316, 22.540796131694766, 113.9171764808363], // shenzhen
	[39.911954, 116.377817, 39.91334545536069, 116.38404722455657] // beijing
];

for (var i = 0; i < tests.length; i++) {
	var wgsLat = tests[i][0], wgsLng = tests[i][1];
	var gcj = transform.wgs2gcj(wgsLat, wgsLng);
	var got = gcj.lat.toFixed(6).toString() + "," + gcj.lng.toFixed(6).toString()
	var target = tests[i][2].toFixed(6).toString() + "," + tests[i][3].toFixed(6).toString()
	if (got != target) {
		console.log("wgs2gcj test " + i + ": " + got + " != " + target);
	}
}

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