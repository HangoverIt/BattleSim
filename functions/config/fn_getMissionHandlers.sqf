/*
	Author: HangoverIt

	Description:
		Get array of mission handlers

	Parameter(s):
		None
    
	Returns:
		Hashmap of mission handlers
*/
#include "..\config\config.hpp"

if (isNil SIMCONFIG) then {
  [] call Sim_fnc_initConfig ;
};
private _config = SIMCONFIGVAR;

_config get "mission_handlers" ;