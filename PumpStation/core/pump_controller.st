class PumpStationController

var
    drives : IPumpVfdDriveAdapter;
    logger : ILogger;

    units : array[1..4] of PumpUnit;

    requested : uint;
    started : bool;
    vfdIndex : int := -1;
end_var


method public init
var_input d : IPumpVfdDriveAdapter; l : ILogger; end_var
var i : uint; end_var
    drives := d;
    logger := l;

    for i := 1 to 4 do
        units[i].init(i);
    end_for
end_method


method public applyControl
var_input ctrl : PumpStationControl; end_var

    if ctrl.stopCmd then
        started := false;
        requested := 0;
        logger.info('Station stopped from SCADA');
        return;
    end_if

    if ctrl.startCmd then
        started := true;
    end_if

    if started then
        requested := ctrl.setpointUnits;
    else
        requested := 0;
    end_if

end_method


method private getActiveCount : uint
var i : uint; cnt : uint; end_var
    cnt := 0;
    for i := 1 to 4 do
        if units[i].isActive() then
            cnt := cnt + 1;
        end_if
    end_for
    getActiveCount := cnt;
end_method


method private findNextAvailable : int
var i : uint; end_var
    for i := 1 to 4 do
        if units[i].available and not units[i].faulted and not units[i].isActive() then
        	findNextAvailable := uint_to_int(i);
            return;
        end_if
    end_for
    findNextAvailable := -1;
end_method


method private findBypassUnit : int
var i : uint; end_var
    for i := 1 to 4 do
        if units[i].role = PumpRole#onBypass then
        	findBypassUnit := uint_to_int(i);
            return;
        end_if
    end_for
    findBypassUnit := -1;
end_method


method public update

var
    active : uint;
    next : int;
    bypass : int;
end_var

    active := this.getActiveCount();

    if not started then
        if active > 0 then
            if this.findBypassUnit() > 0 then
                bypass := this.findBypassUnit();
                drives.stopUnit(bypass);
                units[bypass].role := PumpRole#stopped;
            elsif vfdIndex > 0 then
                drives.stopUnit(vfdIndex);
                units[vfdIndex].role := PumpRole#stopped;
                vfdIndex := -1;
            end_if
        end_if
        return;
    end_if

    // increase demand
    if requested > active then

        next := this.findNextAvailable();
        if next = -1 then return; end_if

        if vfdIndex > 0 then
            drives.transferToBypass(vfdIndex);
            units[vfdIndex].role := PumpRole#onBypass;
            logger.info('Unit moved to bypass');
        end_if

        drives.assignToVfd(next);
        units[next].role := PumpRole#onVfd;
        vfdIndex := next;

        logger.info('Unit assigned to VFD');
    end_if

    // decrease demand
    if requested < active then
        bypass := this.findBypassUnit();

        if bypass > 0 then
            drives.stopUnit(bypass);
            units[bypass].role := PumpRole#stopped;
            logger.info('Bypass unit stopped');
        elsif vfdIndex > 0 then
            drives.stopUnit(vfdIndex);
            units[vfdIndex].role := PumpRole#stopped;
            vfdIndex := -1;
            logger.info('VFD unit stopped');
        end_if
    end_if

end_method


method public isStarted : bool
    isStarted := started;
end_method


method public getRequestedUnits : uint
    getRequestedUnits := requested;
end_method


method public getActiveUnits : uint
    getActiveUnits := this.getActiveCount();
end_method


method public getVfdUnitId : int
    getVfdUnitId := vfdIndex;
end_method


method public getUnitRole : PumpRole
var_input index : uint; end_var
    getUnitRole := units[index].role;
end_method


method public getUnitAvailable : bool
var_input index : uint; end_var
    getUnitAvailable := units[index].available;
end_method


method public getUnitFaulted : bool
var_input index : uint; end_var
    getUnitFaulted := units[index].faulted;
end_method


method public getUnitActive : bool
var_input index : uint; end_var
    getUnitActive := units[index].isActive();
end_method

end_class