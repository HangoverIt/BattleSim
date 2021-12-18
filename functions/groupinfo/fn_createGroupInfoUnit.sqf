/*
	Author: HangoverIt

	Description:
		Create a unit based on a template

	Parameter(s):
		1. Unit info from group template
		2. (Optional) Vehicle to add unit to
		3. (Optional) Side to create the unit for, otherwise defaults to default side of class
    
	Returns:
		Object
*/
params["_unitinfo", ["_vehicle",objNull], "_side"];

_unitinfo params["_class", ["_damage", []], ["_roleinfo", []]] ;

if (isNil "_side") then {
	_cfg = configfile >> "CfgVehicles" >> _class >> "Side";
	if !(isNull _cfg) then {
		_side = switch(getNumber _cfg) do {
			case 0:{east};
			case 1:{west};
			case 2:{resistance};
			default {civilian} ;
		};
	};
};

private _grp = createGroup _side ;
private _unit = _grp createUnit[_class, [0,0,0], [], 0, "NONE"];

// Only apply if damage is set in info
if (count _damage > 0) then {
	{
		_unit setHitPointDamage _x ;
	}forEach _damage ;
};

if !(isNull _vehicle) then {
	if (count _roleinfo > 0) then {
		_role = _roleinfo select 0;
		switch (_role) do {
			case "driver": {_unit assignAsDriver _vehicle; _unit moveInDriver _vehicle};
			case "gunner": {_unit assignAsGunner _vehicle; _unit moveInGunner _vehicle};
			case "cargo": {_unit assignAsCargo _vehicle; _unit moveInGunner _vehicle} ;
			case "commander": {_unit assignAsCommander _vehicle; _unit moveInCommander _vehicle};
			case "turret": {_unit assignAsTurret [_vehicle, _roleinfo select 1] ; _unit moveInTurret [_vehicle, _roleinfo select 1]};
		};
	};
};

_unit;
 
