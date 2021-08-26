/*
	Author: HangoverIt

	Description:
		Return all battle groups

	Parameter(s):
    None
    
	Returns:
		HashMap
*/
#include "..\groups\groups.hpp"
if (isNil BATTLEGROUPS) then {
  CREATEBATTLEGRP;
};

BATTLEGRPVAR;