
class PdiCodec extends ModbusBaseCodec
	
method public decode
var_in_out
    entry : PumpStationControl;
end_var
var
    cur : Modbus.ModbusCursor;
    control: word;
end_var
	
	if segment = NULL then return; end_if
	
    cur.attach(segment);
	cur.seek(offset);

	control := cur.readWord();
	
	entry.startCmd := control.0;
	entry.stopCmd := control.1;
	entry.setpointPower := this.wordToRealValue(cur.readWord());
    
    offset := cur.position();
end_method
	

end_class
