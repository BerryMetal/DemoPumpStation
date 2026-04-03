
type PumpUnitView :
	struct
	    id : uint;
	    role : PumpRole;
	    available : bool;
	    faulted : bool;
	    active : bool;
	end_struct;
end_type
