/proc/get_historic_major_vessel_total()
	var/total = 0
	for (var/typepath in SSnecromorph.spawned_necromorph_types)
		//Currently, only human subtypes are major vessels
		if (!ispath(typepath, /mob/living/carbon/human))
			continue

		total += SSnecromorph.spawned_necromorph_types[typepath]

	return total


/proc/link_necromorphs_to(var/message, var/target)
	for (var/ckey in SSnecromorph.necromorph_players)
		if (!ckey)
			continue
		var/datum/player/P = get_or_create_player(ckey)
		var/mob/M = P.get_mob()
		if (M && M.client)
			var/personal_message = replacetext(message, "LINK", jumplink_public(M, target))
			to_chat(M, personal_message)




//Global Necromorph Procs
//-------------------------
/proc/message_necromorphs(var/message, var/include_admins = TRUE, var/messaged = list())
	//Message all the necromorphs
	for (var/ckey in SSnecromorph.necromorph_players)
		var/datum/player/P = SSnecromorph.necromorph_players[ckey]
		var/mob/M = P.get_mob()
		if (!(M in messaged))
			to_chat(M, message)
			messaged += M


	//Message all the admins too, but only if they have show necrochat enabled
	var/list/valid_admins = GLOB.admins - messaged
	for(var/client/C in valid_admins)
		if ((C.mob in messaged))
			continue
		if(C.get_preference_value(/datum/client_preference/show_necrochat) == GLOB.PREF_SHOW)
			to_chat(C.mob, message)
			messaged += C.mob

	//Message all the unitologists too
	/*
	for(var/atom/M in GLOB.unitologists_list)
		to_chat(M, "<span class='cult'>[src]: [message]</span>")
		*/

//Shambler (divider puppet) HUD indicator
//-------------------------
//Builds the overlay shown above a divider puppet's head
/proc/get_shambler_indicator(var/mob/living/carbon/human/H)
	if (!istype(H))
		return
	var/image/I = image('icons/mob/hud.dmi', loc = H, icon_state = "hudshambler", layer = ABOVE_HUMAN_LAYER)
	I.plane = GAME_PLANE
	return I

//Pushes the hudshambler overlay to every online necromorph player
/proc/update_shambler_indicator(var/mob/living/carbon/human/H, var/state)
	if (!istype(H))
		return
	if (state)
		if (!(H in SSnecromorph.shamblers))
			SSnecromorph.shamblers |= H
		var/image/I = get_shambler_indicator(H)
		for (var/ckey in SSnecromorph.necromorph_players)
			var/datum/player/P = SSnecromorph.necromorph_players[ckey]
			var/mob/M = P.get_mob()
			if (M == H)	//The puppet doesn't need to see an indicator over their own head
				continue
			if (M && M.client)
				M.client.images |= I
	else
		SSnecromorph.shamblers -= H
		for (var/ckey in SSnecromorph.necromorph_players)
			var/datum/player/P = SSnecromorph.necromorph_players[ckey]
			var/mob/M = P.get_mob()
			if (M == H)
				continue
			if (!M || !M.client)
				continue
			for (var/image/old in M.client.images.Copy())
				if (old.icon_state == "hudshambler" && old.loc == H)
					M.client.images -= old
					qdel(old)

//Called when a mob joins the necromorph team so it sees any shamblers already in play
/proc/refresh_shambler_indicators(var/mob/M)
	if (!M || !M.client)
		return
	for (var/mob/living/carbon/human/H in SSnecromorph.shamblers)
		if (H == M)
			continue
		M.client.images |= get_shambler_indicator(H)