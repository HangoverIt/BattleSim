params["_carrier",["_planeclass", "B_Plane_Fighter_01_F",[""]]];

private _carrierObjs = ["Land_Carrier_01_hull_07_1_F", "Land_Carrier_01_hull_04_1_F", "Land_Carrier_01_hull_04_2_F"];
private _catapultInfo = [] ;

{
	_o = (getPos _carrier) nearObjects [_x, 200];
	_o = _o param [0, objNull];
	if (!(isNull _o)) then {
		for [{_i = 1}, {_i < 5}, {_i = _i + 1}] do {
			_cfg = configfile >> "CfgVehicles" >> _x >> "Catapults" >> ["Catapult", _i] joinString "";
			if (!(isNull _cfg)) then {
				_pos = _o modelToWorld (_o selectionPosition (getText (_cfg >> "memoryPoint")));
				_dir = (getDir _o - (getNumber (_cfg >> "dirOffset")) - 180) % 360;
				_catapultInfo pushBack [_o, _pos, _dir, getArray (_cfg >> "animations")] ;
			};
		};
	};
}forEach _carrierObjs ;

if (count _catapultInfo == 0) exitWith {false} ;

_catapult = selectRandom _catapultInfo ;
diag_log format["Selected catapult %1", _catapult] ;

_plane = createVehicle [_planeclass, (_catapult select 1), [], 0, "NONE"] ;
_plane setPosASL (_catapult select 1);
_plane setDir (_catapult select 2);
createVehicleCrew _plane ;
(driver _plane) disableAI "MOVE";
_plane disableAI "MOVE";
(driver _plane) disableAI "PATH";
_plane disableAI "PATH";

_plane setFuel 0;
_plane engineOn false;
 
_FX_smoke_source = "#particlesource" createVehicleLocal (_catapult select 1); 
_FX_smoke_source setParticleClass "RifleAssaultCloud2"; 
//FX_smoke_source attachto [_object,[0,0,0]]; 

sleep 10;

[_catapult select 0, _catapult select 3, 10] spawn BIS_fnc_Carrier01AnimateDeflectors;

_plane allowDamage false ;
_plane setFuel 1;
_plane engineOn true;

//sleep 14;

_timer = 14 + time ;
while { time < _timer } do {

   _plane setPosASL (_catapult select 1);
   _plane setVelocity [0,0,0];
   doStop _plane;
   _plane stop true;
   _plane forceSpeed 0;
   (driver _plane) disableAI "MOVE";
   sleep 0.1;
};

deleteVehicle _FX_smoke_source;

_plane setPosASL (_catapult select 1);
[_plane, 0, 0] call BIS_fnc_setPitchBank;
[_plane] call BIS_fnc_AircraftCatapultLaunch;

sleep 4;
(driver _plane)  enableAI "MOVE";
_plane allowDamage true ;
sleep 6;
[_catapult select 0, _catapult select 3, 0] spawn BIS_fnc_Carrier01AnimateDeflectors;

/*
_res = [] ;
_cat = ((position carrier) nearObjects ["Land_Carrier_01_hull_04_1_F",100]);
_cat = _cat select 0;
_names = selectionNames _cat;
{_res pushBack [_x,(_cat selectionPosition _x)]}forEach _names ;
_res;

_cat = ((position carrier) nearObjects ["Land_Carrier_01_hull_04_1_F",100]); 
_cat = _cat select 0; 
_pos = _cat selectionPosition "pos_catapult_02";
_pos = _cat modelToWorld _pos ;
player setPosASLW _pos

*/