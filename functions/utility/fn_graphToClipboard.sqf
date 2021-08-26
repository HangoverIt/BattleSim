/*
	Author: HangoverIt

	Description:
		Dump a hashmap of the game locations to the clipboard 

	Parameter(s):
		0 (Mandatory): Graph to dump

	Returns:
	BOOL
*/
params["_graph"] ;

private _print_null = {
	params["_o"] ;
	switch(typeName _o) do
	{
		case "OBJECT": {"objNull"};
		case "GROUP": {"grpNull"} ;
		case "CONTROL": {"controlNull"} ;
		case "TEAM_MEMBER": {"teamMemberNull"};
		case "DISPLAY": {"displayNull"};
		case "TASK": {"taskNull"};
		case "LOCATION": {"locationNull"};
		case "CONFIG": {"configNull"};
		case "DIARY_RECORD": {"diaryRecordNull"};
		default {""};
	};
};
private _iterate_fn = {
	params["_o",["_pretty", false]] ;
	private _str = "" ;
	private _comma = ""; 
	private _pretty_print = "" ;
	if (_pretty) then {_pretty_print = toString [13,10];};
	//if (isNull _o) exitWith {"objNull"};
	switch (typeName _o) do
	{
		case "ARRAY": {_str = "["; {_str = _str + _comma + ([_x] call _iterate_fn); _comma = ","} forEach _o;_str = _str + "]";};
		case "HASHMAP": {_str = "createHashMapFromArray["; {_str = _str + _comma + _pretty_print + "[" + str(_x) + "," + ([_y] call _iterate_fn) + "]"; _comma = ","} forEach _o; _str = _str + "]";};
		default {_str = str(_o);} ;
	};
	_str ;
};

private _br = toString [13,10];
private _cliptext = "// Auto generated location graph" + _br ;
_cliptext = _cliptext + "private _a = " + _br ;
_cliptext = _cliptext + ([_graph,true] call _iterate_fn) ;
_cliptext = _cliptext + _br + ";" + _br ;
_cliptext = _cliptext + "_a;";

copyToClipboard _cliptext;

true ;