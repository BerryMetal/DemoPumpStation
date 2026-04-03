program pump
	var 
		init : bool := false;
	end_var

VAR
    vfd_drv : DriveAdapter;
    logger : TerminalLogger;
    pump_controller : PumpStationController;
    prs : BasicPumpStationPresenter;

    scada : PumpStationControl;
    view : PumpStationViewModel;
END_VAR

	if not init then 
		init := true;
		__carrier_invoke('support.printf', 'Setting up');

		pump_controller.init(vfd_drv, logger);
		prs.init(vfd_drv);
		
		scada.startCmd := true;
		scada.stopCmd := false;
		scada.setpointUnits := 2;		
	end_if
	
	pump_controller.applyControl(scada);
	pump_controller.update();
	pump_controller.update();
	
	view := prs.buildView(ref(pump_controller));
		
end_program