
class UnitManager implements IUnitManager
	var private
		units : ref_to array[*] of PumpUnit;
		start, end : udint;
		size : udint;
	end_var

	method private isValid : bool
		if units = NULL then return; end_if
		if size = 0 then return; end_if
		isValid := true;
	end_method

	
	method public init
		var_input 
			collection : ref_to array[*] of PumpUnit; 
			nominal_power : real;
		end_var
		var i : udint; end_var
	
		if collection = NULL then return; end_if
		start := lower_bound(collection, 1);
		end := upper_bound(collection, 1);
		size := 1 + end - start;
		units := collection;
		
		for i := start to end do
        	units^[i].init(i - start + 1, nominal_power);
    	end_for
    	
	end_method

	
	method public getActiveCount : udint
	var i : udint; cnt : udint; end_var
	    for i := start to end do
	        if units^[i].isActive() then
	            cnt := cnt + 1;
	        end_if
	    end_for
	    getActiveCount := cnt;
	end_method


	method public findNextAvailable : unitHandle
	var i : udint; end_var
		if not this.isValid() then return; end_if
		
	    for i := start to end do
	        if units^[i].available and not units^[i].faulted and not units^[i].isActive() then
	        	findNextAvailable := ref(units^[i]);
	            return;
	        end_if
	    end_for
	end_method
	
	
	method public findBypassUnit : unitHandle
	var i : udint; end_var
		if not this.isValid() then return; end_if
	    for i := start to end do
	        if units^[i].role = PumpRole#onBypass then
	        	findBypassUnit := ref(units^[i]);
	            return;
	        end_if
	    end_for
	end_method

	method getSize : udint
		getSize := size;
	end_method	        
	     
	
	method public getUnitRole : PumpRole
	var_input i : udint; end_var
		getUnitRole := PumpRole#error;
		if not this.isValid() then return; end_if
	
	    for i := start to end do
	        if units^[i].id = i then
	        	getUnitRole := units^[i].role;
	            return;
	        end_if
	    end_for
	end_method
	
	
	method public getUnitAvailable : bool
	var_input i : udint; end_var
	        
		if not this.isValid() then return; end_if
	
	    for i := start to end do
	        if units^[i].id = i then
	        	getUnitAvailable := units^[i].available;
	            return;
	        end_if
	    end_for
	        
	end_method
	
	
	method public getUnitFaulted : bool
	var_input i : udint; end_var
	       
	    getUnitFaulted := true;
		if not this.isValid() then return; end_if
	
	    for i := start to end do
	        if units^[i].id = i then
	        	getUnitFaulted := units^[i].faulted;
	            return;
	        end_if
	    end_for
	        
	end_method
	
	
	method public getUnitActive : bool
	var_input i : udint; end_var
	    
		if not this.isValid() then return; end_if
	
	    for i := start to end do
	        if units^[i].id = i then
	        	getUnitActive := units^[i].isActive();
	            return;
	        end_if
	    end_for
	end_method

	        
	method getCurrentPower : real
	var_input freq : real; end_var
	var i : udint; end_var
		if not this.isValid() then return; end_if
	    for i := start to end do
		    getCurrentPower := getCurrentPower + units^[i].getPerformance(freq);
	    end_for	        
	end_method

	    
end_class