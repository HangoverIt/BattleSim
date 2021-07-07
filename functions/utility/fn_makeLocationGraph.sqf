/*
	Author: HangoverIt

	Description:
	Road walk the map and build the location graph (takes a long time to run!)

	Parameter(s):
		0 (Mandatory): Graph to populate nodes and links
		1 (Mandatory): Location array (Sim game locations)
		2 (Optional): BOOL - show markers on map if true

	Returns:
	All markers (or empty list if showmarkers disabled)
*/
params["_graph", "_graphLocations", ["_showmarkers", false, [true]]] ;

private _all_markers = [] ;

_fn_createRoadMarker = {
	params["_road", ["_colour", "ColorBlack"]] ;

	private _info = getRoadInfo _road ;
	private _road_pos_end = _info select 7 ;
	private _end = createMarkerLocal [format["endroad%1", _road_pos_end], _road_pos_end] ;
	_all_markers pushBack _end ;
	_end setMarkerTypeLocal "hd_dot" ;
	_end setMarkerColor _colour ;

	_end ;
};

_fn_callback = {
	params["_road", "_custom"] ;

    private _info = getRoadInfo _road ;
    private _road_pos_start = _info select 6 ;
    private _road_pos_end = _info select 7 ;
	private _end = objNull ;
	if (_showmarkers) then {
		_end = [_road] call _fn_createRoadMarker ;
	};
	{
      // Check if close to a location
      _chk_loc_pos = _x select 1;
      _chk_loc_size = _x select 2;

      if ((_chk_loc_pos distance2D _road_pos_end) <= _chk_loc_size) then {
        // This road links to _loc
		if (_showmarkers) then {
			_end setMarkerColor "ColorGreen" ;
		};
		if (!([_graph, _custom select 0, _x] call Sim_fnc_linkExists) && _x isNotEqualTo (_custom select 0)) then {
			if (_showmarkers) then {
				_end setMarkerColor "ColorRed" ;
			};
			[_graph, _custom select 0, _x, _custom select 1, _custom select 2] call Sim_fnc_addLocationNode ;
			//diag_log format["%1 connected to %2", (_custom select 0) select 0, _x select 0] ;
		};
		// Update custom data - set to new location and reset distance
	    _custom set [0, _x] ; // reset location
	    _custom set [1, 0] ; // reset distance
		_custom set [2, []] ; // reset bread crumb path
      };
    }forEach _graphLocations;
	
	_custom set [1, (_custom select 1) + 1] ; // increment walk counter
	_path = _custom select 2;
	_path pushBack _road_pos_end; // add current road end coordinates to path
	_custom set [2, _path]; // add new bread crumb to path
	
	//if (_showmarkers) then {
	//	_end setMarkerText format["Pos: %1",_road_pos_end] ;
	//};
	true;
};

{
  private _ret = [_x select 1,_fn_callback, [_x,0,[]], _x select 2] call Sim_fnc_roadCallback;
  if (true) exitWith{} ; // Just do one location
}forEach _graphLocations ;

if (_showmarkers) then {
	{_x setMarkerColor "ColorGrey" ;} forEach _all_markers;
};

_all_markers ;