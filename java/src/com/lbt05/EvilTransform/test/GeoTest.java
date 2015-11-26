package com.lbt05.EvilTransform.test;

import static org.junit.Assert.*;

import org.junit.Test;

import com.lbt05.EvilTransform.GCJPointer;
import com.lbt05.EvilTransform.WGSPointer;

public class GeoTest {
  WGSPointer shanghaiWGSPointer = new WGSPointer(31.1774276, 121.5272106);
  GCJPointer shanghaiGCJPointer = new GCJPointer(31.17530398364597, 121.531541859215);
  WGSPointer shenzhenWGSPointer = new WGSPointer(22.543847, 113.912316);
  GCJPointer shenzhenGCJPointer = new GCJPointer(22.540796131694766, 113.9171764808363);
  WGSPointer beijingWGSPointer = new WGSPointer(39.911954, 116.377817);
  GCJPointer beijingGCJPointer = new GCJPointer(39.91334545536069, 116.38404722455657);

  @Test
  public void testWGS2GCJ() {
    assertEquals(shanghaiGCJPointer, shanghaiWGSPointer.toGCJPointer());
    assertEquals(shenzhenGCJPointer, shenzhenWGSPointer.toGCJPointer());
    assertEquals(beijingGCJPointer, beijingWGSPointer.toGCJPointer());
  }

  public void testGCJ2WGS() {
    assertTrue(shanghaiWGSPointer.distance(shanghaiGCJPointer.toWGSPointer()) < 5);
    assertTrue(shenzhenGCJPointer.distance(shenzhenGCJPointer.toWGSPointer()) < 5);
    assertTrue(beijingGCJPointer.distance(beijingGCJPointer.toWGSPointer()) < 5);
  }

  public void testGCJ2ExtactWGS() {
    assertTrue(shanghaiWGSPointer.distance(shanghaiGCJPointer.toExactWGSPointer()) < 0.5);
    assertTrue(shenzhenGCJPointer.distance(shenzhenGCJPointer.toExactWGSPointer()) < 0.5);
    assertTrue(beijingGCJPointer.distance(beijingGCJPointer.toExactWGSPointer()) < 0.5);
  }
}
