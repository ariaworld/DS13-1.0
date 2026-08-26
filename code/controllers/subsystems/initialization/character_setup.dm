SUBSYSTEM_DEF(character_setup)
	name = "Character Setup"
	init_order = SS_INIT_CHAR_SETUP
	priority = SS_PRIORITY_CHAR_SETUP
	flags = SS_BACKGROUND
	wait = 1 SECOND
	runlevels = RUNLEVEL_LOBBY | RUNLEVELS_DEFAULT

	var/list/chars_awaiting_load = list()
	var/list/preferences_datums = list()
	var/list/newplayers_requiring_init = list()

	var/list/save_queue = list()

/datum/controller/subsystem/character_setup/Initialize()
	drain_pending_setup()
	. = ..()

/datum/controller/subsystem/character_setup/fire(resumed = FALSE)
	if(!drain_pending_setup())
		return

	while(save_queue.len)
		var/datum/preferences/prefs = save_queue[save_queue.len]
		save_queue.len--

		if(!QDELETED(prefs))
			prefs.save_preferences()

		if(MC_TICK_CHECK)
			return

/datum/controller/subsystem/character_setup/proc/drain_pending_setup()
	while(length(chars_awaiting_load))
		var/datum/preferences/prefs = chars_awaiting_load[length(chars_awaiting_load)]
		--chars_awaiting_load.len
		if(!QDELETED(prefs))
			prefs.lateload_character()
		if(!initialized)
			CHECK_TICK
		else if(MC_TICK_CHECK)
			return FALSE

	while(length(newplayers_requiring_init))
		var/mob/dead/new_player/new_player = newplayers_requiring_init[length(newplayers_requiring_init)]
		--newplayers_requiring_init.len
		if(!QDELETED(new_player))
			new_player.deferred_login()
		if(!initialized)
			CHECK_TICK
		else if(MC_TICK_CHECK)
			return FALSE

	return TRUE

/datum/controller/subsystem/character_setup/proc/queue_preferences_save(var/datum/preferences/prefs)
	save_queue |= prefs

/datum/controller/subsystem/character_setup/proc/queue_load_character(var/datum/preferences/prefs)
	chars_awaiting_load |= prefs
