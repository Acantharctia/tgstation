/datum/surgery/lifesupport_fix
	name = "Life Support Maintenance"
	surgery_flags = SURGERY_SELF_OPERABLE
	organ_to_manipulate = ORGAN_SLOT_HEART
	possible_locs = list(BODY_ZONE_CHEST)
	steps = list (
		/datum/surgery_step/mechanic_open,
		/datum/surgery_step/mechanic_unwrench,
		/datum/surgery_step/pry_hatch,
		/datum/surgery_step/maintain_heart,
		/datum/surgery_step/drain_blood,
		/datum/surgery_step/mechanic_close
	)

/datum/surgery_step/pry_hatch
	name = "pry heart platting open"
	implements = (
		TOOL_CROWBAR = 100
		TOOL_SCREWDRIVER = 50
		)
	time = 2 SECONDS
	preop_sound = 'sound/items/crowbar.ogg'
	success_sound = 'sound/items/crowbar.ogg'

/datum/surgery_step/pry_hatch/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(
		user,
		target,
		span_notice("You pry [target]'s heart plating off."),
		span_notice("[user] pries [target]'s heart plating off. "),
		span_notice("[user] pries [target]'s heart plating off."),
	)

/datum/surgery_step/pry_hatch/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	if(ishuman(target))
		var/mob/living/carbon/human/target_human = target
		if (!HAS_TRAIT(target_human, TRAIT_NOBLOOD))
			display_results(
				user,
				target,
				span_notice("Blood pools around cogs and bolts in [target_human]'s heart."),
				span_notice("Blood pools around cogs and bolts in [target_human]'s heart."),
				span_notice("Blood pools around cogs and bolts in [target_human]'s heart."),
			)
			var/obj/item/bodypart/target_bodypart = target_human.get_bodypart(target_zone)
			target_bodypart.adjustBleedStacks(10)
			target_human.adjustBruteLoss(10)
	return ..()

/datum/surgery_step/pry_hatch/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	if(ishuman(target))
		var/mob/living/carbon/human/target_human = target
		display_results(
			user,
			target,
			span_warning("You screw up, applying too much force to the plate!"),
			span_warning("[user] screws up, causing them to hit [target_human]'s chest with the [tool]!"),
			span_warning("[user] screws up, causing them to hit [target_human]'s chest with the [tool]!"),
		)
		var/obj/item/bodypart/target_bodypart = target_human.get_bodypart(target_zone)
		target_bodypart.adjustBleedStacks(5)
		target_human.adjustBruteLoss(20)

/datum/surgery/maintain_heart
	name = "apply maintenance to heart (screwdriver)"
	implements = (
		TOOL_SCREWDRIVER = 80
		TOOL_SCAPEL = 10
	)
	time = 10 SECONDS

/datum/surgery_step/maintain_hear/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(
		user,
		target,
		span_notice("You tighthen [target]'s heart parts back into place."),
		span_notice("[user] uses the [tool] in [target]'s open heart cavity."),
		span_notice("[user] uses the [tool] in [target]'s open heart cavity.")
	)

/datum/surgery_step/maintain_heart/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	if(ishuman(target))
	target.setOrganLoss(ORGAN_SLOT_HEART, 30)
		var/mob/living/carbon/human/target_human = target
		if (!HAS_TRAIT(target_human, TRAIT_NOBLOOD))
			display_results(
				user,
				target,
				span_notice("Blood stops to leak from [target_human]'s heart."),
				span_notice("Blood stops to leak from [target_human]'s heart."),
				span_notice("Blood stops to leak from [target_human]'s heart.")
			)

/datum/surgery_step/maintain_heart/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	if(ishuman(target))
		var/mob/living/carbon/human/target_human = target
		display_results(
			user,
			target,
			span_warning("You unscrew up, making more blood leak from [target_human]'s heart!"),
			span_warning("[user] unscrews up, spilling blood over themselves!"),
			span_warning("[user] unscrews up, spilling blood over themselves!"),
		)
		var/obj/item/bodypart/target_bodypart = target_human.get_bodypart(target_zone)
		target_bodypart.adjustBleedStacks(20)
		target_human.adjustOrganLoss(ORGAN_SLOT_HEART, 10) // Don't fuck up

/datum/surgery_step/drain_blood
	name = "drain pooled blood (Blood Filter)"
		implements = list(/obj/item/blood_filter = 100)
		time = 10 SECONDS
		success_sound = 'sound/machines/ping.ogg'

/datum/surgery_step/drain_blood/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	if(ishuman(target))
	target.setOrganLoss(ORGAN_SLOT_HEART, 30)
		var/mob/living/carbon/human/target_human = target
		if (!HAS_TRAIT(target_human, TRAIT_NOBLOOD))
			display_results(
				user,
				target,
				span_notice("[user] drains the pooled blood from [target_human]'s chest."),
				span_notice("[user] drains the pooled blood from [target_human]'s chest."),
				span_notice("[user] drains the pooled blood from [target_human]'s chest.")
			)

/datum/surgery_step/maintain_heart/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	if(ishuman(target))
		var/mob/living/carbon/human/target_human = target
		display_results(
			user,
			target,
			span_warning("You screw up!"),
			span_warning("[user] screws up, spilling blood over themselves!"),
			span_warning("[user] screws up, spilling blood over themselves!"),
		)
		var/obj/item/bodypart/target_bodypart = target_human.get_bodypart(target_zone)
		target_bodypart.adjustBleedStacks(20)
