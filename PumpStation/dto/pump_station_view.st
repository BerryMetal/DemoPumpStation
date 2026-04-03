type PumpStationViewModel :

	struct
	    isStarted : bool;
	    requestedPower : real;
	    activePower : real;
	
	    vfdUnitId : udint;
	    vfdFrequency : lreal;
	    vfdStatus : VfdState;
	
	    pumps : array[1..4] of PumpUnitView;
	end_struct;

end_type