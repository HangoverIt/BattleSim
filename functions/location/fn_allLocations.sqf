/*
	Author: HangoverIt

	Description:
		Return all locations for the game. Slow execution as querying all of the world locations

	Parameter(s):
		None

	Returns:
		Array of game locations (not the same as Arma 3 map locations)
*/

private _allLocationTypes = [];

// Default set of locations - should this read from config or leave hardcoded as-is?
_allLocationTypes = ["NameCity","NameCityCapital","NameVillage","NameMarine","Airport","NameLocal"];
// Uncomment for all map locations
//"_allLocationTypes pushBack configName _x" configClasses (configFile >> "CfgLocationTypes");

private _graphLocations = [] ; // actual location array
private _all_locations = nearestLocations[[worldSize / 2, worldSize / 2], _allLocationTypes, (sqrt (2 * (worldSize * worldSize)) ) / 2] ;
{
	private _l_size = size _x ;
	private _l_max_size = (_l_size select 0) max (_l_size select 1) ;
   
	// Name, position array, size, base weight
	_graphLocations pushBack [text _x, locationPosition _x, _l_max_size, 0]; 
	//diag_log format["Adding location %1 with size %2 at location %3 to all locations", text _x, _l_max_size, locationPosition _x] ; 

  
}forEach _all_locations ;

_graphLocations;