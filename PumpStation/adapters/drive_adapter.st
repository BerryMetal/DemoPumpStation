class DriveAdapter implements IPumpVfdDriveAdapter

var
    lastAction : string;
    vfdFrequency : lreal;
    state : VfdState := VfdState#stopped;
end_var

method public assignToVfd
var_input unitId : int; end_var
    lastAction := 'assign VFD';
    vfdFrequency := 45.0;
    state := VfdState#running;
end_method

method public transferToBypass
var_input unitId : int; end_var
    lastAction := 'to bypass';
    vfdFrequency := 45.0;
    state := VfdState#running;
end_method

method public stopUnit
var_input unitId : int; end_var
    lastAction := 'stop';

    // for demo simplicity
    vfdFrequency := 0.0;
    state := VfdState#stopped;
end_method

method public getVfdFrequency : lreal
    getVfdFrequency := vfdFrequency;
end_method

method public getVfdStatus : VfdState
    getVfdStatus := state;
end_method

end_class