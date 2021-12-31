/*
	Author: HangoverIt

	Description:
		Create a default template for a group. Output is typically used for creating new groups

	Parameter(s):
		1. Side to apply to
		2. Name of template
    
	Returns:
		group template for associated units and stats
*/
params["_side","_name"];
// TO DO: load from config

private _ret = [] ;
private _ID = toLower _name;
// Template: [ID, Vehicles, Units]
// ID: string
// Vehicles: [[class, Magazines, Damage, fuel, Units]]
// Damage: [[hitPointName, Damage]]
// Units: [[class, Damage, role]] - see assignedVehicleRole for roles
// Magazines: [[magazine,turretpath,amount]]
// Type ID, Array of [unit class, Magazines, Damage, fuel]
// Magazines - call magazinesAllTurrets for data
// Get all hit point damage can be retrieved from getAllHitPointsDamage - note that this needs transforming into Damage array

_reconTemplate = 
[
	"recon",
	[ // Vehicles
		["B_LSV_01_armed_F", [], [], 1,[["B_Soldier_F",[],["driver"]], ["B_Soldier_F",[],["turret",[0]]], ["B_Soldier_F",[],["turret",[1]]]]], 
		["B_LSV_01_armed_F", [], [], 1,[["B_Soldier_F",[],["driver"]], ["B_Soldier_F",[],["turret",[0]]], ["B_Soldier_F",[],["turret",[1]]]]]
	],
	[ // Units
		["B_Soldier_F",[],[]],
		["B_Soldier_F",[],[]],
		["B_Soldier_F",[],[]]
	] 
];

_airTemplate =
[
	"air",
	[ // Vehicles
		["B_Plane_Fighter_01_F", [], [], 1, [ ["B_Fighter_Pilot_F",[],["driver"]] ] ]
	],
	[] // Units - none for air
];

_heavyTemplate =
[
	"assault",
	[ // Vehicles
		["B_LSV_01_armed_F", [], [], 1,[["B_Soldier_F",[],["driver"]], ["B_Soldier_F",[],["turret",[0]]], ["B_Soldier_F",[],["turret",[1]]]]], 
		["B_LSV_01_armed_F", [], [], 1,[["B_Soldier_F",[],["driver"]], ["B_Soldier_F",[],["turret",[0]]], ["B_Soldier_F",[],["turret",[1]]]]]
	],
	[ // Units
		["B_Soldier_F",[],[]],
		["B_Soldier_F",[],[]],
		["B_Soldier_F",[],[]]
	] 
];

_infantryTemplate =
[
	"infantry",
	[ // Vehicles

	],
	[ // Units
		["B_Soldier_F",[],[]],
		["B_Soldier_F",[],[]],
		["B_Soldier_F",[],[]],
		["B_Soldier_F",[],[]],
		["B_Soldier_F",[],[]],
		["B_Soldier_F",[],[]],
		["B_Soldier_F",[],[]],
		["B_Soldier_F",[],[]]
	] 
];

if (_side == east) then {
	_ret = switch (_ID) do {
		case "recon": {_reconTemplate};
		case "air": {_airTemplate};
		case "assault": {_heavyTemplate};
		default {_infantryTemplate};
	};
};
if (_side == west) then {
	_ret = switch (_ID) do {
		case "recon": {_reconTemplate};
		case "air": {_airTemplate};
		case "assault": {_heavyTemplate};
		default {_infantryTemplate};
	};
};

_ret set [0, _ID] ; // Set the name provided for template

_ret ;


 
