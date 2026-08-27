/obj/item/gun/energy/cutter
	name = "210-V Mining Cutter"
	desc = "A medium-power mining tool capable of splitting dense material with only a few directed blasts. Unsurprisingly, it is also an extremely deadly tool and should be handled with the utmost care. "
	charge_meter = 0
	icon = 'icons/obj/tools.dmi'
	icon_state = "miningcutter"
	item_state = "miningcutter"
	fire_sound = 'sound/weapons/plasma_cutter.ogg'
	w_class = ITEM_SIZE_SMALL
	force = 8
	origin_tech = list(TECH_MATERIAL = 4, TECH_PHORON = 4, TECH_ENGINEERING = 6, TECH_COMBAT = 3)
	matter = list(MATERIAL_STEEL = 4000)
	projectile_type = /obj/item/projectile/beam/cutter
	max_shots = 10
	charge_cost = 250

	cell_type = /obj/item/cell/plasmacutter
	slot_flags = SLOT_BACK
	charge_meter = FALSE	//if set, the icon state will be chosen based on the current charge
	mag_insert_sound = 'sound/weapons/guns/interaction/force_magin.ogg'
	mag_remove_sound = 'sound/weapons/guns/interaction/force_magout.ogg'
	removeable_cell = TRUE

	safety_state = 1	//This thing is too dangerous to lack safety
	var/bladed = FALSE
	var/icon_base = "miningcutter"
	var/bladed_icon = "miningcutter_blades"

/obj/item/gun/energy/cutter/empty
	cell_type = null

/obj/item/gun/energy/cutter/plasma
	name = "211-V Plasma Cutter"
	desc = "A high power plasma cutter designed to cut through tungsten reinforced bulkheads during engineering works. Also a rather hazardous improvised weapon, capable of severing limbs in a few shots."
	projectile_type = /obj/item/projectile/beam/cutter/plasma
	icon_base = "plasmacutter"
	bladed_icon = "plasmacutter_blades"

/obj/item/gun/energy/cutter/update_icon()
	icon_state = bladed ? bladed_icon : icon_base
	item_state = bladed ? bladed_icon : icon_base

/obj/item/gun/energy/cutter/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/weighted_blades) && !bladed)
		user.visible_message(SPAN_NOTICE("[user] starts applying the [W] to [src]"), SPAN_NOTICE("You start applying the [W] to [src]."))
		if(!use_tool(user = user, target = W, base_time = WORKTIME_NORMAL, required_quality = null, fail_chance = FAILCHANCE_EASY, required_stat = "construction", forced_sound = WORKSOUND_WRENCHING))
			return FALSE
		to_chat(user, SPAN_NOTICE("You have successfully installed [W] in [src]."))
		src.force = 12
		bladed = TRUE
		desc += "\nIt seems to be fitted with a set of weighted blades."
		update_icon()
		qdel(W)
		return TRUE
	return ..()

/obj/item/gun/energy/cutter/rending
	name = "211-S Plasma Cutter"
	desc = "An illegally modified plasma cutter designed to cut through bone. For some reason, flesh seems to absorb part of the impact."
	color = "#e97f83"
	icon_base = "plasmacutter"
	bladed_icon = "plasmacutter_blades"
	projectile_type = /obj/item/projectile/beam/cutter/rending
	charge_cost = 200

/obj/item/projectile/beam/cutter
	name = "plasma arc"
	damage = 12
	accuracy = 130	//Its a broad arc, easy to land hits on limbs with
	edge = 1
	damage_type = BRUTE //plasma is a physical object with mass, rather than purely burning. this also means you can decapitate/sever limbs, not just ash them.
	check_armour = "laser"
	kill_count = 5 //mining tools are not exactly known for their ability to replace firearms, they're good against necros, not so much against anything else.
	pass_flags = PASS_FLAG_TABLE
	structure_damage_factor = 3.5

	var/dig_power = 600

	muzzle_type = /obj/effect/projectile/trilaser/muzzle
	tracer_type = null
	impact_type = /obj/effect/projectile/trilaser/impact
	fire_sound = 'sound/weapons/plasma_cutter.ogg'

/obj/item/projectile/beam/cutter/Bump(var/atom/A, forced = 0)
	if(istype(A, /turf/simulated/mineral))
		var/turf/simulated/mineral/M = A
		if (dig_power)
			var/dig_amount = min(dig_power, (M.health+M.resistance))
			dig_power -= dig_amount
			M.dig(dig_amount)
	. = ..()

/obj/item/projectile/beam/cutter/plasma
	damage = 18.5
	kill_count = 7 //an upgrade over the mining cutter, used for engineering work, but still not a proper firearm
	dig_power = 900

/obj/item/projectile/beam/cutter/rending
	damage = 18.5
	tier_2_bonus = 1
	tier_3_bonus = 1
	kill_count = 6 //more sensitive to friction
	dig_power = 300 //No longer cuts rock well


//----------------------------
// Plasmacutter Effects
//----------------------------
/obj/effect/projectile/plasmacutter/
	light_color = COLOR_ORANGE

/obj/effect/projectile/plasmacutter/muzzle
	icon_state = "muzzle_plasmacutter"

/obj/effect/projectile/plasmacutter/impact
	icon_state = "impact_plasmacutter"


/*--------------------------
	Ammo
---------------------------*/

/obj/item/cell/plasmacutter
	name = "plasma energy"
	desc = "A light power pack designed for use with high energy cutting tools."
	origin_tech = list(TECH_POWER = 4)
	icon = 'icons/obj/ammo.dmi'
	icon_state = "darts"
	w_class = ITEM_SIZE_SMALL
	maxcharge = 2500
	matter = list(MATERIAL_STEEL = 700, MATERIAL_SILVER = 80)

/obj/item/cell/plasmacutter/update_icon()
	return

/*--------------------------
	Attachments
---------------------------*/

/obj/item/weighted_blades
	name = "weighted blades"
	desc = "A set of heavy and reinforced blades made to be attached in front of a plasma cutter, often used to avoid accidental damage to the tool. While not actually sharp, being struck by these would be painful."
	icon = 'icons/obj/weapons/weapon_modifications.dmi'
	icon_state = "weighted_blades"
	w_class = ITEM_SIZE_SMALL
	force = WEAPON_FORCE_WEAK
