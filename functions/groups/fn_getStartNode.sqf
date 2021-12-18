/*
	Author: HangoverIt

	Description:
		Return the ID of the start node for a side

	Parameter(s):
		1. Side
    
	Returns:
		Side ID string
*/
params["_side"] ;

// TO DO: pull the values from config
private _eastStart = "Kavala[3458.95,12966.4,-6.1822]";
private _westStart = "Pyrgos[16780.6,12604.5,-18.9913]";

private _ret = switch (_side) do {
	case east: {_eastStart;};
	case west: {_westStart;};
	default {_westStart};
};

_ret ;