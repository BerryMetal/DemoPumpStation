type 
	PumpControllerViewModel : struct
	    isStarted : bool;
	    requestedPower : real;
	    activePower : real;
	
	    vfdUnitId : udint;
	    vfdFrequency : lreal;
	    vfdStatus : VfdState;
	end_struct;

end_type