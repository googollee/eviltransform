
function [dLat dLng] = delta(lat,lng)
    
    earthRadius = 6378245 % Replace from because of differnet ellipsoid 6378137.0;
    ee = 0.00669342162296594323;
    
    [dLat, dLng] = transform(lat, lng);
    
    radConv = pi/180;
    radLat = lat * radConv;
    magic = 1 - ee * sin(radLat).^2;
    sqrtMagic = sqrt(magic);

    dLat = (dLat ./((earthRadius * (1 - ee))./(magic.*sqrtMagic))./radConv);
    dLng = (dLng ./(earthRadius./sqrtMagic.*cos(radLat))./radConv);


end