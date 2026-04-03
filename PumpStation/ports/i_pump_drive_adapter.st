
interface IPumpVfdDriveAdapter

    method assignToVfd
    var_input unitId : int; end_var
    end_method

    method transferToBypass
    var_input unitId : int; end_var
    end_method

    method stopUnit
    var_input unitId : int; end_var
    end_method

    method getVfdFrequency : lreal
    end_method

    method getVfdStatus : VfdState
    end_method

end_interface