function  [Lat,Lon] = utm2deg(X,Y,utmzone)
    % -------------------------------------------------------------------------
    % [Lat,Lon] = utm2deg(x,y,utmzone)
    % Description: Function to convert vectors of UTM coordinates into Lat/Lon vectors (WGS84).
    % Some code has been extracted from UTMIP.m function by Gabriel Ruiz
    % Martinez and utm2deg.m by Rafael Palacios
    % This is a vectorized version based mostly of Rafael Palacios' version
    % Inputs:
    %    X vector or scaler,
    %    Y vector or scaler,
    %    utmzone of form '15N' or  '25S' no spaces and only north or south
    %    designation
    % Outputs:
    %    Lat: Latitude vector or scaler.   Degrees.  +ddd.ddddd  WGS84
    %    Lon: Longitude vector or scaler.  Degrees.  +ddd.ddddd  WGS84
    %
    % Example 1:
    % x=[ 458731;  407653;  239027;  230253;  343898;  362850];
    % y=[4462881; 5126290; 4163083; 3171843; 4302285; 2772478];
    % utmzone='30N';
    % [Lat, Lon]=utm2deg(X,Y,utmzone);
    %
    % Author:
    %   Aaron Close
    %   Close Consulting
    %   Houston, TX
    %%-------------------------------------------------------------------------
    % Argument checking
    %
    error(nargchk(3, 3, nargin)); %3 arguments required
    n1=length(X);
    n2=length(X);
    if (n1~=n2)
        error('x,y vectors should have the same number or rows');
    end

    meanRadius=size(utmzone);
    if (meanRadius~=3)
        error('utmzone should be a vector of strings like "30N" or "15S" leading zero is required for zones less than 10' );
    end

    %% set zone info and check for errors
    if ~(utmzone(3)=='N' || utmzone(3)=='S')
        fprintf('utm2deg: Warning utmzone should be a vector of strings like "30N", not "30n"\n');
        return;
    end
    
    if (utmzone(3)=='N')
        hemisphere='N';   % Northern hemisphere
    else
        hemisphere='S';
    end
    Zone=str2double(utmzone(1:2));

    %% one time calcs
    majorRadius = 6378137.000000;
    minorRadius = 6356752.314245;
    e2 = (((majorRadius^2) - (minorRadius^2))^0.5)/minorRadius;
    e2squared = e2^2;
    meanRadius = (majorRadius^2)/minorRadius;
    alpha = ( 3 / 4 ) * e2squared;
    beta = ( 5 / 3 ) * alpha ^ 2;
    gamma = ( 35 / 27 ) * alpha ^ 3;

    X = X - 500000;
    if hemisphere == 'S'
        Y = Y - 10000000;
    end
    S = ( ( Zone * 6 ) - 183 );

    % Vectorized Math
    lat =  Y / ( 6366197.724 * 0.9996 );
    v = ((meanRadius./(1+(e2squared*(cos(lat).^2))).^0.5)*0.9996);
    a = X./ v;
    a1 = sin( 2 * lat );
    a2 = a1.* ( cos(lat) ).^2;
    j2 = lat + ( a1 / 2 );
    j4 = ( ( 3 * j2 ) + a2 ) / 4;
    j6 = ( ( 5 * j4 ) + ( a2.*(cos(lat)).^ 2) ) / 3;
    Bm = 0.9996 * meanRadius * ( lat - alpha * j2 + beta * j4 - gamma * j6 );
    b = ( Y - Bm )./v;
    Epsi = ((e2squared*a.^2 )./2 ).*(cos(lat)).^2;
    Eps = a.*(1-(Epsi./3));
    nab = (b.*(1-Epsi)) + lat;
    senoheps = (exp(Eps) - exp(-Eps))./2;
    Delt = atan(senoheps./cos(nab));
    TaO = atan(cos(Delt).*tan(nab));
    Lon = (Delt.*(180/pi))+S;
    Lat = (lat+(1+e2squared.*(cos(lat).^2)-(3/2)*e2squared.*sin(lat).*cos(lat).*(TaO-lat)).*(TaO-lat)).*(180/pi);
    
end