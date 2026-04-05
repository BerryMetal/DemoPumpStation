

// @Test "UnitManager init assigns sequential ids and correct size"
FUNCTION Test_UnitManager_Init_SizeAndIds : bool
VAR
    mgr : UnitManager;
    units : array[5..7] of PumpUnit;
END_VAR
    // Act
    mgr.init(ref(units), 10.0);

    // Assert
    Test_UnitManager_Init_SizeAndIds :=
        (units[5].id = 1) and
        (units[6].id = 2) and
        (units[7].id = 3);
END_FUNCTION



// @Test "UnitManager init with null collection keeps manager empty"
FUNCTION Test_UnitManager_Init_NullCollection : bool
VAR
    mgr : UnitManager;
    h : unitHandle;
END_VAR
    // Act
    mgr.init(NULL, 10.0);
    h := mgr.findNextAvailable();

    // Assert
    Test_UnitManager_Init_NullCollection :=
        (h = NULL);
END_FUNCTION


// @Test "UnitManager findUnit returns handle for existing unit id"
FUNCTION Test_UnitManager_FindUnit_Existing : bool
VAR
    mgr : UnitManager;
    units : array[1..3] of PumpUnit;
    h : unitHandle;
END_VAR
    // Arrange
    mgr.init(ref(units), 10.0);

    // Act
    h := mgr.findUnit(2);

    // Assert
    Test_UnitManager_FindUnit_Existing :=
        (h <> NULL) and
        (h^.id = 2);
END_FUNCTION


// @Test "UnitManager findUnit returns null for missing id"
FUNCTION Test_UnitManager_FindUnit_Missing : bool
VAR
    mgr : UnitManager;
    units : array[1..3] of PumpUnit;
    h : unitHandle;
END_VAR
    // Arrange
    mgr.init(ref(units), 10.0);

    // Act
    h := mgr.findUnit(99);

    // Assert
    Test_UnitManager_FindUnit_Missing := h = NULL;
END_FUNCTION


// @Test "UnitManager findNextAvailable returns first available non faulted inactive unit"
FUNCTION Test_UnitManager_FindNextAvailable_FirstMatch : bool
VAR
    mgr : UnitManager;
    units : array[1..4] of PumpUnit;
    h : unitHandle;
END_VAR
    // Arrange
    mgr.init(ref(units), 10.0);

    units[1].available := false;
    units[1].faulted := false;
    units[1].role := PumpRole#stopped;

    units[2].available := true;
    units[2].faulted := true;
    units[2].role := PumpRole#stopped;

    units[3].available := true;
    units[3].faulted := false;
    units[3].role := PumpRole#stopped;

    units[4].available := true;
    units[4].faulted := false;
    units[4].role := PumpRole#stopped;

    // Act
    h := mgr.findNextAvailable();

    // Assert
    Test_UnitManager_FindNextAvailable_FirstMatch :=
        (h <> NULL) and
        (h^.id = 3);
END_FUNCTION


// @Test "UnitManager findNextAvailable skips active units"
// @data (role1:=0, role2:=1, expectedId:=2)
FUNCTION Test_UnitManager_FindNextAvailable_SkipsActive : bool
VAR_INPUT
    role1 : PumpRole;
    role2 : PumpRole;
    expectedId : udint;
END_VAR
VAR
    mgr : UnitManager;
    units : array[1..2] of PumpUnit;
    h : unitHandle;
END_VAR
    // Arrange
    mgr.init(ref(units), 10.0);

    units[1].available := true;
    units[1].faulted := false;
    units[1].role := role1;

    units[2].available := true;
    units[2].faulted := false;
    units[2].role := role2;

    // Act
    h := mgr.findNextAvailable();

    // Assert
    Test_UnitManager_FindNextAvailable_SkipsActive :=
        (h <> NULL) and
        (h^.id = expectedId);
END_FUNCTION


// @Test "UnitManager findNextAvailable returns null when no unit is eligible"
FUNCTION Test_UnitManager_FindNextAvailable_None : bool
VAR
    mgr : UnitManager;
    units : array[1..3] of PumpUnit;
    h : unitHandle;
END_VAR
    // Arrange
    mgr.init(ref(units), 10.0);

    units[1].available := false;
    units[2].available := true;
    units[2].faulted := true;
    units[3].available := true;
    units[3].faulted := false;
    units[3].role := PumpRole#onVfd;

    // Act
    h := mgr.findNextAvailable();

    // Assert
    Test_UnitManager_FindNextAvailable_None := h = NULL;
