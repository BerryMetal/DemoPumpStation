interface IPumpStationPresenter

	method public init
	var_input 
		d : IPumpVfdDriveAdapter;
		m : IPumpUnits;
		c : IControllerState;
	end_var
	end_method

    method buildControllerView : PumpControllerViewModel
    end_method

    method buildPumpView : PumpUnitView
	    var_input id : udint; end_var
    end_method
    
end_interface