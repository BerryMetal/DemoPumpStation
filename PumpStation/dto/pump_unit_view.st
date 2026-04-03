
type PumpUnitView :
	struct
	    id : udint;
	    role : PumpRole;
	    available : bool;
	    faulted : bool;
	    active : bool;
	end_struct;
end_type
