/*
	Author: HangoverIt

	Description:
	Load a graph from SQF file

	Parameter(s):
		0 (Optional): Path to file, or defaults to a known SQF

	Returns:
		BOOL
*/
#include "graph.hpp"
params[["_file", "predefined\graph\altis.sqf", [""]]] ;

private _fn = compile preprocessFileLineNumbers _file ;

SETSIMGRAPH ([] call _fn) ;

true;