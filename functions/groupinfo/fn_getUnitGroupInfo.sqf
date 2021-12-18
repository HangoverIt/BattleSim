/*
	Author: HangoverIt

	Description:
		Generate group unit info from object

	Parameter(s):
		1. Unit object
    
	Returns:
		Group info for unit
*/
params["_unit"];

private _class = typeOf _unit;
//private _magazines = []; // Not doing this. If required then getUnitLoadout can return everything
private _damage = [] ;
private _role = assignedVehicleRole _unit ;

// Transform damage 
private _hitpointInfo = getAllHitPointsDamage _unit ;
private _hitpointNames = _hitpointInfo select 0;
private _hitpointDamage = _hitpointInfo select 2;
{
	_damage pushBack [_x, _hitpointDamage select _forEachIndex];
}forEach _hitpointNames;

[_class, _damage, _role] ;