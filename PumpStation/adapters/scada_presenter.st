class BasicPumpStationPresenter implements IPumpStationPresenter

var
    drives : IPumpVfdDriveAdapter;
    units : IPumpUnits;
    controller : IControllerState;
end_var

method public init
var_input 
	d : IPumpVfdDriveAdapter;
	m : IPumpUnits;
	c : IControllerState;
end_var
    drives := d;
    units := m;
    controller := c;
end_method


method public buildControllerView : PumpControllerViewModel
var
    vm : PumpControllerViewModel;
    i : udint;
end_var
	
	if units = NULL or controller = NULL then return; end_if
	
    vm.isStarted := controller.isStarted();
    vm.requestedPower := controller.getRequestedPower();
    vm.vfdUnitId := controller.getVfdUnitId();
        
    vm.activePower := units.getCurrentPower(drives.getVfdFrequency());
    vm.vfdFrequency := drives.getVfdFrequency();
    vm.vfdStatus := drives.getVfdStatus();

    buildControllerView := vm;
end_method


method public buildPumpView : PumpUnitView
var_input 
	id : udint; 
end_var
var 
	vm : PumpUnitView;
	unit : unitHandle;
end_var

	if units = NULL or drives = NULL then return; end_if
	
	unit := units.findUnit(id);
	if unit <> NULL then
    vm.id := id;
    
    vm.role := unit^.role;
    vm.available := unit^.available;
    vm.faulted := unit^.faulted;
    vm.active := unit^.isActive();
    vm.power := unit^.getPerformance(drives.getVfdFrequency());
	end_if
	
    buildPumpView := vm;
end_method



end_class