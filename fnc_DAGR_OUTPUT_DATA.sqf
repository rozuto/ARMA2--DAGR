#include "script_component.hpp"

disableSerialization;

private ["_pos", "_x", "_y", "_xgrid", "_pos", "_ygrid", "_lastY", "_lastX", "_xcoord", "_ycoord", "_sec", "_min", "_hour", "_time", "_display", "_speed", "_vic", "_dagrHeading", "_dagrGrid"];



if (local player) then {
	
	cutRsc ["DAGR_DISPLAY", "plain down"];
	_display = (uiNameSpace getVariable "DAGR_DISPLAY");

	_gridControl = _display displayCtrl 266851;
	_speedControl = _display displayCtrl 266852;
	_elevationControl = _display displayCtrl 266853;
	_headingControl = _display displayCtrl 266854;
	_timeControl = _display displayCtrl 266855;
	_background = _display displayCtrl 266856;
	
	_background ctrlSetText QUOTE(PATHTOF(data\dagr_gps.paa));

	while {DAGR_RUN} do {
		if (Dagr_Map_Info == "default") then {
			_dagrGrid = mapGridPosition player;
		} else {
			//GRID
			_pos = getPos player;
			_x = _pos select 0;
			_y = _pos select 1;
	
			switch (Dagr_Map_Info) do {
				case "chernarus": {
					_xgrid = floor (_x / 10);
					_ygrid = floor ((15360 - _y) / 10);
				};
				case "utes": {
					_xgrid = floor (_x / 10);
					_ygrid = floor ((5120 - _y) / 10);
				};
				case "panthera2": {
					_xgrid = floor (_x / 10);
					_ygrid = floor ((10240 - _y) / 10);
				};
				case "namalsk": {
					_xgrid = floor (_x / 10);
					_ygrid = floor ((12800 - _y) / 10);	
				};
			};

			//Incase grids go neg due to 99-00 boundry
			if (_xgrid < 0) then {_xgrid = _xgrid + 9999;};
			if (_ygrid < 0) then {_ygrid = _ygrid + 9999;};

			_xcoord =
				if (_xgrid >= 1000) then {
					str _xgrid;
				} else {
					if (_xgrid >= 100) then {
						"0" + str _xgrid;
					} else {
						if (_xgrid >= 10) then {
							"00" + str _xgrid;
						}else{
							"000" + str _xgrid;
						};
					};
				};

			_ycoord =
				if (_ygrid >= 1000) then {
					str _ygrid;
				} else {
					if (_ygrid >= 100) then {
						"0" + str _ygrid;
					} else {
						if (_ygrid >= 10) then {
							"00" + str _ygrid;
						}else{
							"000" + str _ygrid;
						};
					};
				};
			_dagrGrid = _xcoord + " " + _ycoord;
		};
		
		//SPEED
		if (vehicle player != player) then {
			_vic = vehicle player;
			_speed = speed _vic;
		}else{
			_speed = speed player;
		};
		_speed = floor (_speed *10) / 10;
		_speed = abs(_speed);
		_dagrspeed = str _speed + "kph";

		//Elevation
		_elevation = getPosASL player;
		_elevation = floor (_elevation select 2);
		_dagrElevation = str _elevation + "m";

		//Heading
		if (vehicle player != player) then {
			_vic = vehicle player;
			_dagrHeading = floor (direction _vic);
		}else{
			_dagrHeading = floor (direction player);
		};

		//Time
		_time = daytime;
		_hour = floor (_time);
		_min  = floor ((_time mod 1) * 60);
		

		_hr =
			if (_hour >= 10) then {
				str _hour;
			} else {
				if (_hour >= 1) then {
					"0" + str _hour;
				} else {
					"00" + str _hour;
				};
			};
		_mn =
			if (_min >= 10) then {
				str _min;
			} else {
				"0" + str _min;

			};		

		_dagrTime = _hr + ":" + _mn;

		//output
		_gridControl ctrlSetText format ["%1", _dagrGrid];
		_speedControl ctrlSetText format ["%1", _dagrSpeed];
		_elevationControl ctrlSetText format ["%1", _dagrElevation];
		_headingControl ctrlSetText format ["%1", _dagrHeading];
		_timeControl ctrlSetText format ["%1", _dagrTime];

		sleep DAGRSLEEP;
	};
};