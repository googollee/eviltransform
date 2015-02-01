package com.lbt05.EvilTransform;

public class WSGPointer extends GeoPointer {

  public WSGPointer() {}

  public WSGPointer(double latitude, double longitude) {
    this.latitude = latitude;
    this.longitude = longitude;
  }

  public GCJPointer toGCJPointer() {
    if (TransformUtil.outOfChina(this.latitude, this.longitude)) {
      return new GCJPointer(this.latitude, this.longitude);
    }
    double[] delta = TransformUtil.delta(this.latitude, this.longitude);
    return new GCJPointer(this.latitude + delta[0], this.longitude + delta[1]);
  }
}
