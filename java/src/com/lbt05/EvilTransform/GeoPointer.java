package com.lbt05.EvilTransform;

import java.text.DecimalFormat;

public class GeoPointer {
  static DecimalFormat df = new DecimalFormat("0.000000");
  double longitude;
  double latitude;

  public double getLongitude() {
    return longitude;
  }

  public void setLongitude(double longitude) {
    this.longitude = longitude;
  }

  public double getLatitude() {
    return latitude;
  }

  public void setLatitude(double latitude) {
    this.latitude = latitude;
  }

  @Override
  public boolean equals(Object other) {
    if (other == this) {
      return true;
    } else {
      if (other instanceof GeoPointer) {
        GeoPointer otherPointer = (GeoPointer) other;
        return df.format(latitude).equals(df.format(otherPointer.latitude))
            && df.format(longitude).equals(df.format(otherPointer.longitude));
      } else {
        return false;
      }
    }
  }

  public String toString() {
    StringBuilder sb = new StringBuilder("latitude:" + latitude);
    sb.append(" longitude:" + longitude);
    return sb.toString();
  }

  public double distance(GeoPointer target) {
    double earthR = 6371000;
    double x =
        Math.cos(this.latitude * Math.PI / 180) * Math.cos(target.latitude * Math.PI / 180)
            * Math.cos((this.longitude - target.longitude) * Math.PI / 180);
    double y = Math.sin(this.latitude * Math.PI / 180) * Math.sin(target.latitude * Math.PI / 180);
    double s = x + y;
    if (s > 1) {
      s = 1;
    }
    if (s < -1) {
      s = -1;
    }
    double alpha = Math.acos(s);
    double distance = alpha * earthR;
    return distance;
  }
}
