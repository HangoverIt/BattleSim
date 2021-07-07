#include "..\location\location.hpp"
#include "..\utility\utility.hpp"


/*
	Author: HangoverIt

	Description:
	Follows all road nodes and executes callback function

	Parameter(s):
		0 (Mandatory): Postion array to start the road walk from
		1 (Mandatory): Callback function called for each road node
		2 (Optional): Custom data that persists across road nodes. Prime the data here or defaults to empty array
		3 (Optional): Radius to search for first road near position (default 50)
		4 (Optional): Maximum walks to perfrom before quitting (default 100000)

	Returns:
	BOOL
*/
params ["_pos", "_fn", ["_customdata", []], ["_radius", 50], ["_maxiterations", 100000]] ;

// Assume that this function starts near a road, caller will need to find that road
private _roads = _pos nearRoads _radius;
if (count _roads == 0) exitWith {false} ;
private _aroad = (_roads select 0);
private _lastroads = [_aroad] ;
private _lastCustomData = _customdata ;
private _stack = createStack ;
private _exit = false ;
private _allvisted = [] ;

while {!_exit && _maxiterations > 0} do {
  _connected = roadsConnectedTo[_aroad, false] ;

  //diag_log format["%1 connected roads for %2, ignoring roads %3", _connected, _aroad, _lastroads] ;
  {
    if (!(_x in _allvisted)) then {
   	  // add any road branches or next section
	  //diag_log format["Pushing road %1", _x] ;
	  _cpydata = +_lastCustomData ;
	  _val = [_x, _cpydata];
	  pushStack(_stack,_val) ;
	};
  }forEach _connected ;

  if (stackSize(_stack) > 0) then{
    _allvisted pushBack _aroad ; // record where we've been
	_val = popStack(_stack);
	_aroad = _val select 0;
	_lastCustomData = _val select 1;
	//diag_log format["Popping and processing road %1, remaining branches %2", _aroad, stackSize(_stack)] ;
	_exit = !([_aroad,_lastCustomData] call _fn) ;
  }else{
    _exit = true ;
  };
  _maxiterations = _maxiterations - 1 ;
};

true ;