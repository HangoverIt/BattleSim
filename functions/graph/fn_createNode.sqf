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
};

true ;