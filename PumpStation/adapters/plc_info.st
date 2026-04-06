
class LoopControl

var public 
	task_id : string;
	period, old_start : lint;
end_var

var private
	main_dur : lint;
	last_end, last_start : lint;
end_var

	method private get_task_finish : lint
	var
		res : dint;
		dur : lint;
	end_var
		res := __carrier_invoke('sys.get_task_finish_time', task_id, ref(dur));
		if res = 0 then 
			get_task_finish := dur;
		end_if
	end_method
	
	method private get_task_duration : lint
	var
		res : dint;
		dur : lint;
	end_var
		res := __carrier_invoke('sys.get_task_duration', task_id, ref(dur));
		if res = 0 then 
			get_task_duration := dur;
		end_if
	end_method
	
	method public get_period
		main_dur := this.get_task_duration();
		last_end := this.get_task_finish();
		last_start := last_end - main_dur;
		
		period := last_start - old_start;
		old_start := last_start;
	end_method

end_class
