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
params["_graph", "_a", "_b"] ;

private _ret = false ;

if ((_a in _graph) && (_b in _graph)) then {
	_ahash = _graph get _a ;
	_bhash = _graph get _b ;
	if ((_b in _ahash) && (_a in _bhash)) then {
		_ret = true ;
	};
};
_ret;