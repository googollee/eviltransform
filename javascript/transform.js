var exports
if (typeof module === "object" && exports) {
	exports = module.exports
} else if (typeof window !== "undefined") {
	exports = window["eviltransform"] = {}
}

function outOfChina(lat, lng) {
	if ((lng < 72.004) || (lng > 137.8347)) {
		return true;
	}
	if ((lat < 0.8293) || (lat > 55.8271)) {
		return true;
	}
	return false;
}

function transformLat(x, y) {
	var ret = -100.0 + 2.0*x + 3.0*y + 0.2*y*y + 0.1*x*y + 0.2*Math.sqrt(Math.abs(x));
	ret += (20.0*Math.sin(6.0*x*Math.PI) + 20.0*Math.sin(2.0*x*Math.PI)) * 2.0 / 3.0;
	ret += (20.0*Math.sin(y*Math.PI) + 40.0*Math.sin(y/3.0*Math.PI)) * 2.0 / 3.0;
	ret += (160.0*Math.sin(y/12.0*Math.PI) + 320*Math.sin(y*Math.PI/30.0)) * 2.0 / 3.0;
	return ret;
}

function transformLon(x, y) {
	var ret = 300.0 + x + 2.0*y + 0.1*x*x + 0.1*x*y + 0.1*Math.sqrt(Math.abs(x));
	ret += (20.0*Math.sin(6.0*x*Math.PI) + 20.0*Math.sin(2.0*x*Math.PI)) * 2.0 / 3.0;
	ret += (20.0*Math.sin(x*Math.PI) + 40.0*Math.sin(x/3.0*Math.PI)) * 2.0 / 3.0;
	ret += (150.0*Math.sin(x/12.0*Math.PI) + 300.0*Math.sin(x/30.0*Math.PI)) * 2.0 / 3.0;
	return ret;
}

function delta(lat, lng) {
	var a = 6378245.0;
	var ee = 0.00669342162296594323;
	var dLat = transformLat(lng-105.0, lat-35.0);
	var dLng = transformLon(lng-105.0, lat-35.0);
	var radLat = lat / 180.0 * Math.PI;
	var magic = Math.sin(radLat);
	magic = 1 - ee*magic*magic;
	var sqrtMagic = Math.sqrt(magic);
	dLat = (dLat * 180.0) / ((a * (1 - ee)) / (magic * sqrtMagic) * Math.PI);
	dLng = (dLng * 180.0) / (a / sqrtMagic * Math.cos(radLat) * Math.PI);
	return {"lat": dLat, "lng": dLng};
}

function wgs2gcj(wgsLat, wgsLng) {
	if (outOfChina(wgsLat, wgsLng)) {
		return {"lat": wgsLat, "lng": wgsLng};
	}
	var d = delta(wgsLat, wgsLng);
	return {"lat": wgsLat + d.lat, "lng": wgsLng + d.lng};
}
exports.wgs2gcj = wgs2gcj;

function gcj2wgs(gcjLat, gcjLng) {
	if (outOfChina(gcjLat, gcjLng)) {
		return {"lat": gcjLat, "lng": gcjLng};
	}
	var d = delta(gcjLat, gcjLng);
	return {"lat": gcjLat - d.lat, "lng": gcjLng - d.lng};
}
exports.gcj2wgs = gcj2wgs;

function gcj2wgs_exact(gcjLat, gcjLng) {
	var initDelta = 0.1;
	var threshold = 0.000001;
	var dLat = initDelta, dLng = initDelta;
	var initGuess = gcj2wgs(gcjLat, gcjLng);
	var mLat = initGuess.lat-dLat, mLng = initGuess.lng-dLng;
	var pLat = initGuess.lat+dLat, pLng = initGuess.lng+dLng;
	var wgsLat, wgsLng;
	for (var i = 0; i < 30; i++) {
		wgsLat = (mLat+pLat)/2;
		wgsLng = (mLng+pLng)/2;
		var tmp = wgs2gcj(wgsLat, wgsLng)
		dLat = tmp.lat-gcjLat;
		dLng = tmp.lng-gcjLng;
		if ((Math.abs(dLat) < threshold) && (Math.abs(dLng) < threshold)) {
			return {"lat": wgsLat, "lng": wgsLng};
		}
		if (dLat > 0) {
			pLat = wgsLat;
		} else {
			mLat = wgsLat;
		}
		if (dLng > 0) {
			pLng = wgsLng;
		} else {
			mLng = wgsLng;
		}
	}
	return {"lat": wgsLat, "lng": wgsLng};
}
exports.gcj2wgs_exact = gcj2wgs_exact;

function distance(latA, lngA, latB, lngB) {
	var earthR = 6371000;
	var x = Math.cos(latA*Math.PI/180) * Math.cos(latB*Math.PI/180) * Math.cos((lngA-lngB)*Math.PI/180);
	var y = Math.sin(latA*Math.PI/180) * Math.sin(latB*Math.PI/180);
	var s = x + y;
	if (s > 1) {
		s = 1;
	}
	if (s < -1) {
		s = -1;
	}
	var alpha = Math.acos(s);
	var distance = alpha * earthR;
	return distance;
}
exports.distance = distance;

function gcj2bd(gcjLat, gcjLng) {
	if (outOfChina(gcjLat, gcjLng)) {
		return {"lat": gcjLat, "lng": gcjLng};
	}

	var x = gcjLng, y = gcjLat;
	var z = Math.sqrt(x * x + y * y) + 0.00002 * Math.sin(y * Math.PI);
	var theta = Math.atan2(y, x) + 0.000003 * Math.cos(x * Math.PI);
	var bdLng = z * Math.cos(theta) + 0.0065;
	var bdLat = z * Math.sin(theta) + 0.006;
	return {"lat": bdLat, "lng": bdLng};
}
exports.gcj2bd = gcj2bd;

function bd2gcj(bdLat, bdLng) {
	if (outOfChina(bdLat, bdLng)) {
		return {"lat": bdLat, "lng": bdLng};
	}

	var x = bdLng - 0.0065, y = bdLat - 0.006;
	var z = Math.sqrt(x * x + y * y) - 0.00002 * Math.sin(y * Math.PI);
	var theta = Math.atan2(y, x) - 0.000003 * Math.cos(x * Math.PI);
	var gcjLng = z * Math.cos(theta);
	var gcjLat = z * Math.sin(theta);
	return {"lat": gcjLat, "lng": gcjLng};
}
exports.bd2gcj = bd2gcj;

function wgs2bd(wgsLat, wgsLng) {
	var gcj = wgs2gcj(wgsLat, wgsLng)
	return gcj2bd(gcj.lat, gcj.lng)
}
exports.wgs2bd = wgs2bd;

function bd2wgs(bdLat, bdLng) {
	var gcj = bd2gcj(bdLat, bdLng)
	return gcj2wgs(gcj.lat, gcj.lng)
}
exports.bd2wgs = bd2wgs;
