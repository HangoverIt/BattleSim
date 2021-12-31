/*
	Author: HangoverIt

	Description:
		Determine if the graph requires a new recon group deployment. 
		Returns true until enough are deployed and available
		<old - remove>

	Parameter(s):
		1: Side to assess if redeployment required

	Returns:
		Bool
*/
params["_side"] ;

_sidegrp = [_side] call Sim_fnc_getSideGroups ;

private _ret = count _sidegrp < 20 ;

_ret;