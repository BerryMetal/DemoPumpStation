class PumpModbus implements IScadaModbus

var private
    modbus : Modbus.ModbusService;	    
    holdings, inputs : Modbus.ModbusSegment;
    notifier : Modbus.EmptyNotifier;
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
	
	holdings.setNotifier(notifier);
	inputs.setNotifier(notifier);
	
end_method

method public process_pdi 
var_in_out pdi : PumpStationControl; end_var
var 
	codec : PdiCodec;
end_var
	codec.init(0, holdings);
	codec.decode(pdi);
end_method

method public process_pdo 
var_input 
	ctrl_state : PumpControllerViewModel; 
	pumps_state : ref_to array[*] of PumpUnitView; 
end_var
var 
	codec : PdoCodec;
	i : udint;
end_var
	codec.init(0, inputs);
	
	codec.encode(ref(ctrl_state));
	for i := lower_bound(pumps_state, 1) 
				to upper_bound(pumps_state, 1) do codec.encode(ref(pumps_state^[i]));
	end_for
	
	inputs.publish();
end_method

method public iterate 
	modbus.process();
end_method

end_class
