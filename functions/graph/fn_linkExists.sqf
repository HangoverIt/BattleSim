/*
	Author: HangoverIt

	Description:
	Check if a link exists in the location graph

	Parameter(s):
		1 (Mandatory): Location graph hashmap
		2 (Mandatory): First location (Sim location array)
		3 (Mandatory): Second location (Sim location array)

	Returns:
	BOOL
*/
#include "..\location\location.hpp"
params["_graph", "_a", "_b"] ;

private _ret = false ;
private _a_id = getLocationID(_a) ;
private _b_id = getLocationID(_b) ;

if ((_a_id in _graph) && (_b_id in _graph)) then {
	private _a_paths = (_graph get _a_id) get "paths" ;
	private _b_paths = (_graph get _b_id) get "paths" ;
	if ((_b_id in _a_paths) && (_a_id in _b_paths)) then {
		_ret = true ;
	};
};
_ret;