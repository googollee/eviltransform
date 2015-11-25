package com.lbt05.EvilTransform;

public class GCJPointer extends GeoPointer {


  public GCJPointer() {}

  public GCJPointer(double latitude, double longitude) {
    this.latitude = latitude;
    this.longitude = longitude;
  }

  public WGSPointer toWGSPointer() {
    if (TransformUtil.outOfChina(this.latitude, this.longitude)) {
      return new WGSPointer(this.latitude, this.longitude);
    }
    double[] delta = TransformUtil.delta(this.latitude, this.longitude);
    return new WGSPointer(this.latitude - delta[0], this.longitude - delta[1]);
  }

  public WGSPointer toExactWGSPointer() {
    final double initDelta = 0.01;
    final double threshold = 0.000001;
    double dLat = initDelta, dLng = initDelta;
    double mLat = this.latitude - dLat, mLng = this.longitude - dLng;
    double pLat = this.latitude + dLat, pLng = this.longitude + dLng;
    double wgsLat, wgsLng;
    WGSPointer currentWGSPointer = null;
    for (int i = 0; i < 30; i++) {
      wgsLat = (mLat + pLat) / 2;
      wgsLng = (mLng + pLng) / 2;
      currentWGSPointer = new WGSPointer(wgsLat, wgsLng);
      GCJPointer tmp = currentWGSPointer.toGCJPointer();
      dLat = tmp.getLatitude() - this.getLatitude();
      dLng = tmp.getLongitude() - this.getLongitude();
      if ((Math.abs(dLat) < threshold) && (Math.abs(dLng) < threshold)) {
        return currentWGSPointer;
      } else {
        System.out.println(dLat + ":" + dLng);
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
    return currentWGSPointer;
  }
}
