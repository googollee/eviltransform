function  [x,y,utmzone] = deg2utm(lat,long)
% -------------------------------------------------------------------------
% [x,y,utmzone] = deg2utm(Lat,Lon)
%
% Inputs:
%    Lat: Latitude vector.   Degrees.  +ddd.ddddd  WGS84
%    Lon: Longitude vector.  Degrees.  +ddd.ddddd  WGS84
% Outputs:
%    x, y , utmzone.   See example
% Author: 
%   Aaron Close
%   Close Consulting
%-------------------------------------------------------------------------
% Argument checking
%
error(nargchk(2, 2, nargin));  %2 arguments required
n1=length(lat);
n2=length(long);
if (n1~=n2)
    error('Lat and Long vectors need to be the same length');
end

% set standards
majorRadius = 6378137.000000;
minorRadius = 6356752.314245;
e2 = (((majorRadius^2) - (minorRadius^2))^0.5)/minorRadius;
e2square = e2^2;
meanRadius = (majorRadius^2)/minorRadius;
alpha = (3/4)*e2square;
beta = (5/3)*alpha^2;
gamma = (35/27)*alpha^3;

% Calculate Zone From Inital Point
Zone = fix((long(1)/6) + 31);
if (lat(1)>=0), hemisphear='N';
else hemisphear='S';
end
utmzone=sprintf('%02d%c',Zone,hemisphear);
%convert to radians

S = ((Zone*6) - 183);
lat = lat * (pi/180);
long = long * (pi/180);
deltaS = long - (S *(pi/180));

% Vectorized main calculation
a = cos(lat).*sin(deltaS);
epsilon = 0.5.*log((1+a)./(1-a));
nu = atan(tan(lat)./cos(deltaS))-lat;
v = (meanRadius./((1 + (e2square.*(cos(lat)).^2))).^0.5).*0.9996;
a1 = sin(2.*lat);
a2 = a1.*(cos(lat)).^2;
j2 = lat + (a1./2);
j4 = ((3.*j2) + a2)./4;
j6 = ((5.*j4) + (a2.*(cos(lat)).^2))./3;
Bm = 0.9996*meanRadius*(lat-alpha.*j2 + beta.*j4 - gamma.*j6);
ta = (e2square/2).*epsilon.^2.*(cos(lat)).^2;
x = epsilon.*v.*(1 + (ta./3)) + 500000;
y = nu.*v.*(1 + ta) + Bm;
y(y<0)=9999999+y(y<0);
   
end

