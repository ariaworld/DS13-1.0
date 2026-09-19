//Returns the number of crewmembers that have existed this round. This includes the living and the dead
/proc/get_historic_crew_total()
	return GLOB.all_crew.len

//Returns the number of live crewmembers
/proc/get_living_crew_total()
	return GLOB.living_crew.len

//Returns the number of living crewmembers aboard the ship (space turfs are excluded), the rest are considered marooned. Ignores connection status.
/proc/get_living_crew_aboard_ship()
	var/count = 0
	for(var/datum/mind/M in GLOB.living_crew)
		var/mob/living/L = M.current
		if(isStationLevel(L.z) && !istype(get_turf(L), /turf/space))
			count++
	return count

/*
	Returns a list of all living crewmembers whose role fits the filter
	If role type is true, checks special role (AKA, antag status)
	If false, checks assigned job
*/
//Option sets either to check assigned role or special role. Default to assigned.
/proc/find_targets_by_role(role, role_type=0)
	. = list()
	for(var/datum/mind/possible_target in GLOB.minds)
		if(((role_type ? possible_target.special_role : possible_target.assigned_role) == role) )
			. += possible_target