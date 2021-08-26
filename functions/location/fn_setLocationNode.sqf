/*
	Author: HangoverIt

	Description:
		Create all location info at a graph node

	Parameter(s):
		1 (Mandatory): Node from graph
		2 (Mandatory): Location (Sim location array)

	Returns:
		BOOL
*/
#include "..\location\location.hpp"
params["_node", "_l"];

// Add additional information to location
_graphnode = _graph get _locationid ;
//_node set ["owner", civilian]; 
//_node set ["garrison", []]; 
_node set ["position", getLocationPos(_l)];
_node set ["size", getLocationSize(_l)] ; 
_node set ["weight", getLocationWeight(_l)] ; 

true ;