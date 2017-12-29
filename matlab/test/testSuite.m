%% Main function to generate tests
function tests = testSuite

tests = functiontests(localfunctions);

end

%% Test Functions 
function wgs2gcjTest(testCase)
% test wgs to gcj

TESTS =  [
    31.1774276, 121.5272106, 31.17530398364597, 121.531541859215; %shanghai
    22.543847, 113.912316, 22.540796131694766, 113.9171764808363; %shenzhen
    39.911954, 116.377817, 39.91334545536069, 116.38404722455657; %beijing
    39.739200,-104.990300,39.739200,-104.990300; %Denver edge case
    -27.469800,153.025100, -27.469800,153.025100; % Brisbane edge case
    -22.906800,-43.172900, -22.906800,-43.172900; % Rio de Janerio edge case
    ];

[actLat actLong] = wgs2gcj(TESTS(:,1),TESTS(:,2));
expLat = TESTS(:,3);
expLong = TESTS(:,4);

verifyEqual(testCase,actLat,expLat, 'AbsTol' , .000001);
verifyEqual(testCase,actLong,expLong, 'AbsTol' , .000001);

end

function gcj2wgsTest(testCase)
% test wgs to gcj

TESTS =  [
    31.1774276, 121.5272106, 31.17530398364597, 121.531541859215; %shanghai
    22.543847, 113.912316, 22.540796131694766, 113.9171764808363; %shenzhen
    39.911954, 116.377817, 39.91334545536069, 116.38404722455657; %beijing
    39.739200,-104.990300,39.739200,-104.990300; %Denver edge case
    -27.469800,153.025100, -27.469800,153.025100; % Brisbane edge case
    -22.906800,-43.172900, -22.906800,-43.172900; % Rio de Janerio edge case
    ];

[actLat actLong] = gcj2wgs(TESTS(:,3),TESTS(:,4));
expLat = TESTS(:,1);
expLong = TESTS(:,2);

measurementDistance = distance(expLat, expLong, actLat,actLong);
actualDistance = zeros(length(measurementDistance),1);
verifyEqual(testCase,actualDistance,measurementDistance, 'AbsTol' , 5);

end

function gcj2wgsExactTest(testCase)
% test wgs to gcj

TESTS =  [
    31.1774276, 121.5272106, 31.17530398364597, 121.531541859215; %shanghai
    22.543847, 113.912316, 22.540796131694766, 113.9171764808363; %shenzhen
    39.911954, 116.377817, 39.91334545536069, 116.38404722455657; %beijing
    39.739200,-104.990300,39.739200,-104.990300; %Denver edge case
    -27.469800,153.025100, -27.469800,153.025100; % Brisbane edge case
    -22.906800,-43.172900, -22.906800,-43.172900; % Rio de Janerio edge case
    ];

[actLat actLong] = gcj2wgs_exact(TESTS(:,3),TESTS(:,4));
expLat = TESTS(:,1);
expLong = TESTS(:,2);

measurementDistance = distance(expLat, expLong, actLat,actLong);
actualDistance = zeros(length(measurementDistance),1);
verifyEqual(testCase,actualDistance,measurementDistance, 'AbsTol' , .5);

end

function mars2wgsTest(testCase)
% test wgs to gcj should be very exact and very fast....

TESTS =  [
    31.1774276, 121.5272106, 31.17530398364597, 121.531541859215; %shanghai
    22.543847, 113.912316, 22.540796131694766, 113.9171764808363; %shenzhen
    39.911954, 116.377817, 39.91334545536069, 116.38404722455657; %beijing
    39.739200,-104.990300,39.739200,-104.990300; %Denver edge case
    -27.469800,153.025100, -27.469800,153.025100; % Brisbane edge case
    -22.906800,-43.172900, -22.906800,-43.172900; % Rio de Janerio edge case
    ];

[actLat actLong] = mars2wgs(TESTS(:,3),TESTS(:,4));
expLat = TESTS(:,1);
expLong = TESTS(:,2);

measurementDistance = distance(expLat, expLong, actLat,actLong);
actualDistance = zeros(length(measurementDistance),1);
verifyEqual(testCase,actualDistance,measurementDistance, 'AbsTol' , .01);

end

function wgs2bdTest(testCase)
% test wgs to gcj should be very exact and very fast....

 TESTS_BD = [
    29.199786, 120.019809, 29.196131605295484, 120.00877901149691;
    29.210504, 120.036455, 29.206795749156136, 120.0253853970846
    ];

[actLat actLong] = wgs2bd(TESTS_BD(:,3),TESTS_BD(:,4));
expLat = TESTS_BD(:,1);
expLong = TESTS_BD(:,2);

verifyEqual(testCase,actLat,expLat, 'AbsTol' , .00005);
verifyEqual(testCase,actLong,expLong, 'AbsTol' , .00005);

