class BasicPumpStationPresenter implements IPumpStationPresenter

var
    drives : IPumpVfdDriveAdapter;
    units : IUnitManager;
end_var

method public init
var_input 
	d : IPumpVfdDriveAdapter;
	m : IUnitManager;
end_var
    drives := d;
    units := m;
end_method

method public buildView : PumpStationViewModel
var_input controller : ref_to PumpStationController; end_var

var
    vm : PumpStationViewModel;
    i : udint;
end_var

    vm.isStarted := controller^.isStarted();
    vm.requestedPower := controller^.getRequestedPower();
    vm.activePower := units.getCurrentPower(drives.getVfdFrequency());

    vm.vfdUnitId := controller^.getVfdUnitId();
    vm.vfdFrequency := drives.getVfdFrequency();
    vm.vfdStatus := drives.getVfdStatus();

    for i := 1 to 4 do
        vm.pumps[i].id := i;
        vm.pumps[i].role := units.getUnitRole(i);
        vm.pumps[i].available := units.getUnitAvailable(i);
        vm.pumps[i].faulted := units.getUnitFaulted(i);
        vm.pumps[i].active := units.getUnitActive(i);
    end_for

    buildView := vm;
end_method

end_class