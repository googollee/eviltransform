module Main where

    import EvilTransform
    import System.Exit (exitFailure, exitSuccess)

    main = do
      if (testWgs2Gcj && testGcj2Wgs && testGcj2WgsExact)
      then exitSuccess
      else exitFailure

    --                 wgs coordinate                  gcj coordinate            
    fixture =  [ ((31.1774276, 121.5272106), (31.17530398364597, 121.531541859215)),  -- Shanghai
                 ((22.543847, 113.912316),  (22.540796131694766, 113.9171764808363)), -- Shenzhen
                 ((39.911954, 116.377817), (39.91334545536069, 116.38404722455657)) ] -- Beijing 

    
    testWgs2Gcj :: Bool
    testWgs2Gcj = all (\cs -> wgs2Gcj (fst cs) == snd cs) fixture

    testGcj2Wgs :: Bool
    testGcj2Wgs = all (\cs -> (distance (gcj2Wgs (snd cs)) (fst cs)) < 5) fixture

    testGcj2WgsExact :: Bool
    testGcj2WgsExact = all (\cs -> (distance (gcj2Wgs (snd cs)) (fst cs)) < 0.5 ) fixture
