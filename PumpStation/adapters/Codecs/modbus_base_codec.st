
class ModbusBaseCodec

var protected
        offset : udint := 0;
        segment : Modbus.IModbusSegmentAccess;
end_var


method public getCurrentOffset : udint
	getCurrentOffset := offset;
end_method


method protected clampInt16 : int
var_input
    value : dint;
end_var
    if value > 32767 then
        clampInt16 := 32767;
    elseif value < -32768 then
        clampInt16 := -32768;
    else
        clampInt16 := dint_to_int(value);
    end_if
end_method


method protected roundToDint : dint
var_input
    value : real;
end_var
    if value >= 0.0 then
        roundToDint := real_to_dint(value + 0.5);
    else
        roundToDint := real_to_dint(value - 0.5);
    end_if
end_method


method protected realToModbusRounded : word
var_input 
	in : real;
end_var
	realToModbusRounded := int_to_word(
    						this.clampInt16(
    								this.roundToDint(in)));
end_method


method protected wordToRealValue : real
var_input in : word; end_var
	wordToRealValue := word_to_real(in);
end_method

method public init
var_input 
	new_offset : uint; 
	target_segment : Modbus.IModbusSegmentAccess;
end_var
offset := new_offset;
segment := target_segment;
end_method

end_class
