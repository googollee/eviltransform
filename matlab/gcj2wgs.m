function [lat, long ] = gcj2wgs(gcjLat, gcjLng)
% Not exact
% Fully vectorized

    lat = gcjLat;
    long = gcjLng;

    inChina = ~outOfChina(gcjLat, gcjLng);
    
    [dlat, dlng] = delta(gcjLat(inChina), gcjLng(inChina));

    lat(inChina) = gcjLat(inChina) - dlat;
    long(inChina) = gcjLng(inChina) - dlng;

end


