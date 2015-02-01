package com.lbt05.EvilTransform;

public class GCJPointer extends GeoPointer {


  public GCJPointer() {}

  public GCJPointer(double latitude, double longitude) {
    this.latitude = latitude;
    this.longitude = longitude;
  }

  public WSGPointer toWSGPointer() {
    if (TransformUtil.outOfChina(this.latitude, this.longitude)) {
      return new WSGPointer(this.latitude, this.longitude);
    }
    double[] delta = TransformUtil.delta(this.latitude, this.longitude);
    return new WSGPointer(this.latitude - delta[0], this.longitude - delta[1]);
  }

  public WSGPointer toExactWSGPointer() {
    final double initDelta = 0.01;
    final double threshold = 0.000001;
    double dLat = initDelta, dLng = initDelta;
    double mLat = this.latitude - dLat, mLng = this.longitude - dLng;
    double pLat = this.latitude + dLat, pLng = this.longitude + dLng;
    double wgsLat, wgsLng;
    WSGPointer currentWSGPointer = null;
    for (int i = 0; i < 30; i++) {
      wgsLat = (mLat + pLat) / 2;
      wgsLng = (mLng + pLng) / 2;
      currentWSGPointer = new WSGPointer(wgsLat, wgsLng);
      GCJPointer tmp = currentWSGPointer.toGCJPointer();
      dLat = tmp.getLatitude() - this.getLatitude();
      dLng = tmp.getLongitude() - this.getLongitude();
      if ((Math.abs(dLat) < threshold) && (Math.abs(dLng) < threshold)) {
        return currentWSGPointer;
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
    return currentWSGPointer;
  }
}
