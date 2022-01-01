/*
	Author: HangoverIt

	Description:
		Initialise configuration global var

	Parameter(s):
		None
    
	Returns:
		BOOL
*/
#include "..\config\config.hpp"

if (isNil SIMCONFIG) then {
  CREATESIMCONFIG;
};
private _config = SIMCONFIGVAR;

_config set ["mission_handlers", createHashMapFromArray[["deploy", [20, Sim_fnc_findReconMission, Sim_fnc_doDeployMission]]]] ;
_config set ["supported_missions", createHashMapFromArray[["recon", ["deploy"]], ["air", []], ["assault", ["deploy"]]]] ;

true;