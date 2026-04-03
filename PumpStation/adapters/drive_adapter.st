class DriveAdapter implements IPumpVfdDriveAdapter

var private
    lastAction : string;
    vfdFrequency : real;
    state : VfdState := VfdState#stopped;
    
    minFrequency : real := 5.0;
    maxFrequency : real := 50.0;
end_var

method public assignToVfd
var_input unitId : udint; end_var
    lastAction := 'assign VFD';
    vfdFrequency := minFrequency;
    state := VfdState#running;
end_method

method public transferToBypass
var_input unitId : udint; end_var
    lastAction := 'to bypass';
    state := VfdState#running;
end_method

method public stopUnit
var_input unitId : udint; end_var
    lastAction := 'stop';
    vfdFrequency := 0.0;
    state := VfdState#stopped;
end_method

method public setVfdFrequency : real
    var_input freq : real; end_var
    if freq > maxFrequency then vfdFrequency := maxFrequency; 
    elseif freq < minFrequency then vfdFrequency := minFrequency;
    else vfdFrequency := freq;
    end_if
    
    setVfdFrequency := vfdFrequency;
end_method

method public increaseFrequency : bool
    var_input increment : real; end_var
    increaseFrequency := true;
    if this.setVfdFrequency(vfdFrequency + increment) >= maxFrequency then 
		increaseFrequency := false;
	end_if
end_method

method public decreaseFrequency : bool
    var_input decrement : real; end_var
    decreaseFrequency := true;
    if this.setVfdFrequency(vfdFrequency - decrement) <= minFrequency then 
		decreaseFrequency := false;
	end_if
end_method	
    
method public getVfdFrequency : real
    getVfdFrequency := vfdFrequency;
end_method

method public getVfdStatus : VfdState
    getVfdStatus := state;
end_method

end_class