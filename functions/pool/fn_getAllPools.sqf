/*
	Author: HangoverIt

	Description:
		Get variable for all pools (global)

	Parameter(s):
		None
    
	Returns:
		Global Pool
*/
#include "..\pool\pool.hpp"

if (isNil GROUPPOOL) then {
  CREATEGROUPPOOL;
};

GROUPPOOLVAR ;