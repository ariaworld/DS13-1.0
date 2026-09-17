//Spawning methods for things purchased at necroshop
#define SPAWN_POINT		1	//The thing is spawned in a random clear tile around a specified spawnpoint
#define SPAWN_PLACE		2	//The thing is manually placed by the user on a viable corruption tile

#define DIVIDER_COMPONENTS 	"<h2>Components:</h2><br>\
On death, dismemberment or manual splitting, the divider seperates into five smaller creatures. Two arms, two legs, and one head. <br>\
All of these have a basic attack and a leap ability, though the leap is quite different for each.<br>\
The goal of the head is to find a new host body to support itself. The arms and legs are servants, they exist to distract and weaken victims to draw attention from the head."

#define DIVIDER_ARM_DESC 	"<h2>Arm</h2><br>\
<h3>Basic Attack: Scratch: 2-4 dmg </h3><br>\
<h3>Passive: Wallrun</h3><br>\
<h3>Leap Ability: Parasite Grip (Alt+Click)</h3><br>\
The arm's leap ability will cause it to cling onto any human it hits, and start repeatedly attacking them. Each attack deals minor damage, and heals itself, though not targeting any specific bodypart.<br>\
In addition, each attack causes the victim to stagger around, disrupting their aim and view. Makes a great distraction!"

#define DIVIDER_LEG_DESC 	"<h2>Leg</h2><br>\
<h3>Basic Attack: Kick: 3-6 dmg </h3><br>\
<h3>Passive: Faster movespeed and lower leap cooldown</h3><br>\
<h3>Leap Ability: Dropkick (Alt+Click)</h3><br>\
The leg's leap ability hits hard, staggering the victim and dealing 15 damage. The leg bounces off the victim, allowing it to quickly circle around for another hit. This can be aimed, and it's possible to smash limbs off your victim."

#define DIVIDER_HEAD_DESC 	"<h2>Head</h2><br>\
<h3>Basic Attack: Whip: 4-6 dmg </h3><br>\
<br>\
<h3>Leap Ability: Hostile Takeover (Alt+Click)</h3><br>\
Requires a standing, live human victim. The head's leap starts an execution move, slowly strangling the victim until their neck is completely severed. Then it will wrap its tentacles around the spine and take control of the new host body.<br>\
Hostile Takeover cannot be cancelled once started, it's do or die.<br>\
If successful, the marker is awarded bonus biomass!<br>\
<h3>Alternate Ability: Reanimate (Ctrl+Alt+Click)</h3><br>\
Reanimate can be used to take control of any already-headless corpse on the ground. This is safe and easy, but does not give any extra rewards"

#define NECROMORPH_ACID_POWER	0.7	//Damage per unit of necromorph organic acid, used by many things
#define NECROMORPH_FRIENDLY_FIRE_FACTOR	0.5	//All damage dealt by necromorphs TO necromorphs, is multiplied by this
#define NECROMORPH_ACID_COLOR	"#946b36"

//Maximum bonus to evasion tripod gets for being in an open space
#define TRIPOD_PERSONAL_SPACE_MAX_EVASION	35

//Minimum power levels for bioblasts to trigger the appropriate ex_act tier
#define BIOBLAST_TIER_1	120
#define BIOBLAST_TIER_2	60
#define BIOBLAST_TIER_3	30



//Errorcodes returned from a biomass source
#define MASS_READY	"ready"	//Nothing is wrong, ready to absorb
#define MASS_ACTIVE	"active"//The source is ready to absorb, but it needs to be handled carefully and asked each time you absorb from it
#define MASS_PAUSE	"pause"	//Not ready to deliver, but keep this source in the list and check again next tick
#define MASS_EXHAUST	"exhaust"	//All mass is gone, delete this source
#define MASS_FAIL	"fail"	//The source can't deliver anymore, maybe its not in range of where it needs to be



#define CORRUPTION_SPREAD_RANGE	12	//How far from the source corruption spreads
#define CORRUPTION_FIRE_DAMAGE_FACTOR	2	//Damage dealt to corruption from high heat is multiplied by this value
#define CORRUPTION_SCORCH_DURATION	(1 MINUTE)	//Corruption hit by fire cannot regrow in that tile for this quantity of time


#define MAW_EAT_RANGE	2	//Nom distance of a maw node


//Biomass harvest defines. These are quantites per second that a machine gives when under the grip of a harvester
//Remember that there are often 10+ of any such machine in its appropriate room, and each gives a quantity
#define BIOMASS_HARVEST_LARGE	0.04
#define BIOMASS_HARVEST_MEDIUM	0.03
#define BIOMASS_HARVEST_SMALL	0.015

//This is intended for use with active sources which have a limited total quantity to distribute.
//Don't allow infinite sources to give out biomass at this rate
#define BIOMASS_HARVEST_ACTIVE	0.1

//Not for gameplay use, debugging only
#define BIOMASS_HARVEST_DEBUG	10

//Items in vendors are worth this* their usual biomass, to make them last longer as sources
#define VENDOR_BIOMASS_MULT	5

//One unit (10ml) of purified liquid biomass can be multiplied by this value to create one kilogram of solid biomass
#define REAGENT_TO_BIOMASS	0.01

#define BIOMASS_TO_REAGENT	100



#define PLACEMENT_FLOOR	"floor"
#define PLACEMENT_WALL	"wall"


#define BIOMASS_REQ_T2	850
#define BIOMASS_REQ_T3	1350
#define BIOMASS_REQ_T4	3825

#define DAM_MOD_T1 0.91
#define DAM_MOD_T2 1.25
#define DAM_MOD_T3 1.35

/*
	Customisation parameters
*/
#define SIGNAL_DEFAULT	"red"
#define VARIANT	"variant"
#define OUTFIT	"outfit"
#define WEIGHT	"weight"
#define PATRON	"patron"



/*

*/
#define OBJECTIVE_BIOMASS_VERY_LOW	140
#define OBJECTIVE_BIOMASS_LOW	    270
#define OBJECTIVE_BIOMASS_MED   	595
#define OBJECTIVE_BIOMASS_HIGH	    810