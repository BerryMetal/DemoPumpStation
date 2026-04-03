type
	unitHandle : ref_to PumpUnit;
end_type


interface IUnitManager
	method init
		var_input 
			collection : ref_to array[*] of PumpUnit;
			nominal_power : real;		
		end_var
	end_method

	
	method getActiveCount : udint
	end_method
	
	method findNextAvailable : unitHandle
	end_method
	
	method findBypassUnit : unitHandle
	end_method

	method getSize : udint
	end_method  
	     
	
	method getUnitRole : PumpRole
	var_input index : udint; end_var
	end_method
	
	
	method getUnitAvailable : bool
	var_input index : udint; end_var
	end_method
	
	
	method getUnitFaulted : bool
	var_input index : udint; end_var
	end_method
	
	
	method getUnitActive : bool
	var_input index : udint; end_var
	end_method

	method getCurrentPower : real
	var_input freq : real; end_var
	end_method
	
end_interface