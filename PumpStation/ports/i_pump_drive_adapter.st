
interface IPumpVfdDriveAdapter

    method assignToVfd
    var_input unitId : udint; end_var
    end_method

    method transferToBypass
    var_input unitId : udint; end_var
    end_method

    method stopUnit
    var_input unitId : udint; end_var
    end_method

    method getVfdFrequency : real
    end_method

    method getVfdStatus : VfdState
    end_method

	method public setVfdFrequency : real
	var_input freq : real; end_var
	end_method
    
	method public increaseFrequency : bool
	    var_input increment : real; end_var
	end_method
	
	method public decreaseFrequency : bool
	    var_input decrement : real; end_var
	end_method

	
end_interface