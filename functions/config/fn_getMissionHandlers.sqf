/*
	Author: HangoverIt

	Description:
		Get array of mission handlers

	Parameter(s):
		None
    
	Returns:
		Hashmap of mission handlers
*/

_config = [] call Sim_fnc_getConfig ;

_config get "mission_handlers" ;