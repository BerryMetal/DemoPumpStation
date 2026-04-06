
type PumpsDef: udint (
		total := 5
);
end_type



program pump
var 
	init 		  : bool := false;
	pump_power 	: real := 100.0;
	id 			: udint;
	
	time_check     	 : LoopControl := (task_id := 'Pump');
	
    scada_pdo_ctrl      : PumpControllerViewModel;
    scada_pdi 		  : PumpStationControl;
    scada_pdo_pump 	 : array [1..PumpsDef#total] of PumpUnitView;	
	pump_units 		 : array[1..PumpsDef#total] of PumpUnit;
    
    io_scada    		: PumpModbus;
    vfd_drv 			: DriveAdapter;
    logger 	 		: TerminalLogger;
    units 	  		: UnitManager;
    pump_controller     : PumpStationController;
    presenter 		  : BasicPumpStationPresenter;
end_var

	if not init then 
		init := true;
		__carrier_invoke('support.printf', 'Setting up');

		units.init(ref(pump_units), pump_power);
		pump_controller.init(vfd_drv, logger, units);
		presenter.init(vfd_drv, units, pump_controller);
		
		io_scada.init(ref(scada_settings_segment), ref(scada_feedback_segment));
		
		scada_pdi.startCmd := true;
		scada_pdi.stopCmd := false;
		scada_pdi.setpointPower := 234;	
		
	end_if
	
	pump_controller.applyControl(scada_pdi);
	pump_controller.update();
	
	scada_pdo_ctrl := presenter.buildControllerView();
	for id:=1 to PumpsDef#total do
		scada_pdo_pump[id] := presenter.buildPumpView(id);
	end_for;
	
	io_scada.process_pdi(scada_pdi);
	io_scada.process_pdo(scada_pdo_ctrl, ref(scada_pdo_pump));
	io_scada.iterate();
	
	time_check.get_period();		
end_program

