class PumpUnit

var
    id : uint;
    role : PumpRole := PumpRole#stopped;
    available : bool := true;
    faulted : bool := false;
end_var

method public init
var_input unitId : uint; end_var
    id := unitId;
end_method

method public isActive : bool
    isActive := role <> PumpRole#stopped;
end_method

end_class