#define SNAKE_SPAM_TICKS 600 //how long between cardboard box openings that trigger the '!'
/obj/structure/closet/cardboard
	name = "large cardboard box"
	desc = "Just a box..."
	icon_state = "cardboard"
	mob_storage_capacity = 1
	resistance_flags = FLAMMABLE
	max_integrity = 70
	integrity_failure = 0
	can_weld_shut = 0
	cutting_tool = /obj/item/wirecutters
	material_drop = /obj/item/stack/sheet/cardboard
	delivery_icon = "deliverybox"
	anchorable = FALSE
	open_sound = 'sound/machines/cardboard_box.ogg'
	close_sound = 'sound/machines/cardboard_box.ogg'
	open_sound_volume = 35
	close_sound_volume = 35
	var/move_speed_multiplier = 1
	var/move_delay = FALSE
	var/egged = 0

/obj/structure/closet/cardboard/relaymove(mob/living/user, direction)
	if(opened || move_delay || user.incapacitated() || !isturf(loc) || !has_gravity(loc))
		return
	move_delay = TRUE
	var/oldloc = loc
	set_glide_size(DELAY_TO_GLIDE_SIZE(CONFIG_GET(number/movedelay/walk_delay) * move_speed_multiplier))
	step(src, direction)
	if(oldloc != loc)
		animate(src, pixel_z = 4, time = 0)
		var/prev_trans = matrix(transform)
		animate(pixel_z = 0, transform = turn(transform, pick(-6, 0, 6)), time=2)
		animate(pixel_z = 0, transform = prev_trans, time = 0)
		playsound(loc, 'code/modules/wod13/sounds/snake_move.ogg', 25, FALSE)
		addtimer(CALLBACK(src, PROC_REF(ResetMoveDelay)), CONFIG_GET(number/movedelay/walk_delay) * move_speed_multiplier)
	else
		move_delay = FALSE

/obj/structure/closet/cardboard/proc/ResetMoveDelay()
	move_delay = FALSE

/obj/structure/closet/cardboard/open(mob/living/user, force = FALSE)
	if(opened || !can_open(user, force))
		return FALSE
	var/list/alerted = null
	if(egged < world.time)
		var/mob/living/Snake = null
		for(var/mob/living/L in src.contents)
			Snake = L
			break
		if(Snake)
			alerted = viewers(7,src)
	..()
	if(LAZYLEN(alerted))
		egged = world.time + SNAKE_SPAM_TICKS
		for(var/mob/living/L in alerted)
			if(!L.stat)
				if(!L.incapacitated(ignore_restraints = 1))
					L.face_atom(src)
				L.do_alert_animation()
		playsound(loc, 'code/modules/wod13/sounds/snake.ogg', 50, FALSE, -5)

/// Does the MGS ! animation
/atom/proc/do_alert_animation()
	var/image/I = image('icons/obj/closet.dmi', src, "cardboard_special", layer+1)
	flick_overlay_view(I, src, 8)
	I.alpha = 0
	animate(I, pixel_z = 32, alpha = 255, time = 5, easing = ELASTIC_EASING)


/obj/structure/closet/cardboard/metal
	name = "large metal box"
	desc = "THE COWARDS! THE FOOLS!"
	icon_state = "metalbox"
	max_integrity = 500
	mob_storage_capacity = 5
	resistance_flags = NONE
	move_speed_multiplier = 2
	cutting_tool = /obj/item/weldingtool
	open_sound = 'sound/machines/crate_open.ogg'
	close_sound = 'sound/machines/crate_close.ogg'
	open_sound_volume = 35
	close_sound_volume = 50
	material_drop = /obj/item/stack/sheet/plasteel
#undef SNAKE_SPAM_TICKS
