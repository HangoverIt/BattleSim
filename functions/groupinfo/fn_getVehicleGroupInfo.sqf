/*
	Author: HangoverIt

	Description:
		Generate group vehicle info from a vehicle object

	Parameter(s):
		1. Vehicle object
    
	Returns:
		Group info for vehicle
*/
params["_vehicle"];

private _class = typeOf _vehicle;
private _magazines = [];
private _fuel = fuel _vehicle;
private _damage = [] ;
{
	// Remove the ID and owner
	_magazines pushBack [_x select 0, _x select 1, _x select 2] ;
} forEach (magazinesAllTurrets _vehicle);

// Transform damage 
private _hitpointInfo = getAllHitPointsDamage _vehicle ;
private _hitpointNames = _hitpointInfo select 0;
private _hitpointDamage = _hitpointInfo select 2;
{
	_damage pushBack [_x, _hitpointDamage select _forEachIndex];
}forEach _hitpointNames;

[_class, _magazines, _damage, _fuel, []] ;