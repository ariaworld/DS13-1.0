//"Wall" mounted vent variant. Pixelshifted to appear as though it's on the wall, however it should be placed on the floor to avoid suffocation / atmos issues.

/obj/machinery/atmospherics/unary/vent_pump/wall
	name = "Wall mounted vent pump"
	var/cover = TRUE //Is the wall-vent covered?
	layer = ABOVE_HUMAN_LAYER //So that the vents stack on top of the necromorphs.
	icon = 'icons/atmos/wallvent.dmi'
	icon_state = "off"

/obj/machinery/atmospherics/unary/vent_pump/wall/New(var/atom/location, var/direction, var/nocircuit = FALSE)
	..()
	icon = 'icons/atmos/wallvent.dmi'
	switch(dir)
		if(NORTH)
			pixel_y = -32
		if(SOUTH)
			pixel_y = 32
		if(EAST)
			pixel_x = -32
		if(WEST)
			pixel_x = 32

/obj/machinery/atmospherics/unary/vent_pump/wall/on
	use_power = 1
	icon_state = "map_vent_out"

/obj/machinery/atmospherics/unary/vent_pump/wall/siphon
	pump_direction = 0

/obj/machinery/atmospherics/unary/vent_pump/wall/siphon/on
	use_power = 1
	pump_direction = 0
	icon_state = "map_vent_in"

/obj/machinery/atmospherics/unary/vent_pump/wall/examine(mob/user)
	. = ..()
	if(!cover)
		to_chat(user, "<span class='warning'>Its cover has been torn away, leaving the duct wide open.[(!powered()) ? " It isn't moving any air." : " It keeps barely pumping air through the gap."]</span>")
	if(locate(/mob) in contents)
		to_chat(user, "<span class='warning'>There's something lurking inside it...</span>")

/obj/machinery/atmospherics/unary/vent_pump/wall/north
	dir = NORTH

/obj/machinery/atmospherics/unary/vent_pump/wall/south
	dir = SOUTH

/obj/machinery/atmospherics/unary/vent_pump/wall/east
	dir = EAST

/obj/machinery/atmospherics/unary/vent_pump/wall/west
	dir = WEST

/mob/living/proc/necro_burst_vent()
	set name = "Burst Through Vent"
	set category = "Necromorph"
	set desc = "Burst out of wall-vents."

	var/obj/machinery/atmospherics/unary/vent_pump/wall/W = locate(/obj/machinery/atmospherics/unary/vent_pump/wall) in get_turf(src)
	if(W && istype(W))
		W.exit_vent(src)


/mob/living/carbon/human/necromorph/is_allowed_vent_crawl_item(var/obj/item/carried_item)
	//FOR NOW. This is because necros can't really take their clothes off.
	if(istype(species, /datum/species/necromorph))
		return TRUE
	return ..()

/obj/machinery/atmospherics/unary/vent_pump/wall/update_icon(var/safety = 0)
	overlays.Cut()
	if (!node)
		use_power = 0

	if(!cover || (stat & BROKEN))
		icon_state = "broken_[pick(1,2,3)]"
	else if(welded)
		icon_state = "weld"
	else if(!powered())
		icon_state = "off"
	else
		icon_state = pump_direction ? "out" : "in"

#define TORN_VENT_POWER_FACTOR 0.5

/obj/machinery/atmospherics/unary/vent_pump/wall/proc/break_open(mob/breaker)
	if(cover)
		cover = FALSE
		power_rating = initial(power_rating) * TORN_VENT_POWER_FACTOR
	update_icon()
	shake_animation(10)
	breaker?.shake_animation(2)
	playsound(src, 'sound/effects/grillehit.ogg', 100, FALSE)
	var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
	s.set_up(5, 0, src)
	s.start()

/obj/machinery/atmospherics/unary/vent_pump/wall/attackby(var/obj/item/W as obj, var/mob/user as mob)
	//A burst vent has no cover left to weld shut, so the welder fits a new plate instead.
	if(!cover && isWelder(W))
		to_chat(user, "<span class='notice'>You begin welding a new cover onto \the [src].</span>")
		if(W.use_tool(user, src, WORKTIME_NORMAL, QUALITY_WELDING, FAILCHANCE_NORMAL))
			cover = TRUE
			power_rating = initial(power_rating) //plate back on, so it can move air properly again
			update_icon()
			user.visible_message("<span class='notice'>\The [user] welds a new cover onto \the [src].</span>", \
				"<span class='notice'>You have welded a new cover onto \the [src].</span>", \
				"You hear welding.")
		return 1
	return ..()

/obj/machinery/atmospherics/unary/vent_pump/wall/proc/exit_vent(mob/living/user)
	//If there's a cover, break that first.
	var/was_covered = cover
	if(was_covered)
		shake_animation(10)
		user.shake_animation(2)
		playsound(src.loc, 'sound/effects/vent_scare.ogg', 100, FALSE)
		cover = FALSE
		var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
		s.set_up(5, 0, src)
		s.start()
		update_icon() //This vent is now burst.
	if(was_covered)
		user.visible_message("<span class='userdanger'>[user] violently bursts out of [src]!</span>", "<span class='warning'>You burst through [src]!</span>")
	else
		user.visible_message("You hear something squeezing through the ducts.", "You climb out the ventilation system.")
	user.remove_ventcrawl()
	user.forceMove(get_turf(src)) //handles entering and so on
