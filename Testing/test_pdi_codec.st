// @Test "PdiCodec decode with both command bits cleared"
// @data (control:=0, powerWord:=0, expectedStart:=0, expectedStop:=0, expectedPower:=0.0)
FUNCTION Test_PdiCodec_Decode_NoCommands : bool
VAR_INPUT
    control : word;
    powerWord : word;
    expectedStart : bool;
    expectedStop : bool;
    expectedPower : real;
END_VAR
VAR
    codec : PdiCodec;
    entry : PumpStationControl;
    words : array[0..1] of word;
    seg : Modbus.ModbusSegment;
END_VAR
    // Arrange
    words[0] := control;
    words[1] := powerWord;
    seg.attachReadable('mbs', Modbus.ModbusArea#holds, 0, ref(words));
    codec.init(0, seg);

    entry.startCmd := true;
    entry.stopCmd := true;
    entry.setpointPower := -999.0;

    // Act
    codec.decode(entry);

    // Assert
    Test_PdiCodec_Decode_NoCommands :=
        (entry.startCmd = expectedStart) and
        (entry.stopCmd = expectedStop) and
        (entry.setpointPower = expectedPower);
END_FUNCTION


// @Test "PdiCodec decode start command only"
// @data (control:=1, powerWord:=100, expectedStart:=1, expectedStop:=0, expectedPower:=100.0)
FUNCTION Test_PdiCodec_Decode_StartOnly : bool
VAR_INPUT
    control : word;
    powerWord : word;
    expectedStart : bool;
    expectedStop : bool;
    expectedPower : real;
END_VAR
VAR
    codec : PdiCodec;
    entry : PumpStationControl;
    words : array[0..1] of word;
    seg : Modbus.ModbusSegment;
END_VAR
    words[0] := control;
    words[1] := powerWord;
    
    seg.attachReadable('mbs', Modbus.ModbusArea#holds, 0, ref(words));
    codec.init(0, seg);

    entry.startCmd := false;
    entry.stopCmd := true;
    entry.setpointPower := -1.0;

    codec.decode(entry);

    Test_PdiCodec_Decode_StartOnly :=
        (entry.startCmd = expectedStart) and
        (entry.stopCmd = expectedStop) and
        (entry.setpointPower = expectedPower);
END_FUNCTION


// @Test "PdiCodec decode stop command only"
// @data (control:=2, powerWord:=250, expectedStart:=0, expectedStop:=1, expectedPower:=250.0)
FUNCTION Test_PdiCodec_Decode_StopOnly : bool
VAR_INPUT
    control : word;
    powerWord : word;
    expectedStart : bool;
    expectedStop : bool;
    expectedPower : real;
END_VAR
VAR
    codec : PdiCodec;
    entry : PumpStationControl;
    words : array[0..1] of word;
    seg : Modbus.ModbusSegment;
END_VAR
    words[0] := control;
    words[1] := powerWord;
    seg.attachReadable('mbs', Modbus.ModbusArea#holds, 0, ref(words));
    codec.init(0, seg);

    entry.startCmd := true;
    entry.stopCmd := false;
    entry.setpointPower := -1.0;

    codec.decode(entry);

    Test_PdiCodec_Decode_StopOnly :=
        (entry.startCmd = expectedStart) and
        (entry.stopCmd = expectedStop) and
        (entry.setpointPower = expectedPower);
END_FUNCTION


// @Test "PdiCodec decode both command bits set"
// @data (control:=3, powerWord:=500, expectedStart:=1, expectedStop:=1, expectedPower:=500.0)
FUNCTION Test_PdiCodec_Decode_BothCommands : bool
VAR_INPUT
    control : word;
    powerWord : word;
    expectedStart : bool;
    expectedStop : bool;
    expectedPower : real;
END_VAR
VAR
    codec : PdiCodec;
    entry : PumpStationControl;
    words : array[0..1] of word;
    seg : Modbus.ModbusSegment;
END_VAR
    words[0] := control;
    words[1] := powerWord;
    seg.attachReadable('mbs', Modbus.ModbusArea#holds, 0, ref(words));
    codec.init(0, seg);

    entry.startCmd := false;
    entry.stopCmd := false;
    entry.setpointPower := -1.0;

    codec.decode(entry);

    Test_PdiCodec_Decode_BothCommands :=
        (entry.startCmd = expectedStart) and
        (entry.stopCmd = expectedStop) and
        (entry.setpointPower = expectedPower);
END_FUNCTION


// @Test "PdiCodec decode ignores unrelated control bits"
// @data (control:=16#0004, powerWord:=77, expectedStart:=0, expectedStop:=0, expectedPower:=77.0)
// @data (control:=16#8000, powerWord:=88, expectedStart:=0, expectedStop:=0, expectedPower:=88.0)
// @data (control:=16#FFFF, powerWord:=99, expectedStart:=1, expectedStop:=1, expectedPower:=99.0)
FUNCTION Test_PdiCodec_Decode_IgnoreOtherBits : bool
VAR_INPUT
    control : word;
    powerWord : word;
    expectedStart : bool;
    expectedStop : bool;
    expectedPower : real;
END_VAR
VAR
    codec : PdiCodec;
    entry : PumpStationControl;
    words : array[0..1] of word;
    seg : Modbus.ModbusSegment;
END_VAR
    words[0] := control;
    words[1] := powerWord;
    seg.attachReadable('mbs', Modbus.ModbusArea#holds, 0, ref(words));
    codec.init(0, seg);

    entry.startCmd := false;
    entry.stopCmd := false;
    entry.setpointPower := -1.0;

    codec.decode(entry);

    Test_PdiCodec_Decode_IgnoreOtherBits :=
        (entry.startCmd = expectedStart) and
        (entry.stopCmd = expectedStop) and
        (entry.setpointPower = expectedPower);
END_FUNCTION


// @Test "PdiCodec decode from non zero offset"
// @data (dummy0:=111, control:=3, powerWord:=222, expectedStart:=1, expectedStop:=1, expectedPower:=222.0)
FUNCTION Test_PdiCodec_Decode_WithOffset : bool
VAR_INPUT
    dummy0 : word;
    control : word;
    powerWord : word;
    expectedStart : bool;
    expectedStop : bool;
    expectedPower : real;
END_VAR
VAR
    codec : PdiCodec;
    entry : PumpStationControl;
    words : array[0..2] of word;
    seg : Modbus.ModbusSegment;
END_VAR
    words[0] := dummy0;
    words[1] := control;
    words[2] := powerWord;

    seg.attachReadable('mbs', Modbus.ModbusArea#holds, 0, ref(words));
    codec.init(1, seg);

    entry.startCmd := false;
    entry.stopCmd := false;
    entry.setpointPower := -1.0;

    codec.decode(entry);

    Test_PdiCodec_Decode_WithOffset :=
        (entry.startCmd = expectedStart) and
        (entry.stopCmd = expectedStop) and
        (entry.setpointPower = expectedPower);
END_FUNCTION


// @Test "PdiCodec decode advances offset by two words"
FUNCTION Test_PdiCodec_Decode_UpdatesOffset : bool
VAR
    codec : PdiCodec;
    entry : PumpStationControl;
    words : array[0..3] of word;
    seg : Modbus.ModbusSegment;
END_VAR
    words[0] := 3;
    words[1] := 100;
    words[2] := 555;
    words[3] := 777;

    seg.attachReadable('mbs', Modbus.ModbusArea#holds, 0, ref(words));
    codec.init(0, seg);

    codec.decode(entry);

    Test_PdiCodec_Decode_UpdatesOffset := codec.getCurrentOffset() = 2;
END_FUNCTION
