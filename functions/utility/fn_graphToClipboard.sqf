/*
	Author: HangoverIt

	Description:
	Dump a hashmap of the game locations to the clipboard 

	Parameter(s):
		0 (Mandatory): Graph to dump

	Returns:
	BOOL
*/
params["_graph"] ;

private _br = toString [13,10];
private _cliptext = "// Auto generated location graph" + _br ;
_cliptext = _cliptext + "private _a = [" + _br ;
_firstentry = true ;
{
	if (!_firstentry) then {
		_cliptext = _cliptext + "," + _br ;
	};
	_cliptext = _cliptext + "[" ;
	_firstentry = false ;
	_first = true ;
	_cliptext = _cliptext + str(_x) + ",createHashMapFromArray" + str(_y) ;
	_cliptext = _cliptext + "]" ;
}forEach _graph ;

_cliptext = _cliptext + _br + "];" + _br ;
_cliptext = _cliptext + "createHashMapFromArray _a;";


copyToClipboard _cliptext;

true ;