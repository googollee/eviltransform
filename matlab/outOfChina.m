function result = outOfChina(lat,long)
    
    result = [long < 72.004 | long > 137.8347 | lat < 0.8293 | lat > 55.8271];
    
end