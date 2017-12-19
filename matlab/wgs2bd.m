function [bdLat, bdLng] =  wgs2bd(wgsLat, wgsLng)

[gcjLat, gcjLng] = wgs2gcj(wgsLat,wgsLng);
[bdLat , bdLng] = gcj2bd(gcjLat, gcjLng);

end