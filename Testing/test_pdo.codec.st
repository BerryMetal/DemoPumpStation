
// @Test "PdoCodec encode PumpUnitView basic field mapping"
// @data (id:=16#12345678, expectedIdLo:=16#5678, expectedIdHi:=16#1234, role:=7, available:=1, faulted:=0, active:=1, power:=123, expectedStates:=5, expectedPower:=123)
FUNCTION Test_PdoCodec_Encode_PumpUnitView_Basic : bool
VAR_INPUT
    id : dword;
    expectedIdLo : word;
    expectedIdHi : word;
    role : PumpRole;
    available : bool;
    faulted : bool;
    active : bool;
    power : real;
    expectedStates : word;
    expectedPower : word;
END_VAR
VAR
    codec : PdoCodec;
    seg : Modbus.ModbusSegment;
    words : array[0..7] of word;
    entry : PumpUnitView;
END_VAR
    // Arrange
    entry.id := id;
    entry.role := role;
    entry.available := available;
    entry.faulted := faulted;
    entry.active := active;
    entry.power := power;

    seg.attachWritable('mbs', Modbus.ModbusArea#inputs, 0, ref(words));
    codec.init(0, seg);

    // Act
    codec.encode(ref(entry));
	
    // Assert
    Test_PdoCodec_Encode_PumpUnitView_Basic :=
        (words[0] = expectedIdLo) and
        (words[1] = expectedIdHi) and
        (words[2] = role) and
        (words[3] = expectedStates) and
        (words[4] = expectedPower) and
        (codec.getCurrentOffset() = 5);
END_FUNCTION


// @Test "PdoCodec encode PumpUnitView state bit packing"
// @data (available:=0, faulted:=0, active:=0, expectedStates:=0)
// @data (available:=1, faulted:=0, active:=0, expectedStates:=1)
// @data (available:=0, faulted:=1, active:=0, expectedStates:=2)
// @data (available:=0, faulted:=0, active:=1, expectedStates:=4)
// @data (available:=1, faulted:=1, active:=0, expectedStates:=3)
// @data (available:=1, faulted:=0, active:=1, expectedStates:=5)
// @data (available:=0, faulted:=1, active:=1, expectedStates:=6)
// @data (available:=1, faulted:=1, active:=1, expectedStates:=7)
FUNCTION Test_PdoCodec_Encode_PumpUnitView_States : bool
VAR_INPUT
    available : bool;
    faulted : bool;
    active : bool;
    expectedStates : word;
END_VAR
VAR
    codec : PdoCodec;
    seg : Modbus.ModbusSegment;
    words : array[0..7] of word;
    entry : PumpUnitView;
END_VAR
    // Arrange
    words[0] := 16#AAAA;
    words[1] := 16#BBBB;
    words[2] := 16#CCCC;
    words[3] := 16#DDDD;
    words[4] := 16#EEEE;
    words[5] := 16#FFFF;
    words[6] := 16#1111;
    words[7] := 16#2222;

    entry.id := 1;
    entry.role := 2;
    entry.available := available;
    entry.faulted := faulted;
    entry.active := active;
    entry.power := 0.0;

    seg.attachWritable('mbs', Modbus.ModbusArea#inputs, 0, ref(words));
    codec.init(0, seg);

    // Act
    codec.encode(ref(entry));

    // Assert
    Test_PdoCodec_Encode_PumpUnitView_States := words[3] = expectedStates;
END_FUNCTION


// @Test "PdoCodec encode PumpUnitView from non zero offset"
// @data (startOffset:=2, id:=16#00000001, role:=9, available:=1, faulted:=1, active:=0, power:=4.2, expectedStates:=3, expectedPower:=4)
FUNCTION Test_PdoCodec_Encode_PumpUnitView_WithOffset : bool
VAR_INPUT
    startOffset : uint;
    id : dword;
    role : PumpRole;
    available : bool;
    faulted : bool;
    active : bool;
    power : real;
    expectedStates : word;
    expectedPower : word;
END_VAR
VAR
    codec : PdoCodec;
    seg : Modbus.ModbusSegment;
    words : array[0..9] of word;
    entry : PumpUnitView;
END_VAR
    // Arrange
    words[0] := 111;
    words[1] := 222;
    words[2] := 0;
    words[3] := 0;
    words[4] := 0;
    words[5] := 0;
    words[6] := 0;
    words[7] := 0;
    words[8] := 999;
    words[9] := 888;

    entry.id := id;
    entry.role := role;
    entry.available := available;
    entry.faulted := faulted;
    entry.active := active;
    entry.power := power;

    seg.attachWritable('mbs', Modbus.ModbusArea#inputs, 0, ref(words));
    codec.init(startOffset, seg);

    // Act
    codec.encode(ref(entry));
				
    // Assert
    Test_PdoCodec_Encode_PumpUnitView_WithOffset :=
        (words[startOffset + 2] = role) and
        (words[startOffset + 3] = expectedStates) and
        (words[startOffset + 4] = expectedPower) and
        (codec.getCurrentOffset() = startOffset + 5);
END_FUNCTION


// -@Test "PdoCodec encode PumpControllerViewModel basic field mapping"
// @data (isStarted:=1, vfdStatus:=0, vfdUnitId:=25, requestedPower:=10.0, vfdFrequency:=50.0, activePower:=8.5, expectedStates:=1, expectedRequested:=100, expectedFreq:=500, expectedActive:=85)
FUNCTION Test_PdoCodec_Encode_Controller_Basic : bool
VAR_INPUT
    isStarted : bool;
    vfdStatus : bool;
    vfdUnitId : udint;
    requestedPower : real;
    vfdFrequency : real;
    activePower : real;
    expectedStates : word;
    expectedRequested : word;
    expectedFreq : word;
    expectedActive : word;
END_VAR
VAR
    codec : PdoCodec;
    seg : Modbus.ModbusSegment;
    words : array[0..7] of word;
    entry : PumpControllerViewModel;
END_VAR
    // Arrange
    words[0] := 0;
    words[1] := 0;
    words[2] := 0;
    words[3] := 0;
    words[4] := 0;
    words[5] := 0;
    words[6] := 0;
    words[7] := 0;

    entry.isStarted := isStarted;
    entry.vfdStatus := vfdStatus;
    entry.vfdUnitId := vfdUnitId;
    entry.requestedPower := requestedPower;
    entry.vfdFrequency := vfdFrequency;
    entry.activePower := activePower;

    seg.attachWritable('mbs', Modbus.ModbusArea#inputs, 0, ref(words));
    codec.init(0, seg);

    // Act
    codec.encode(ref(entry));

    // Assert
    Test_PdoCodec_Encode_Controller_Basic :=
        (words[0] = expectedStates) and
        (words[1] = udint_to_word(vfdUnitId)) and
        (words[2] = expectedRequested) and
        (words[3] = expectedFreq) and
        (words[4] = expectedActive) and
        (codec.getCurrentOffset() = 5);
END_FUNCTION


// -@Test "PdoCodec encode PumpControllerViewModel state bit packing"
// @data (isStarted:=0, vfdStatus:=0, expectedStates:=0)
// @data (isStarted:=1, vfdStatus:=0, expectedStates:=1)
// @data (isStarted:=0, vfdStatus:=1, expectedStates:=2)
// @data (isStarted:=1, vfdStatus:=1, expectedStates:=3)
FUNCTION Test_PdoCodec_Encode_Controller_States : bool
VAR_INPUT
    isStarted : bool;
    vfdStatus : bool;
    expectedStates : word;
END_VAR
VAR
    codec : PdoCodec;
    seg : Modbus.ModbusSegment;
    words : array[0..7] of word;
    entry : PumpControllerViewModel;
END_VAR
    // Arrange
    words[0] := 16#FFFF;
    words[1] := 16#FFFF;
    words[2] := 16#FFFF;
    words[3] := 16#FFFF;
    words[4] := 16#FFFF;
    words[5] := 16#FFFF;
    words[6] := 16#FFFF;
    words[7] := 16#FFFF;

    entry.isStarted := isStarted;
    entry.vfdStatus := vfdStatus;
    entry.vfdUnitId := 1;
    entry.requestedPower := 0.0;
    entry.vfdFrequency := 0.0;
    entry.activePower := 0.0;

    seg.attachWritable('mbs', Modbus.ModbusArea#inputs, 0, ref(words));
    codec.init(0, seg);

    // Act
    codec.encode(ref(entry));

    // Assert
    Test_PdoCodec_Encode_Controller_States := words[0] = expectedStates;
END_FUNCTION


// -@Test "PdoCodec encode PumpControllerViewModel from non zero offset"
// @data (startOffset:=3, isStarted:=1, vfdStatus:=1, vfdUnitId:=17, requestedPower:=12.5, vfdFrequency:=48.7, activePower:=11.1, expectedStates:=3, expectedRequested:=125, expectedFreq:=487, expectedActive:=111)
FUNCTION Test_PdoCodec_Encode_Controller_WithOffset : bool
VAR_INPUT
    startOffset : uint;
    isStarted : bool;
    vfdStatus : bool;
    vfdUnitId : udint;
    requestedPower : real;
    vfdFrequency : real;
    activePower : real;
    expectedStates : word;
    expectedRequested : word;
    expectedFreq : word;
    expectedActive : word;
END_VAR
VAR
    codec : PdoCodec;
    seg : Modbus.ModbusSegment;
    words : array[0..11] of word;
    entry : PumpControllerViewModel;
END_VAR
    // Arrange
    words[0] := 101;
    words[1] := 102;
    words[2] := 103;
    words[3] := 0;
    words[4] := 0;
    words[5] := 0;
    words[6] := 0;
    words[7] := 0;
    words[8] := 999;
    words[9] := 998;
    words[10] := 997;
    words[11] := 996;

    entry.isStarted := isStarted;
    entry.vfdStatus := vfdStatus;
    entry.vfdUnitId := vfdUnitId;
    entry.requestedPower := requestedPower;
    entry.vfdFrequency := vfdFrequency;
    entry.activePower := activePower;

    seg.attachWritable('mbs', Modbus.ModbusArea#inputs, 0, ref(words));
    codec.init(startOffset, seg);

    // Act
    codec.encode(ref(entry));

    // Assert
    Test_PdoCodec_Encode_Controller_WithOffset :=
        (words[startOffset + 0] = expectedStates) and
        (words[startOffset + 1] = udint_to_word(vfdUnitId)) and
        (words[startOffset + 2] = expectedRequested) and
        (words[startOffset + 3] = expectedFreq) and
        (words[startOffset + 4] = expectedActive) and
        (codec.getCurrentOffset() = startOffset + 5);
END_FUNCTION


