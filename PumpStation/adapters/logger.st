class TerminalLogger implements ILogger

var
    last : string;
end_var

method public info
var_input msg : string; end_var
    last := msg;
    __carrier_invoke('support.printf', 'Pump logger: %', msg);
end_method

end_class