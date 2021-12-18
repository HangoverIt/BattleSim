/*
	Author: HangoverIt

	Description:
		Create a vehicle and occupants

	Parameter(s):
		1. Vehicle info from group template
		2. (Optional) Side to use for occupants - if any
    
	Returns:
		Object
*/
params["_vehicleinfo", "_side"];

private _class = _vehicleinfo select 0 ;
private _magazines = _vehicleinfo select 1;
private _damage = _vehicleinfo select 2;
private _fuel = _vehicleinfo select 3;
private _occupants = _vehicleinfo select 4;

private _v = createVehicle[_class, [0,0,0], [], 0, "NONE"] ;
private _allMags = magazinesAllTurrets _v ;

// Only apply if magazines array specified
if (count _magazines > 0) then {
	// Remove all magazines
	{
		_magName = _x select 0 ;
		_turretPath = _x select 1;
		_v removeMagazinesTurret [_magName, _turretPath] ;
	}forEach _allMags ;

	// Restore from vehicle info
	{
		_magName = _x select 0 ;
		_turretPath = _x select 1;
		_amount = _x select 2;
		_v addMagazineTurret [_magName,_turretPath,_amount];
	}forEach _magazines;
};

// Only apply if damage is set in info
if (count _damage > 0) then {
	{
		_v setHitPointDamage _x ;
	}forEach _damage ;
};

// Create occupants in vehicle
_units = [] ;
{
	_units pushBack ([_x, _v, _side] call Sim_fnc_createGroupInfoUnit);
}forEach _occupants;

// Join units to the same group
if (count _units > 0) then {
	_grp = group (_units select 0);
	_units joinSilent _grp ;
};

_v setFuel _fuel ;

_v ;
 
