/*
	Author: HangoverIt

	Description:
		Create the pool - load from saved data

	Parameter(s):
		None
    
	Returns:
		Pool
*/
#include "..\pool\pool.hpp"

// TO DO: load from config and from save file


if (isNil GROUPPOOL) then {
  CREATEGROUPPOOL;
};

private _pool = GROUPPOOLVAR ;

{
	_sidepool = createHashMap ;
	_sidepool set ["recon", 20] ;
	_sidepool set ["air", 10] ;
	_sidepool set ["assault", 10] ;
	_pool set [_x, _sidepool] ;
}forEach ([] call Sim_fnc_getFactionSides) ;

_pool ;