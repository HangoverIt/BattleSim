
private _locations = [] call Sim_fnc_allLocations ;
locationGraph = [_locations] call Sim_fnc_createGraph;

//private _markers = [locationGraph, _locations, false] call Sim_fnc_makeLocationGraph;
locationGraph = [] call Sim_fnc_loadGraph ;

