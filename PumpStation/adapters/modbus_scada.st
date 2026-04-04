class PumpModbus implements IScadaModbus

var private
    modbus : Modbus.ModbusService;	    
    holdings, inputs : Modbus.ModbusSegment;
    mbTrace : Modbus.TraceNotifier;
    dummy : word;
end_var

method public init 
	var_input
	    settings_segment : ref_to array [*] of word;
    	feedback_segment : ref_to array [*] of word;
	end_var
	
	
	holdings.attachReadable('mbs', Modbus.ModbusArea#holds, 0, settings_segment);
	holdings.setRefreshMode(Modbus.ModbusRefreshMode#cyclic);
	                       
	inputs.attachWritable('mbs', Modbus.ModbusArea#inputs, 0, feedback_segment);
	inputs.setRefreshMode(Modbus.ModbusRefreshMode#cyclic);
                                                                                            
	modbus.register(holdings);
	modbus.register(inputs);
	
	holdings.setNotifier(mbTrace);
	inputs.setNotifier(mbTrace);
	
	
end_method

method public process_pdi 
var_in_out pdi : PumpStationControl; end_var

	pdi.startCmd := true;
	pdi.stopCmd := false;
	pdi.setpointPower := 123.0;
	
	holdings.requestRefresh();
	
end_method

method public process_pdo 
var_input 
	ctrl_state : PumpControllerViewModel; 
	pumps_state : ref_to array[*] of PumpUnitView; 
end_var

	inputs.writeRawWord(1, dummy);
	dummy := dummy + 1;
	inputs.publish();
end_method

method public iterate 
	modbus.process();
end_method

end_class
