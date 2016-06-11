use std::f64::consts::PI;

const EARTH_R: f64 = 6378137.0;

fn out_of_china(lat: f64, lng: f64) -> bool {
    if lng < 72.004 || lng > 137.8347 {
        return true
    }
    if lat < 0.8293 || lat > 55.8271 {
        return true
    }
    false
}

fn transform(x: f64, y: f64) -> (f64, f64) {
	let xy = x * y;
	let abs_x = x.abs().sqrt();
	let x_pi = x * PI;
	let y_pi = y * PI;
	let d = 20.0*(6.0*x_pi).sin() + 20.0*(2.0*x_pi).sin();

	let mut lat = d;
	let mut lng = d;

	lat += 20.0*(y_pi).sin() + 40.0*(y_pi/3.0).sin();
	lng += 20.0*(x_pi).sin() + 40.0*(x_pi/3.0).sin();

	lat += 160.0*(y_pi/12.0).sin() + 320.0*(y_pi/30.0).sin();
	lng += 150.0*(x_pi/12.0).sin() + 300.0*(x_pi/30.0).sin();

	lat *= 2.0 / 3.0;
	lng *= 2.0 / 3.0;

	lat += -100.0 + 2.0*x + 3.0*y + 0.2*y*y + 0.1*xy + 0.2*abs_x;
	lng += 300.0 + x + 2.0*y + 0.1*x*x + 0.1*xy + 0.1*abs_x;

	(lat, lng)
}

fn delta(lat: f64, lng: f64) -> (f64, f64) {
	let ee = 0.00669342162296594323;
	let (d_lat, d_lng) = transform(lng-105.0, lat-35.0);
    let mut d_lat = d_lat;
    let mut d_lng = d_lng;
	let rad_lat = lat / 180.0 * PI;
	let mut magic = (rad_lat).sin();
	magic = 1.0 - ee*magic*magic;
	let sqrt_magic = (magic).sqrt();
	d_lat = (d_lat * 180.0) / ((EARTH_R * (1.0 - ee)) / (magic * sqrt_magic) * PI);
	d_lng = (d_lng * 180.0) / (EARTH_R / sqrt_magic * (rad_lat).cos() * PI);
	(d_lat, d_lng)
}

// wgs2gcj convert WGS-84 coordinate(wgs_lat, wgs_lng) to GCJ-02 coordinate.
pub fn wgs2gcj(wgs_lat: f64, wgs_lng: f64) -> (f64, f64) {
	if out_of_china(wgs_lat, wgs_lng) {
		return (wgs_lat, wgs_lng)
	}
	let (d_lat, d_lng) = delta(wgs_lat, wgs_lng);
    (wgs_lat+d_lat, wgs_lng+d_lng)
}

// gcj2wgs convert GCJ-02 coordinate(gcj_lat, gcj_lng) to WGS-84 coordinate.
// The output WGS-84 coordinate's accuracy is 1m to 2m. If you want more exactly result, use gcj2wgs_exact.
pub fn gcj2wgs(gcj_lat: f64, gcj_lng: f64) -> (f64, f64) {
	if out_of_china(gcj_lat, gcj_lng) {
		return (gcj_lat, gcj_lng);
	}
	let (d_lat, d_lng) = delta(gcj_lat, gcj_lng);
	(gcj_lat-d_lat, gcj_lng-d_lng)
}

// gcj2wgs_exact convert GCJ-02 coordinate(gcj_lat, gcj_lng) to WGS-84 coordinate.
// The output WGS-84 coordinate's accuracy is less than 0.5m, but much slower than gcj2wgs.
pub fn gcj2wgs_exact(gcj_lat: f64, gcj_lng: f64) -> (f64, f64) {
	const INIT_DELTA: f64 = 0.01;
	const THRESHOLD: f64 = 0.000001;
	let mut d_lat = INIT_DELTA;
	let mut d_lng = INIT_DELTA;
    let mut m_lat = gcj_lat - d_lat;
    let mut m_lng = gcj_lng - d_lng;
    let mut p_lat = gcj_lat + d_lat;
    let mut p_lng = gcj_lng + d_lng;

	for _ in 0..30 {
		let (wgs_lat, wgs_lng) = ( (m_lat+p_lat)/2.0, (m_lng+p_lng)/2.0 );
		let (tmp_lat, tmp_lng) = wgs2gcj(wgs_lat, wgs_lng);
		d_lat = tmp_lat-gcj_lat;
		d_lng = tmp_lng-gcj_lng;
		if d_lat.abs() < THRESHOLD && d_lng.abs() < THRESHOLD {
			return (wgs_lat, wgs_lng);
		}
		if d_lat > 0.0 {
			p_lat = wgs_lat;
		} else {
			m_lat = wgs_lat;
		}
		if d_lng > 0.0 {
			p_lng = wgs_lng;
		} else {
			m_lng = wgs_lng;
		}
	}
	( (m_lat+p_lat)/2.0, (m_lng+p_lng)/2.0 )
}

