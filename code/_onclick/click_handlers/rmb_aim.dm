/datum/click_handler/rmb_aim
	var/obj/item/gun/gun	//What gun are they aiming

	var/min_interval = 0.6 SECONDS	//Minimum time between changing states (zoom in/zoom out) to make things feel less janky
	var/interval_timer_handle
	var/last_change = 0
	flags = CLICK_HANDLER_SUPPRESS_POPUP_MENU
	var/is_aiming = FALSE




/datum/click_handler/rmb_aim/Destroy()
	if (gun)
		gun.disable_aiming_mode()
	.=..()

//while RMB is held a left click also reports right=1 and would
//otherwise be mistaken for a right click (cancelling auto-fire and stopping the aim).
/datum/click_handler/rmb_aim/proc/is_right_click(var/list/modifiers)
	if (modifiers["button"])
		return modifiers["button"] == "right"
	return modifiers["right"] && !modifiers["left"]

/datum/click_handler/rmb_aim/MouseDown(object,location,control,params)
	var/list/modifiers = params2list(params)
	if(is_right_click(modifiers))
		object = resolve_world_target(object, params)

		if(object)
			user.face_atom(object)
		deltimer(interval_timer_handle)
		var/delta = world.time - last_change
		if (delta < min_interval)
			interval_timer_handle = addtimer(CALLBACK(src, .proc/start_aiming), min_interval - delta, TIMER_STOPPABLE)
		else
			start_aiming()
		return FALSE
	else
		left_mousedown = TRUE
	return TRUE

/datum/click_handler/rmb_aim/MouseUp(object,location,control,params)
	var/list/modifiers = params2list(params)
	if(is_right_click(modifiers))
		object = user.client.resolve_drag(object, params)



		deltimer(interval_timer_handle)
		var/delta = world.time - last_change
		if (delta < min_interval)
			interval_timer_handle = addtimer(CALLBACK(src, .proc/stop_aiming), min_interval - delta, TIMER_STOPPABLE)
		else
			stop_aiming()
		return FALSE
	else
		left_mousedown = FALSE
	return TRUE


/datum/click_handler/rmb_aim/MouseDrag(src_object,over_object,src_location,over_location,src_control,over_control,params)
	over_object = resolve_world_target(over_object, params)
	user.face_atom(over_object, TRUE)
	return TRUE


/datum/click_handler/rmb_aim/OnDblClick(var/atom/A, var/params)
	if (gun && usr)
		var/list/modifiers = params2list(params)
		if(modifiers["left"])
			if (gun.last_fire_attempt != world.time)
				gun.afterattack(A, usr, FALSE, params)
	return TRUE

/datum/click_handler/rmb_aim/proc/start_aiming()
	if (gun.enable_aiming_mode())
		last_change = world.time
		is_aiming = TRUE

/datum/click_handler/rmb_aim/proc/stop_aiming()
	if (gun.disable_aiming_mode())
		last_change = world.time
		is_aiming = FALSE