END_FUNCTION


// @Test "UnitManager findBypassUnit returns first bypass unit"
FUNCTION Test_UnitManager_FindBypassUnit_FirstMatch : bool
VAR
    mgr : UnitManager;
    units : array[1..4] of PumpUnit;
    h : unitHandle;
END_VAR
    // Arrange
    mgr.init(ref(units), 10.0);

    units[1].role := PumpRole#stopped;
    units[2].role := PumpRole#onVfd;
    units[3].role := PumpRole#onBypass;
    units[4].role := PumpRole#onBypass;

    // Act
    h := mgr.findBypassUnit();

    // Assert
    Test_UnitManager_FindBypassUnit_FirstMatch :=
        (h <> NULL) and
        (h^.id = 3);
END_FUNCTION


// @Test "UnitManager findBypassUnit returns null when no bypass unit exists"
FUNCTION Test_UnitManager_FindBypassUnit_None : bool
VAR
    mgr : UnitManager;
    units : array[1..3] of PumpUnit;
    h : unitHandle;
END_VAR
    // Arrange
    mgr.init(ref(units), 10.0);

    units[1].role := PumpRole#stopped;
    units[2].role := PumpRole#stopped;
    units[3].role := PumpRole#onVfd;

    // Act
    h := mgr.findBypassUnit();

    // Assert
    Test_UnitManager_FindBypassUnit_None := h = NULL;
END_FUNCTION


// @Test "UnitManager getActiveCount counts active units correctly"
FUNCTION Test_UnitManager_GetActiveCount : bool
VAR
    mgr : UnitManager;
    units : array[1..4] of PumpUnit;
END_VAR
    // Arrange
    mgr.init(ref(units), 10.0);

    units[1].role := PumpRole#stopped;
    units[2].role := PumpRole#onVfd;
    units[3].role := PumpRole#onBypass;
    units[4].role := PumpRole#stopped;

    // Act / Assert
    Test_UnitManager_GetActiveCount := mgr.getActiveCount() = 2;
END_FUNCTION


// @Test "UnitManager getUnitRole returns role by logical id"
FUNCTION Test_UnitManager_GetUnitRole_ById : bool
VAR
    mgr : UnitManager;
    units : array[5..7] of PumpUnit;
END_VAR
    // Arrange
    mgr.init(ref(units), 10.0);

    units[5].role := PumpRole#stopped;   // id = 1
    units[6].role := PumpRole#onBypass;  // id = 2
    units[7].role := PumpRole#onVfd;     // id = 3

    // Assert
    Test_UnitManager_GetUnitRole_ById :=
        mgr.getUnitRole(2) = PumpRole#onBypass;
END_FUNCTION


// @Test "UnitManager getUnitAvailable returns availability by logical id"
FUNCTION Test_UnitManager_GetUnitAvailable_ById : bool
VAR
    mgr : UnitManager;
    units : array[5..7] of PumpUnit;
END_VAR
    // Arrange
    mgr.init(ref(units), 10.0);

    units[5].available := false; // id = 1
    units[6].available := true;  // id = 2
    units[7].available := false; // id = 3

    // Assert
    Test_UnitManager_GetUnitAvailable_ById := mgr.getUnitAvailable(2);
END_FUNCTION



// @Test "UnitManager getUnitFaulted returns fault state by logical id"
FUNCTION Test_UnitManager_GetUnitFaulted_ById : bool
VAR
    mgr : UnitManager;
    units : array[5..7] of PumpUnit;
END_VAR
    // Arrange
    mgr.init(ref(units), 10.0);

    units[5].faulted := false; // id = 1
    units[6].faulted := true;  // id = 2
    units[7].faulted := false; // id = 3

    // Assert
    Test_UnitManager_GetUnitFaulted_ById := mgr.getUnitFaulted(2);
END_FUNCTION



// @Test "UnitManager getCurrentPower sums performance of all units"
FUNCTION Test_UnitManager_GetCurrentPower_Sum : bool
VAR
    mgr : UnitManager;
    units : array[1..3] of PumpUnit;
    power : real;
END_VAR
    // Arrange
    mgr.init(ref(units), 10.0);

    units[1].role := PumpRole#onVfd;
    units[2].role := PumpRole#onBypass;
    units[3].role := PumpRole#stopped;

    // Act
    power := mgr.getCurrentPower(50.0);

    // Assert
    Test_UnitManager_GetCurrentPower_Sum := power > 0.0;
END_FUNCTION
