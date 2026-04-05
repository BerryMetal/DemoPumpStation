
class PdoCodec extends ModbusBaseCodec

method public encode
var_input
    entry : ref_to PumpUnitView;
end_var
var
    cur : Modbus.ModbusCursor;
    states: word;
end_var
	
	if segment = NULL then return; end_if
	
    cur.attach(segment);
	cur.seek(offset);

    cur.writeDword(entry^.id);
    cur.writeWord(entry^.role);
    
    states.0 := entry^.available;
    states.1 := entry^.faulted;
    states.2 := entry^.active;
    cur.writeWord(states);
    
    cur.writeWord(this.realToModbusRounded(entry^.power));
    offset := cur.position();
end_method
	

method public encode
var_input
    entry : PumpControllerViewModel;
end_var
var
    cur : Modbus.ModbusCursor;
    states: word;
end_var
	
	if segment = NULL then return; end_if
	
    cur.attach(segment);
	cur.seek(offset);

	states.0 := entry.isStarted;
	states.%b1 := entry.vfdStatus;
	cur.writeWord(states);
	cur.writeWord(udint_to_word(entry.vfdUnitId));
	cur.writeWord(this.realToModbusRounded(entry.requestedPower));
	cur.writeWord(this.realToModbusRounded(entry.vfdFrequency));
	cur.writeWord(this.realToModbusRounded(entry.activePower));
    
    offset := cur.position();
end_method



end_class
