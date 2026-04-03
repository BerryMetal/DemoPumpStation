class PumpUnit

var
    id : udint;
    role : PumpRole := PumpRole#stopped;
    available : bool := true;
    faulted : bool := false;
end_var

var private
	performance : real;
end_var

method public getPerformance : real
	var_input freq : real; end_var
	if role = PumpRole#stopped OR role = PumpRole#error then return; 
	elseif role = PumpRole#onBypass then
		getPerformance := performance;
		return;
	else 
		getPerformance := performance * (freq / 50.0);
	end_if
end_method

method public init
var_input 
	unitId : udint; 
	nominal : real;	
end_var
	performance := nominal;
    id := unitId;
end_method

method public isActive : bool
    isActive := role <> PumpRole#stopped;
end_method

end_class