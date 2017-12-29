function totalDistance =  distance(latA, lngA, latB, lngB)
% Fully vectorized version of code

    earthR = 6371000; % Updated from 6378137.0
    pi180 = pi / 180;
    radLatA = latA * pi180;
    radLatB = latB * pi180;
    x = (cos(radLatA).*cos(radLatB).*cos((lngA - lngB)*pi180));
    y = sin(radLatA).*sin(radLatB);
    
    s = x + y;
    s(s > 1)=1;
    s(s < -1) = -1;

    alpha = acos(s);
    totalDistance = alpha * earthR;

end
