function  [bdLat,bdLng]= gcj2bd(gcjLat, gcjLng)

    bdLat = gcjLat;
    bdLng = gcjLng;

    x_pi = pi * 3000.0 / 180.0;
    inChina = ~outOfChina(gcjLat, gcjLng);
    if ~any(inChina),return;end

    x = gcjLng(inChina);
    y = gcjLat(inChina);
    z = hypot(x, y) + 0.00002 * sin(y * x_pi);
    theta = atan2(y, x) + 0.000003 * cos(x * x_pi);
    bdLng(inChina) = z.* cos(theta) + 0.0065;
    bdLat(inChina) = z.* sin(theta) + 0.006;



end


