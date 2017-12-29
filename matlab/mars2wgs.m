function [lat, long ] = mars2wgs(marsLat, marsLong)
% assumption is that inital mars lat longs are close to actual
% then solves for the local delta and estimates the original lat longs
% then uses the estimated lat longs to try again
% this method seems very stable
% initialize estimates of lat and long

lat = marsLat;
long = marsLong;
threshold = 0.0000001;

for i=1:30
    [tempLat,tempLong] = wgs2gcj(lat, long);
    deltaLat = lat - tempLat;
    deltaLong = long - tempLong;
    lat = marsLat + deltaLat;
    long = marsLong + deltaLong;
    if all(abs(tempLat-marsLat)<threshold & abs(tempLong-marsLong)<threshold)
        return;
    end
end
    
end
