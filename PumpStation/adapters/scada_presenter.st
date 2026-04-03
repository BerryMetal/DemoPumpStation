class BasicPumpStationPresenter implements IPumpStationPresenter

var
    drives : IPumpVfdDriveAdapter;
end_var

method public init
var_input d : IPumpVfdDriveAdapter; end_var
    drives := d;
end_method

method public buildView : PumpStationViewModel
var_input controller : ref_to PumpStationController; end_var

var
    vm : PumpStationViewModel;
    i : int;
end_var

    vm.isStarted := controller^.isStarted();
    vm.requestedUnits := controller^.getRequestedUnits();
    vm.activeUnits := controller^.getActiveUnits();

    vm.vfdUnitId := controller^.getVfdUnitId();
    vm.vfdFrequency := drives.getVfdFrequency();
    vm.vfdStatus := drives.getVfdStatus();

    for i := 1 to 4 do
        vm.pumps[i].id := int_to_uint(i);
        vm.pumps[i].role := controller^.getUnitRole(int_to_uint(i));
        vm.pumps[i].available := controller^.getUnitAvailable(int_to_uint(i));
        vm.pumps[i].faulted := controller^.getUnitFaulted(int_to_uint(i));
        vm.pumps[i].active := controller^.getUnitActive(int_to_uint(i));
    end_for

    buildView := vm;
end_method

end_class