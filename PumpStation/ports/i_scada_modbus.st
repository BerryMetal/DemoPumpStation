interface IScadaModbus

method init 
	var_input
	    settings_segment : ref_to array [*] of word;
    	feedback_segment : ref_to array [*] of word;
	end_var
end_method

method process_pdi 
var_in_out pdi : PumpStationControl; end_var
end_method

method process_pdo 
var_input 
	ctrl_state : PumpControllerViewModel; 
	pumps_state : ref_to array[*] of PumpUnitView; 
end_var
end_method

method iterate end_method

end_interface