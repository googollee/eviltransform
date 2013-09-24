package transform

import (
	"fmt"
	"github.com/googollee/go-assert"
	"testing"
)

type Test struct {
	wgsLat, wgsLng float64
	gcjLat, gcjLng float64
}

var tests = []Test{
	{31.1774276, 121.5272106, 31.17530398364597, 121.531541859215}, // shanghai
	{22.543847, 113.912316, 22.540796131694766, 113.9171764808363}, // shenzhen
	{39.911954, 116.377817, 39.91334545536069, 116.38404722455657}, // beijing
}

func toString(lat, lng float64) string {
	return fmt.Sprintf("%.5f,%.5f", lat, lng)
}

func TestWtoG(t *testing.T) {
	for i, test := range tests {
		gcjLat, gcjLng := WGStoGCJ(test.wgsLat, test.wgsLng)
		got := toString(gcjLat, gcjLng)
		target := toString(test.gcjLat, test.gcjLng)
		assert.Equal(t, got, target, "test %d", i)
	}
}

func TestGtoW(t *testing.T) {
	for i, test := range tests {
		wgsLat, wgsLng := GCJtoWGS(test.gcjLat, test.gcjLng)
		d := Distance(wgsLat, wgsLng, test.wgsLat, test.wgsLng)
		assert.Equal(t, d < 5, true, "test %d, distance: %f", i, d)
	}
}

func TestGtoWExact(t *testing.T) {
	for i, test := range tests {
		wgsLat, wgsLng := GCJtoWGSExact(test.gcjLat, test.gcjLng)
		d := Distance(wgsLat, wgsLng, test.wgsLat, test.wgsLng)
		assert.Equal(t, d < 0.5, true, "test %d, distance: %f", i, d)
	}
}

func BenchmarkWtoG(b *testing.B) {
	for i := 0; i < b.N; i++ {
		WGStoGCJ(tests[0].wgsLat, tests[0].wgsLng)
	}
}

func BenchmarkGtoW(b *testing.B) {
	for i := 0; i < b.N; i++ {
		GCJtoWGS(tests[0].gcjLat, tests[0].gcjLng)
	}
}

func BenchmarkGtoWExact(b *testing.B) {
	for i := 0; i < b.N; i++ {
		GCJtoWGSExact(tests[0].gcjLat, tests[0].gcjLng)
	}
}

func BenchmarkDistance(b *testing.B) {
	for i := 0; i < b.N; i++ {
		Distance(tests[0].wgsLat, tests[0].wgsLng, tests[0].gcjLat, tests[0].gcjLng)
	}
}
