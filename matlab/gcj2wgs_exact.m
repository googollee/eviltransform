function [lat, long ] = gcj2wgs_exact(gcjLat, gcjLng)
% adapted from https://github.com/googollee/eviltransform

    initDelta = 0.01;
    threshold = 0.000001;
    dLat = initDelta;
    dLng = initDelta;
    mLat = gcjLat - dLat;
    mLng = gcjLng - dLng;
    pLat = gcjLat + dLat;
    pLng = gcjLng + dLng;

    for i=1:30
        wgsLat = (mLat + pLat) / 2;
        wgsLng = (mLng + pLng) / 2;
        [tmplat, tmplng] = wgs2gcj(wgsLat, wgsLng);
        dLat = tmplat - gcjLat;
        dLng = tmplng - gcjLng;
        if all(abs(dLat) < threshold & abs(dLng) < threshold)
            lat = wgsLat;
            long =wgsLng;
            return;
        end
        pLat(dLat>=0) = wgsLat(dLat>=0);
        mLat(dLat<=0) = wgsLat(dLat<=0);
        pLng(dLng>=0) = wgsLng(dLng>=0);
        mLng(dLng<=0) = wgsLng(dLng<=0);
    end
    
   lat = wgsLat;
   long =wgsLng;
    
end
