type PumpStationViewModel :

	struct
	    isStarted : bool;
	    requestedUnits : uint;
	    activeUnits : uint;
	
	    vfdUnitId : int;
	    vfdFrequency : lreal;
	    vfdStatus : VfdState;
	
	    pumps : array[1..4] of PumpUnitView;
	end_struct;

end_type