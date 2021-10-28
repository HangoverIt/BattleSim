/*
	Author: HangoverIt

	Description:
		Remove mission from group

	Parameter(s):
		1 (Mandatory): Group with existing mission

	Returns:
		Bool
*/
#include "..\groups\groups.hpp"
params["_group"] ;

setGroupMission(_group,[]) ; // make available for new missions

true ;