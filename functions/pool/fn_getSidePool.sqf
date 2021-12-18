/*
	Author: HangoverIt

	Description:
		Get the pool from a specified side

	Parameter(s):
		1. Side
    
	Returns:
		Pool (related to side)
*/
#include "..\pool\pool.hpp"
params["_side"] ;

_pools = [] call Sim_getAllPools ;

_sidePool = _pools get _side ;

_sidePool ;