// distance calculate the distance between point(lat_a, lng_a) and point(lat_b, lng_b), unit in meter.
pub fn distance(lat_a: f64, lng_a: f64, lat_b: f64, lng_b: f64) -> f64 {
	let arc_lat_a = lat_a * PI / 180.0;
	let arc_lat_b = lat_b * PI / 180.0;
	let x = (arc_lat_a).cos() * (arc_lat_b).cos() * ((lng_a-lng_b)*PI/180.0).cos();
	let y = (arc_lat_a).sin() * (arc_lat_b).sin();
	let mut s = x + y;
	if s > 1.0 {
		s = 1.0
	}
	if s < -1.0 {
		s = -1.0
	}
	let alpha = s.acos();
    alpha * EARTH_R
}

#[cfg(test)]
mod tests {
    #[test]
    fn test_distance() {
    	struct Test {
    		a_lat: f64,
            a_lng: f64,
    		b_lat: f64,
            b_lng: f64,
    		distance: f64,
    	}
        const TESTS: [Test; 1] = [
    		Test{a_lat:31.17530398364597, a_lng:121.531541859215, b_lat:39.91334545536069, b_lng:116.38404722455657, distance:1078164.0}, // shanghai to beijing
    	];
    	for test in TESTS.iter() {
    		let d = super::distance(test.a_lat, test.a_lng, test.b_lat, test.b_lng);
    		let delta = (d - test.distance).abs();
    		assert!(delta < 1.0)
    	}
    }

    struct Test {
        wgs_lat: f64,
        wgs_lng: f64,
        gcj_lat: f64,
        gcj_lng: f64,
    }

    const TESTS: [Test; 3] = [
    	Test{wgs_lat: 31.1774276, wgs_lng: 121.5272106, gcj_lat: 31.17530398364597, gcj_lng: 121.531541859215}, // shanghai
    	Test{wgs_lat: 22.543847, wgs_lng: 113.912316, gcj_lat: 22.540796131694766, gcj_lng: 113.9171764808363}, // shenzhen
    	Test{wgs_lat: 39.911954, wgs_lng: 116.377817, gcj_lat: 39.91334545536069, gcj_lng: 116.38404722455657}, // beijing
    ];

    fn to_string(lat: f64, lng: f64) -> String {
        format!("{:.5},{:.5}", lat, lng)
    }

    #[test]
    fn test_wgs2gcj() {
        for test in TESTS.iter() {
            let (gcj_lat, gcj_lng) = super::wgs2gcj(test.wgs_lat, test.wgs_lng);
            let got = to_string(gcj_lat, gcj_lng);
            let target = to_string(test.gcj_lat, test.gcj_lng);
            assert!(got == target)
        }
    }

    #[test]
    fn test_gcj2wgs() {
    	for test in TESTS.iter() {
    		let (wgs_lat, wgs_lng) = super::gcj2wgs(test.gcj_lat, test.gcj_lng);
    		let d = super::distance(wgs_lat, wgs_lng, test.wgs_lat, test.wgs_lng);
    		assert!(d < 5.0)
    	}
    }

    #[test]
    fn test_gcj2wgs_exact() {
    	for test in TESTS.iter() {
    		let (wgs_lat, wgs_lng) = super::gcj2wgs_exact(test.gcj_lat, test.gcj_lng);
    		let d = super::distance(wgs_lat, wgs_lng, test.wgs_lat, test.wgs_lng);
    		assert!(d < 0.5)
    	}
    }
}