end

function bd2wgsTest(testCase)
% test wgs to gcj should be very exact and very fast....

 TESTS_BD = [
    29.199786, 120.019809, 29.196131605295484, 120.00877901149691;
    29.210504, 120.036455, 29.206795749156136, 120.0253853970846
    ];

[actLat actLong] = bd2wgs(TESTS_BD(:,1),TESTS_BD(:,2));
expLat = TESTS_BD(:,3);
expLong = TESTS_BD(:,4);

verifyEqual(testCase,actLat,expLat, 'AbsTol' , .00005);
verifyEqual(testCase,actLong,expLong, 'AbsTol' , .00005);

end

function gcj2bdTest(testCase)
% test wgs to gcj should be very exact and very fast....
% bd lat, bd long, gcj lat, gcj long 
 TESTS_BD = [39.90851,116.43351,39.90245,116.42703];

[actLat actLong] = gcj2bd(TESTS_BD(:,3),TESTS_BD(:,4));
expLat = TESTS_BD(:,1);
expLong = TESTS_BD(:,2);

verifyEqual(testCase,actLat,expLat, 'AbsTol' , .00005);
verifyEqual(testCase,actLong,expLong, 'AbsTol' , .00005);

end

function bd2gcjTest(testCase)
% test wgs to gcj should be very exact and very fast....
% bd lat, bd long, gcj lat, gcj long 
 TESTS_BD = [39.90851,116.43351,39.90245,116.42703];

[actLat actLong] = bd2gcj(TESTS_BD(:,1),TESTS_BD(:,2));
expLat = TESTS_BD(:,3);
expLong = TESTS_BD(:,4);

verifyEqual(testCase,actLat,expLat, 'AbsTol' , .00005);
verifyEqual(testCase,actLong,expLong, 'AbsTol' , .00005);

end

function deg2utmTest(testCase)
% test wgs to utm should be very exact and very fast....
% LAT, LONG, X, Y

TestUTMDEG = [36.903784,-104.545898,540455.18,4084295.17];

[actUTMx, actUTMy] = deg2utm(TestUTMDEG(:,1),TestUTMDEG(:,2));
expUTMx = TestUTMDEG(:,3);
expUTMy = TestUTMDEG(:,4);

verifyEqual(testCase,actUTMx,expUTMx, 'AbsTol' , .1);
verifyEqual(testCase,actUTMy,expUTMy, 'AbsTol' , .1);

end

function utm2degTest(testCase)
% test wgs to gcj should be very exact and very fast....
% LAT, LONG, X, Y

TestUTMDEG = [36.903784,-104.545898,540455.18,4084295.17];

[actLat, actLong] = utm2deg(TestUTMDEG(:,3),TestUTMDEG(:,4),'13N');
expLat = TestUTMDEG(:,1);
expLong = TestUTMDEG(:,2);

verifyEqual(testCase,actLat,expLat, 'AbsTol' , .00001);
verifyEqual(testCase,actLong,expLong, 'AbsTol' , .00001);

end

function speedTest(testCase)
% test wgs to gcj
n = 50000;
TESTS =  [
    31.1774276, 121.5272106, 31.17530398364597, 121.531541859215; %shanghai
    22.543847, 113.912316, 22.540796131694766, 113.9171764808363; %shenzhen
    39.911954, 116.377817, 39.91334545536069, 116.38404722455657; %beijing
    39.739200,-104.990300,39.739200,-104.990300; %Denver edge case
    -27.469800,153.025100, -27.469800,153.025100; % Brisbane edge case
    -22.906800,-43.172900, -22.906800,-43.172900; % Rio de Janerio edge case
    ];


tic;
for i=1:n
    [actLat actLong] = wgs2gcj(TESTS(:,1),TESTS(:,2));
end
times.wgs2gcj = toc;


tic;
for i=1:n
    [actLat actLong] = mars2wgs(TESTS(:,1),TESTS(:,2));
end
times.mars2gcj = toc;


tic;
for i=1:n
    [actLat actLong] = gcj2wgs(TESTS(:,1),TESTS(:,2));
end
times.gcj2wgs = toc;


tic;
for i=1:n
    [actLat actLong] = gcj2wgs_exact(TESTS(:,1),TESTS(:,2));
end
times.gcj2wgs_exact = toc;

times

end

 function setupOnce(testCase)  % do not change function name

    testsBD = [
    29.199786, 120.019809, 29.196131605295484, 120.00877901149691;
    29.210504, 120.036455, 29.206795749156136, 120.0253853970846
    ];
    
 end
 
 function teardownOnce(testCase)  % do not change function name
% change back to original path, for example
end
 
function setup(testCase)  % do not change function name
% open a figure, for example
end

function teardown(testCase)  % do not change function name
% close figure, for example
end