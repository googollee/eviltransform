function [lat,lng] = wgs2gcj(lat,lng);

inChina = ~outOfChina(lat,lng);

[dLat dLng] = delta(lat(inChina),lng(inChina));
 
lat(inChina) = lat(inChina) + dLat;
lng(inChina) = lng(inChina) + dLng;

end

