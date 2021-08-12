/*
	Author: HangoverIt

	Description:
	Create a node in the location graph

	Parameter(s):
		None

	Returns:
	BOOL
*/
params["_graph", "_l"];

if (!(_l in _graph)) then {
	_graph set [_l, createHashMap] ;
	
	// Add additional information to location
	_hm = _graph get _l ;
	_hm set ["owner", civilian];
	_hm set ["garrison", []];
};

true ;