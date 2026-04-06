class PumpStationController implements IControllerState

var private
    drives : IPumpVfdDriveAdapter;
    logger : ILogger;
    units :  IPumpUnits;
    
    requested : real;
    started : bool;
    vfdUnit : unitHandle := NULL;
end_var


method public init
var_input d : IPumpVfdDriveAdapter; l : ILogger; m : IPumpUnits; end_var
    drives := d;
    logger := l;
	units  := m;
end_method


method public applyControl
var_input ctrl : PumpStationControl; end_var

    if ctrl.stopCmd then
    	if started then logger.info('Station stopped from SCADA');
    	end_if
    	
        started := false;
        requested := 0;
        return;
    end_if

    if ctrl.startCmd then
        started := true;
    end_if

    if started then
        requested := ctrl.setpointPower;
    else
        requested := 0;
    end_if

end_method

    
method public update
var
    activePower : real;
    unit : unitHandle;
    frequency : real;
    frequency_step : real := 0.01;
end_var
	
	if drives = NULL or units = NULL then return; end_if
	
	frequency := drives.getVfdFrequency();
    activePower := units.getCurrentPower(drives.getVfdFrequency());
    
    if not started then
    	drives.setVfdFrequency(0.0);
        if activePower > 0.0 then
    		unit := units.findBypassUnit();
            if unit <> NULL then
                drives.stopUnit(unit^.id);
                unit^.role := PumpRole#stopped;
            elsif vfdUnit <> NULL then
                drives.stopUnit(vfdUnit^.id);
                vfdUnit^.role := PumpRole#stopped;
                vfdUnit := NULL;
            end_if
        end_if
        return;
    end_if

    // increase demand
    if requested > activePower then

        unit := units.findNextAvailable();
        if unit = NULL then return; end_if

		if vfdUnit <> NULL then	
        
        	if drives.increaseFrequency(frequency_step) then 
        		return;
        	end_if
        	
        	drives.transferToBypass(vfdUnit^.id);
        	drives.setVfdFrequency(50.0);
        	vfdUnit^.role := PumpRole#onBypass;
        	logger.info('Unit moved to bypass');			
		end_if
		
        drives.assignToVfd(unit^.id);
        unit^.role := PumpRole#onVfd;
        vfdUnit := unit;

        logger.info('Unit assigned to VFD');
    end_if

    // decrease demand
    if requested < activePower then
    		
    	if vfdUnit <> NULL then    	
            if drives.decreaseFrequency(frequency_step) then 
        		return;
        	end_if
        	
        	unit := units.findBypassUnit();
			if unit <> NULL then 
	            drives.stopUnit(unit^.id);
	            unit^.role := PumpRole#stopped;
	            logger.info('Bypass unit stopped');
	            drives.setVfdFrequency(50.0);
        	else
	            drives.stopUnit(vfdUnit^.id);
	            vfdUnit^.role := PumpRole#stopped;
	            vfdUnit := NULL;
	            logger.info('VFD unit stopped');	        
        	end_if
        end_if
    end_if

end_method


method public isStarted : bool
    isStarted := started;
end_method

method public getRequestedPower : real
    getRequestedPower := requested;
end_method

method public getVfdUnitId : udint
	if vfdUnit <> NULL then 
    	getVfdUnitId := vfdUnit^.id;
    end_if
    
end_method

end_class