program pump
	var 
		init : bool := false;
	end_var

VAR
	pump_units : array[1..5] of PumpUnit;
	
    vfd_drv : DriveAdapter;
    logger : TerminalLogger;
    units : UnitManager;
    pump_controller : PumpStationController;
    presenter : BasicPumpStationPresenter;

    scada_pdi : PumpStationControl;
    scada_pdo : PumpStationViewModel;
    
    pump_power : real := 100.0;
END_VAR

	if not init then 
		init := true;
		__carrier_invoke('support.printf', 'Setting up');

		units.init(ref(pump_units), pump_power);
		pump_controller.init(vfd_drv, logger, units);
		presenter.init(vfd_drv, units);
		
		scada_pdi.startCmd := true;
		scada_pdi.stopCmd := false;
		scada_pdi.setpointPower := 234;		
	end_if
	
	pump_controller.applyControl(scada_pdi);
	pump_controller.update();
	pump_controller.update();
	
	scada_pdo := presenter.buildView(ref(pump_controller));
		
end_program