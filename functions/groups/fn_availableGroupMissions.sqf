/*
	Author: HangoverIt

	Description:
		Get array of available missions for the group

	Parameter(s):
		1. Group
    
	Returns:
		Array of available mission types for the group
*/
#include "..\groups\groups.hpp"
#include "..\groupinfo\groupinfo.hpp"
params["_group"];

private _grpInfo = getGroupInfo(_group) ;
private _grpTemplateID = getGroupInfoID(_grpInfo);

private _ret = ["hold"] ;

private _missionMapping = ([] call Sim_fnc_getConfig) get "supported_missions" ;
if (isNil "_missionMapping") exitWith {_ret} ;
private _groupMapping = _missionMapping get _grpTemplateID ;
if (isNil "_groupMapping") exitWith {_ret} ;
_ret = _groupMapping ;

_ret ;


 
