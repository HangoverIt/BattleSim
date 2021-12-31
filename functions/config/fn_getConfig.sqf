/*
	Author: HangoverIt

	Description:
		Get all configuration

	Parameter(s):
		None
    
	Returns:
		Hashmap of config
*/
#include "..\config\config.hpp"

if (isNil SIMCONFIG) then {
  [] call Sim_fnc_initConfig ;
};
private _config = SIMCONFIGVAR;

_config;