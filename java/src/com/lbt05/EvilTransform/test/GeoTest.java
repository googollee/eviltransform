package com.lbt05.EvilTransform.test;

import static org.junit.Assert.*;

import org.junit.Test;

import com.lbt05.EvilTransform.GCJPointer;
import com.lbt05.EvilTransform.WSGPointer;

public class GeoTest {
  WSGPointer shanghaiWSGPointer = new WSGPointer(31.1774276, 121.5272106);
  GCJPointer shanghaiGCJPointer = new GCJPointer(31.17530398364597, 121.531541859215);
  WSGPointer shenzhenWSGPointer = new WSGPointer(22.543847, 113.912316);
  GCJPointer shenzhenGCJPointer = new GCJPointer(22.540796131694766, 113.9171764808363);
  WSGPointer beijingWSGPointer = new WSGPointer(39.911954, 116.377817);
  GCJPointer beijingGCJPointer = new GCJPointer(39.91334545536069, 116.38404722455657);

  @Test
  public void testWSG2GCJ() {
    assertEquals(shanghaiGCJPointer, shanghaiWSGPointer.toGCJPointer());
    assertEquals(shenzhenGCJPointer, shenzhenWSGPointer.toGCJPointer());
    assertEquals(beijingGCJPointer, beijingWSGPointer.toGCJPointer());
  }

  public void testGCJ2WSG() {
    assertTrue(shanghaiWSGPointer.distance(shanghaiGCJPointer.toWSGPointer()) < 5);
    assertTrue(shanghaiWSGPointer.distance(shenzhenGCJPointer.toWSGPointer()) < 5);
    assertTrue(shanghaiWSGPointer.distance(beijingGCJPointer.toWSGPointer()) < 5);
  }

  public void testGCJ2ExtactWSG() {
    assertTrue(shanghaiWSGPointer.distance(shanghaiGCJPointer.toExactWSGPointer()) < 0.5);
    assertTrue(shanghaiWSGPointer.distance(shenzhenGCJPointer.toExactWSGPointer()) < 0.5);
    assertTrue(shanghaiWSGPointer.distance(beijingGCJPointer.toExactWSGPointer()) < 0.5);
  }
}
