function [wgsLat, wgsLng] = bd2wgs(bdLat, bdLng)

[gcjLat, gcjLng] = bd2gcj(bdLat, bdLng);
[wgsLat, wgsLng] = gcj2wgs(gcjLat, gcjLng);

end
    

    
    