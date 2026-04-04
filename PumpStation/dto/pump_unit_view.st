
type PumpUnitView :
	struct
	    id : udint;
	    role : PumpRole;
	    available : bool;
	    faulted : bool;
	    active : bool;
	    power : real;
	end_struct;
end_type
