/*
	Author: HangoverIt

	Description:
		Fetches the side graph from global variables with stats per node from main graph.

	Parameter(s):
		1: Side
		
	Returns:
		Hashmap of side graph with stats
*/
#include "..\logic\logic.hpp"
params["_side"] ;

if (isNil SIDESTATS) then {
	diag_log "[BattleSim] Error: getSideGraph called without createSideStats being called - no stats available";
};

SIDESTATSVAR get _side ;
