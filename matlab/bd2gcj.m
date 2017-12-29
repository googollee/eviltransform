function [gcjLat, gcjLng]  = bd2gcj(bdLat, bdLng)
    gcjLat = bdLat;
    gcjLng = bdLng;
    
    x_pi = pi * 3000.0 / 180.0;
    inChina = ~outOfChina(bdLat, bdLng);
    if ~any(inChina),return;end
    
    x = bdLng(inChina) - 0.0065;
    y = bdLat(inChina) - 0.006;
    
    z = hypot(x, y) - 0.00002 * sin(y * x_pi);
    theta = atan2(y, x) - 0.000003 * cos(x * x_pi);
    gcjLng(inChina) = z.*cos(theta);
    gcjLat(inChina) = z.*sin(theta);

end