-- Final Fantasy Brave Exvius: ffbeAuto -  Farming & Exploration
-- by tinotk, modded by Sikat, modded further by NonceCents
-- Memu 960x600 120dpi
-- Nox 960x600 160dpi
-- http://ankulua.boards.net/thread/167/brave-exvius-ffbeauto-farming-explorations
-- now at http://ankulua.boards.net/thread/589/ffbeauto-continued-farming-chaining-arena


--[[
KNOWN ISSUES:
Arena Auto-Battle broken - 9/3 - Should be fixed now, awaiting feedback!
Chain Helper manual mode is broken

NonceCents' TO DO LIST:
-Test in other resolutions, work on aRatio .. Update 9/3; improvements made to sb_reg definition, tested in multiple resolutions, awaiting user feedback
-Add Cast LB when Ready option
-Add Dualcast support
-Add targeted cast support
-Add smartbattle functionality to Explorations (probably a "mob battle" and Boss Battle" type of option.
-Add default team support; will use the 5-dot team indicator to switch to the appropriate team. Add user-entered nickname
-Make Depart count persistent to function/mode?
-Companion/unit stops trying to find skill if failed the first time
-Enchanted Maze INT, whenever it shows up again
-Crash/stuck recovery option using Timer()
-Mid-battle Repeat/Auto pusher?
-Try to take over the world
--]]


ver = "ffbeAuto Z20b"
ALver = "0"															-- AnkuLua version string
ALpro = true														-- is this AnkuLua a Pro and not trial?

Settings:setCompareDimension(true, 600)
Settings:setScriptDimension(true, 600)
setImmersiveMode(true)
Settings:set("MinSimilarity", 0.8)

--WISHLIST ITEM; SKIP VERSION CHECK VARIABLE

--[[
--THIS CODE PROVIDED BY seebadoris, SEE https://github.com/seebadoris/BEFF
commonLib = loadstring(httpGet("https://raw.githubusercontent.com/AnkuLua/commonLib/master/commonLib.lua"))()

--- This checks the version number on github to see if an update is needed, then downloads the newest files ---
getNewestVersion = loadstring(httpGet("https://raw.githubusercontent.com/NonceCents/FFBEAutoZContinued/master/version.lua"))
latestVersion = getNewestVersion()
currentVersion = dofile(localPath .."version.lua")
print (currentVersion)
print (latestVersion)
if currentVersion == latestVersion then
	toast ("You are running the most current version!")
else
	httpDownload("https://raw.githubusercontent.com/NonceCents/FFBEAutoZContinued/master/version.lua", localPath .."version.lua")
	httpDownload("https://raw.githubusercontent.com/NonceCents/FFBEAutoZContinued/master/FFBEAutoZ.lua", localPath .."FFBEAutoZ.lua")
	httpDownload("https://raw.githubusercontent.com/seebadoris/BEFF/master/imageupdater.lua", localPath .."imageupdater.lua")
	scriptExit("Updated!")
end
--]]

healthbar = Pattern("healthbar.png")
exploration = Pattern("exploration.png"):similar(0.5)
autobtn = Pattern("auto.png"):similar(0.9)
autoonbtn = Pattern("AutoOn.png"):similar(0.8)
repeatbtn = Pattern("SB_Repeat.png"):similar(0.7)
nextbtn = Pattern("next.png")
nextbtn2 = Pattern("next2.png")
next_mission = Pattern("next_missioncomplete.png")
next_i = Pattern("next_initial.png") --next btn at initial screen
backbtn = Pattern("back.png")
nobtn = Pattern("no_btn.png")
yesbtn = Pattern("yes_btn.png")
departbtn = Pattern("depart.png")
no_request = Pattern("no_request.png"):similar(0.8)
closebtn = Pattern("close.png")
rank_up = Pattern("rank_up.png")
no_nrg = Pattern("out_of_energy.png")
refill_lapis = Pattern("refill_lapis.png")
refill_item = Pattern("refill_item.png")
continue_ask = Pattern("continue_explore.png")
explore_yes = Pattern("explore_yes.png")
explore_continue = Pattern("explore_continue.png")
explore_leave = Pattern("explore_leave.png")
locked_chest = Pattern("locked_chest.png")
results = Pattern("results.png")
results_big = Pattern("results_big.png")
questclear = Pattern("questclear.png")
menu = Pattern("menu.png")
menuinbattle = Pattern("menuinbattle.png")
gold_coin = Pattern("gold_coin.png"):similar(0.8)
menu_back = Pattern("menu_back.png")
sense_hostile = Pattern("sense_hostile.png")
battle_won = Pattern("battle_won.png")
battle_won2 = Pattern("battle_won2.png")
dungeon = Pattern("dungeon.png")
connection_error = Pattern("connection_error.png")
connect_ok = Pattern("connect_ok.png")
no_companion = Pattern("no_companion.png")
companion = Pattern("companion.png")
bonus_unit = Pattern("bonus.png"):similar(0.7)
dungeon_clear = Pattern("dungeon_clear.png"):similar(0.7)
unitdatachanged = Pattern("unitdatachanged.png")
lapis = Pattern("Lapis.png"):similar(0.7)
friend = Pattern("friend.png"):similar(0.7)
insufficient_raid_orbs = Pattern("insufficient_raid_orbs.png"):similar(0.75)
raid_orbs_no = Pattern("raid_orbs_no.png"):similar(0.7)
revive = Pattern("lapis_revive.png"):similar(0.7)
giveup = Pattern("giveupnow.png")
esperfilled = Pattern("SB_EsperFilled.png"):similar(0.7)

--
IsReady = {Pattern("SB_MyTurn.png"):similar(0.73),Pattern("SB_ReadyAbility.png"):similar(0.73),Pattern("SB_ReadyMagic.png"):similar(0.73),
	Pattern("SB_ReadyGuard.png"):similar(0.73),Pattern("SB_ReadyItem.png"):similar(0.73) }

BackButton = Pattern("backbutton.png"):similar(0.8)
boss = Pattern("bossbattle.png"):similar(0.6)
battle_transition = Pattern("battle_transition.png"):similar(0.75)
text_continue = Pattern("text_continue.png")
arena_begin = Pattern("arena_begin.png")
arena_emptyorbs = Pattern("arena_emptyorbs.png")
arena_lost = Pattern("arena_lost.png")
arena_no = Pattern("arena_no.png")
arena_ok = Pattern("arena_ok.png")
arena_opponent = Pattern("arena_opponent.png")
arena_ratio = Pattern("arena_ratio.png")
arena_resultsok1 = Pattern("arena_resultsok1.png")
arena_resultsok2 = Pattern("arena_resultsok2.png")
arena_resultsok3 = Pattern("arena_resultsok3.png")
arena_setup = Pattern("arena_setup.png")
arena_won = Pattern("arena_won.png")
arena_yes = Pattern("arena_yes.png")
arena_youcannotgoback = Pattern("arena_youcannotgoback.png")
arena_entryyes = Pattern("arena_entryyes.png")
arena_enemyfirst = Pattern("arena_enemyfirst.png")
use_arena_enemyfirst_battle = false

aRatio = 1

screen = getAppUsableScreenSize()
--screen = getRealScreenSize()
width = screen:getX(); height = screen:getY()

if (height >= width) then aRatio = (height / width) / 1.6					-- Aspect ratio correction from 960 height 600 width which is 1.6 ratio
else aRatio = (width / height) / 1.6
end


left_reg = Region(0,0,300,960*aRatio)
right_reg = Region(300,0,600,960*aRatio)
top_reg = Region(0,0,600,480*aRatio)
bottom_reg = Region(0,480*aRatio,600,600*aRatio)
control_reg = Region(0,550*aRatio,600,520*aRatio)

debug_reg = Region(40,0,495,35*aRatio)					-- region to which the script writes debug texts.
r_x = width/4; r_y = height/4; r_w = width/2; r_h = height/2
mid_reg = Region(r_x,r_y,r_w,r_h)
center = Location(300,480*aRatio)
diff = width/2.5

step_mode = 1									-- LEGACY options
trace_mode = 1									-- LEGACY options

buttonreg = { }									-- universal table for button regions learning
buttonreg_learned = { }							-- boolean to set if button is learned. Useful if you want to set button regions manually first then let the script refine it
unitreg = {}

--NonceCents: Below are manually-defined button regions, depreciated in favor of defining the sb_reg first and then slicing it up into unit regions with maths

--[[
unitreg[1] = Region(5,555,295,108)
unitreg[2] = Region(5,664,295,108)
unitreg[3] = Region(5,772,295,108)
unitreg[4] = Region(300,555,295,108)
unitreg[5] = Region(300,664,295,108)
unitreg[6] = Region(300,772,295,108)
--]]

-- Manually set regions
-- NonceCents 9/2: Recently added Aspect Ratio correction to all of these; keep an eye on things to ensure proper resolution support
buttonreg[results_big] = Region(120,30*aRatio,360,320*aRatio) -- two locations for results big. Do not learn.
buttonreg[revive] = Region(50,80*aRatio,495,435*aRatio)
buttonreg[giveup] = Region(50,80*aRatio,495,435*aRatio)
buttonreg[closebtn] = Region(10,225*aRatio,580,550*aRatio) -- closebtn multiple locations. Do not learn.
buttonreg[connection_error] = Region(30,340*aRatio,545,320*aRatio)
buttonreg[connect_ok] = Region(30,340*aRatio,545,320*aRatio)
buttonreg[no_request] = Region(5,635*aRatio,290,165*aRatio)
buttonreg[esperfilled] = Region(540,440*aRatio,60,180*aRatio)
buttonreg[yesbtn] = Region(5,80*aRatio,590,760*aRatio)		-- yesbtn is used in multiple locations. Do not learn.
buttonreg[text_continue] = Region(5,80*aRatio,590,760*aRatio)		-- text_continue is used in multiple locations. Do not learn.
buttonreg[boss] = Region(0,40*aRatio,300,440*aRatio)
buttonreg[battle_transition] = Region(350,80*aRatio,250,360*aRatio)
buttonreg[arena_resultsok1] = Region(60,80*aRatio,480,980*aRatio)		-- OK is used in multiple locations. Do not learn.
buttonreg[arena_resultsok2] = Region(60,80*aRatio,480,980*aRatio)
buttonreg[arena_resultsok3] = Region(60,80*aRatio,480,980*aRatio)

-- Set fixed buttons
buttonreg_learned[results_big] = true
buttonreg_learned[yesbtn] = true
buttonreg_learned[closebtn] = true
buttonreg_learned[text_continue] = true
buttonreg_learned[arena_resultsok1] = true
buttonreg_learned[arena_resultsok2] = true
buttonreg_learned[arena_resultsok3] = true
buttonreg_learned[no_request] = false

findMoveReg = nil
findMoveSet = false
findMoveX = 999999
findMoveY = 999999
findMoveX2 = 0
findMoveY2 = 0
friendsreg = nil
friendsBONUSreg = nil

lagx = 1.0										-- Device lag multiplier value. 1.0 for high end devices.
arena_mode = false								-- Is Arena auto-mode selected?
help_screen = false
use_bonus_unit = false
use_highest_atk_companion = false
companion_used = false							-- True if we successfully used a companion.
use_esper_battle = false
use_repeat_battle = false
use_smart_battle = false
use_smart_battle_2nd = true
use_smart_battle_2nd_round = 3
use_smart_battle_boss = true
use_smart_battle_boss_2nd = true
use_smart_battle_companion = true
use_smart_battle_companion_damage = "Area"
use_smart_battle_companion_mp = 10
use_smart_battle_companion_2nd = true
use_smart_battle_companion_2nd_damage = "Area"
use_smart_battle_companion_2nd_mp = 15
use_smart_battle_boss_companion = true
use_smart_battle_boss_companion_damage = "Single Target"
use_smart_battle_boss_companion_mp = 30
use_smart_battle_boss_companion_2nd = true
use_smart_battle_boss_companion_2nd_damage = "Single Target"
use_smart_battle_boss_companion_2nd_mp = 30
use_smart_battle_custom_cast_times = false
damage_methods = {"Any Attack", "Any AoE Attack", "Any Single-Target Attack"}
halt_on_gameover = false
goldcheck_success = false						-- Has gold check ever successful?
leave_after_boss = false						-- Exploration value - leave after boss instead of continuing.
finished_explore = false						-- Used in conjunction of leave after boss to break all exploration functions.
depart_count = 0								-- Count for departing.
max_depart_count = 99999
gameover_count = 0
lapis_refill_count = 0
alt_step=true									-- Deprecated. Always true now. If false will replace single steps with 100ms swipes.
gold_reg = nil									-- Region for gold check in exploration farming
tempbtn = nil									-- Temporary button storage
battle_counter = 0								-- Battle counter in explorations including farming.
move_counter = 0								-- Total move counter in explorations not including farming.
enable_bosscheck_counter = 16					-- When to enable bosscheck on explorations, will be adjusted automatically after a successful run
bosses_encountered = 0							-- When, if, there are explorations with multiple bosses.


up = {center:offset(0,-(height/3))}
down = {center:offset(0,height/3)}
left = {center:offset(-diff,0)}
right = {center:offset(diff,0)}
ul = {center:offset(-diff,-diff)}
ur = {center:offset(diff,-diff)}
dl = {center:offset(-diff,diff)}
dr = {center:offset(diff,diff)}

top = Location(300,150*aRatio)
bottom = Location(300,750*aRatio)
rain = {Pattern("rain_up.png"):similar(0.9),Pattern("rain_down.png"):similar(0.9),Pattern("rain_left.png"):similar(0.9),Pattern("rain_right.png"):similar(0.9),
		Pattern("rain_ul.png"):similar(0.9),Pattern("rain_ur.png"):similar(0.9),Pattern("rain_dl.png"):similar(0.9),Pattern("rain_dr.png"):similar(0.9)}

sb_autoskills = {"None","Any Attack","Any AoE Attack","Any Single-Target Attack"}
--sb_autoskills ["None"] = false
--sb_autoskills ["Any Attack"] = Pattern("SB_Sword.png")
--sb_autoskills ["Any AoE Attack"] = Pattern("SB_Sword.png")
--sb_autoskills ["Any Single-Target Attack"] = Pattern("SB_Sword.png")

sb_skills = {}
sb_skills["Katana"] = Pattern("SB_Sword.png")
sb_skills["Sword"] = Pattern("SB_Break.png")
sb_skills["Blast"] = Pattern("SB_Blast.png"):similar(0.7)
sb_skills["Aero"] = Pattern("SB_Aero.png")
sb_skills["Shot"] = Pattern("SB_Shot.png")
sb_skills["Cure"] = Pattern("SB_Curaja.png")
sb_skills["Fire"] = Pattern("SB_Fire.png")
sb_skills["Blizzard"] = Pattern("SB_Blizzard.png")
sb_skills["Thunder"] = Pattern("SB_Thunder.png")
sb_skills["Holy"] = Pattern("SB_Holy.png")
sb_skills["Dark"] = Pattern("SB_Dark.png")
sb_skills["Drain"] = Pattern("SB_Drain.png")
sb_skills["Stone"] = Pattern("SB_Stone.png")
sb_skills["Water"] = Pattern("SB_Water.png")
sb_skills["Poison"] = Pattern("SB_Poison.png")
sb_skills["Buff"] = Pattern("SB_Buff.png")
sb_skills["Cheer"] = Pattern("SB_Cheer.png")
sb_skills["Steal"] = Pattern("SB_Steal.png")
sb_skills["Kick"] = Pattern("SB_Kick.png")
sb_skills["Ultima"] = Pattern("SB_Ultima.png")
sb_skills["Provoke"] = Pattern("SB_Provoke.png")
sb_skills["Dance"] = Pattern("SB_Dance.png")
sb_skills["Sing"] = Pattern("SB_Sing.png")
sb_skills["Elements"] = Pattern("SB_Elements.png")
sb_skills["Status"] = Pattern("SB_Status.png"):similar(0.7)
sb_skills["Meteor"] = Pattern("SB_Meteor.png")
sb_skills["Alterna"] = Pattern("SB_Alterna.png")
sb_skills["Cover (Noctis)"] = Pattern("SB_Cover.png")
sb_skills["Critical"] = Pattern("SB_Critical.png")
sb_skills["Rapid Fire"] = Pattern("SB_RapidFire.png")
sb_skills["Imperil"] = Pattern("SB_Imperil.png")
sb_skills["Sentinel"] = Pattern("SB_Sentinel.png")
sb_skills["Resist"] = Pattern("SB_Resist.png")
sb_skills["Block"] = Pattern("SB_Block.png")
sb_skills["Gamble"] = Pattern("SB_Gamble.png")


-- Not in table
SB_MP = Pattern("SB_MP.png"):similar(0.7)
SB_AbilitiesUnavailable = Pattern("SB_AbilitiesUnavailable.png"):similar(0.7)
SB_Raise = Pattern("SB_Raise.png"):similar(0.7)
SB_Enemies = {Pattern("SB_Enemies1.png"):similar(0.8),Pattern("SB_Enemies2.png"):similar(0.8),Pattern("SB_Enemies3.png"):similar(0.8)}
SB_Damage = {Pattern("SB_Damage1.png"):similar(0.75),Pattern("SB_Damage2.png"):similar(0.75),Pattern("SB_Damage3.png"):similar(0.75),Pattern("SB_Damage4.png"):similar(0.75),Pattern("SB_Damage5.png"):similar(0.75)}
SB_AttackIcons = {Pattern("SB_Sword.png"):similar(0.65),Pattern("SB_Break.png"):similar(0.65),Pattern("SB_Blast.png"):similar(0.65),Pattern("SB_Aero.png"):similar(0.65),
			   Pattern("SB_Shot.png"):similar(0.65),Pattern("SB_Fire.png"):similar(0.65),Pattern("SB_Blizzard.png"):similar(0.65),Pattern("SB_Thunder.png"):similar(0.65),
			   Pattern("SB_Holy.png"):similar(0.65),Pattern("SB_Dark.png"):similar(0.65),Pattern("SB_Drain.png"):similar(0.65),Pattern("SB_Stone.png"):similar(0.65),
			   Pattern("SB_Water.png"):similar(0.65),Pattern("SB_Poison.png"):similar(0.65),Pattern("SB_Kick.png"):similar(0.65),Pattern("SB_Ultima.png"):similar(0.65),
			   Pattern("SB_Dance.png"):similar(0.65),Pattern("SB_Meteor.png"):similar(0.65),Pattern("SB_Alterna.png"):similar(0.65),Pattern("SB_RapidFire.png"):similar(0.65),
			   Pattern("SB_Critical.png"):similar(0.65)
			   }			  
SB_NonAttackIcons = {Pattern("SB_Raise.png"):similar(0.7), Pattern("SB_Cover.png"):similar(0.7),Pattern("SB_Curaja.png"):similar(0.7),Pattern("SB_Sing.png"):similar(0.7),
					Pattern("SB_Elements.png"):similar(0.7), Pattern("SB_Buff.png"):similar(0.7),Pattern("SB_Cheer.png"):similar(0.7),Pattern("SB_Provoke.png"):similar(0.7),
					Pattern("SB_Block.png"):similar(0.7), Pattern("SB_Steal.png"):similar(0.7), Pattern("SB_Imperil.png"):similar(0.7), Pattern("SB_Sentinel.png"):similar(0.7),
					Pattern("SB_Resist.png"):similar(0.7)
					}						   
arena_skilluse = {}										-- Skill to use in arena
arena_skillmp = {}											-- MP match
arena_skillcast = {}
arena_skilluse_enemy = {}
arena_skillmp_enemy = {}
arena_skillcast_enemy = {}
arena_autoskilluse = "Any AoE Attack"
--arena_autoskillmp = 28  --This is now an option defined by a text box

sb_skilluse = {}										-- Skills to use in first stage of battle
sb_skillmp = {}											-- MP match
sb_skillcast = {}										-- Skill cast times
sb_skilluse2 = {}										-- Skills to use in second stage of battle
sb_skillmp2 = {}										-- MP match
sb_skillcast2 = {}										-- Skill cast times
sb_skilluse_boss = {}									-- Skill to use on boss battle
sb_skillmp_boss = {}									-- MP match on boss
sb_skillcast_boss = {}									-- Skill cast times
sb_skilluse_boss2 = {}									-- Skill to use on second turn of boss battle
sb_skillmp_boss2 = {}									-- MP match on boss
sb_skillcast_boss2 = {} 								-- Skill cast times

sb_regunit = {}											-- unit 1 to 6 specific regions
sb_regunit_num = 0										-- If the party isn't full
sb_reg = nil											-- Region for the entire controls

chain_skillcast = {}											-- Skill cast times for chain helper

special_farm = {}
special_farm["dungeon_finder"] = Location(0,0)
special_farm["free_farm"] = exploration
special_farm["arena"] = 0
special_farm["earth_shrine_entrance_speedmode"] = Pattern("earth_shrine_entrance.png")
		
-- List of dungeons other than special functions

dungeonfarm = {}
dungeonfarm["dungeon_finder"] = Location(0,0)
dungeonfarm["earth_shrine_entrance"] = Pattern("earth_shrine_entrance.png")
dungeonfarm["earth_shrine_exit"] = Pattern("earth_shrine_exit.png")
dungeonfarm["enchanted_maze_BGN"] = Pattern("enchanted_maze_BGN.png")

explorefarm = {}
explorefarm["free_farm"] = exploration
explorefarm["earth_shrine_exploration"] = Pattern("earth_shrine_exploration.png")
explorefarm["phantom_forest_exploration"] = Pattern("phantom_forest_exploration.png")
explorefarm["fulan_pass_exploration"] = Pattern("fulan_pass_exploration.png")
explorefarm["maranda_coast_exploration"] = Pattern("maranda_coast_exploration.png")
explorefarm["wolfsfang_peak_exploration"] = Pattern("wolfsfang_peak_exploration.png")
explorefarm["dwarves_forge_exploration"] = Pattern("dwarves_forge_exploration.png")
--explorefarm["dalnakya_cavern_harvest_exploration"] = Pattern("dalnakya_cavern_harvest.png")
explorefarm["water_shrine_exploration"] = Pattern("water_shrine_exploration.png")
explorefarm["wind_shrine_exploration"] = Pattern("wind_shrine_exploration.png")
explorefarm["fire_shrine_exploration"] = Pattern("fire_shrine_exploration.png")
explorefarm["ruggles_underground_pass_exploration"] = Pattern("ruggles_underground_pass_exploration.png")
explorefarm["invincible_interior_exploration"] = Pattern("invincible_interior_exploration.png")
--explorefarm["orbonne_monastery_vault_exploration"] = Pattern("vault_explore.png")

-- Exploration paths.

custom = {} -- for custom path name
explorePath = {}
explorePath["earth_shrine_exploration"] = "bosscheck,30|up,2500|findmove|down,1|left,4000|right,3|up,5000|right,6000|down,1|right,4000|left,3|down,3750|right,1000|down,500|left,500|up,500|left,1000|up,9000|down,1|right,1000|up,1000|left,500|up,1|left,500|up,1|left,1|up,3750|down,3750|right,1000|down,2000|up,1|left,5750|right,6|up,4000|left,800|down,600,collect3|up,600|right,3|up,2500"
explorePath["phantom_forest_exploration"] = "left,1|findmove|left,3000|down,1000|left,3000|right,2|up,2000|left,1000|up,2000|right,2500|up,1500|down,1500|left,2500|right,1|battle,ud,700,up|up,3000|right,3000|up,2000|right,3000|up,2000|left,2500|up,500|right,2000|down,500|right,500|down,2000|left,3000|down,2500|left,3000|down,1000|left,2000|up,2000|left,3000|down,4000|left,500|down,2500|left,1500|right,1|up,2000|right,2000|up,5000|right,500|up,4000|right,2000|up,500|left,4000|down,500|left,8000"
explorePath["fulan_pass_exploration"] = "up,2000|left,2500|up,1000|left,5|up,3000|right,1|left,1|down,3000|left,1500|up,1500|left,1500|up,3000|right,3000|up,2500|left,1000|up,500|left,2500|up,3000|left,1500|right,1500|down,3000|right,3000|down,2|right,3000|up,2000|right,3500|up,2000|left,3000|up,2000|left,1|up,3000|right,3500|up,5000|down,2|right,2000|up,3000|left,4000|right,4000|down,3000|left,5000|up,500|left,1000|down,500|left,1000|down,2000|left,3500|up,1500|left,1500|up,6000"
explorePath["maranda_coast_exploration"] = "bosscheck,35|down,500|findmove|down,8000|up,13|left,5000|down,1000|right,10|up,3500,collect1|left,500|down,5000|up,7|battle,lr,2900,left|left,10000|up,4000|left,4000|up,2000,collect2|down,2000|up,2|left,3000|left,4000,zone2|findmove|down,500,collect3|right,4000|left,2|down,3000|left,500|down,3000|left,1000|up,1000|left,4000|right,2|up,2000|left,15|down,3000|left,1500|up,2000|left,1000,collect4|right,2000|up,3000|battle,lr,7300,left|left,8000|up,3000|right,1500|up,2000|right,1500|up,1000|right,2000|down,500,collect5|left,2000|down,1500|left,3000|right,3|up,6000"
explorePath["dalnakya_cavern_harvest_exploration"] = "down,1000|right,1500|up,1000|right,4500|down,1000|right,3500|up,2|left,2000,collect1|down,2|left,3000|up,1000|left,9|down,4000|left,1000|down,2|left,1|down,6,collect2|right,1500|down,2000|left,1000|down,1000|left,1000|down,6|right,2000|up,2|right,3000|up,1000|right,1500,collect3|left,1500|down,2000|left,3000|down,1000|left,2000|down,1500|left,1500|down,2000|left,1500|down,1500|left,1500|down,3000|down,1500,zone2|left,1500|down,1|left,1000,collect4|right,2000|up,3|right,1500|down,1500|right,2000|up,1000|right,1000|up,1500|right,3000,collect5|left,3000|down,1500|left,1000|down,1000|left,2000|down,3000|down,3000,bosszone|down,3000|down,1500|down,1500,extraforboss|right,1500|down,3000|down,2000,3collectzone|up,2|right,1500,collect|left,1|up,2|left,1500|right,1500|down,6000"
explorePath["orbonne_monastery_vault_exploration"] = "up,1000|findmove|down,1|left,1000,collect1|up,2500|right,1000|up,1000|left,1500|up,2000|up,2000,collect2|down,2000|right,1000|down,500|right,1000|down,500,collect3|up,500|left,5|down,2000|right,2000|down,2000|left,2000|up,1000|left,2000|down,9|left,4|up,2000|left,3000|right,2|up,1500|left,2000|left,2|down,1500|right,1500|up,1500|right,2000|down,1500|right,2000|down,2000|up,1|left,500|down,500|left,500|up,500|left,500|up,500|left,16|down,5000|right,3500|up,2000|down,1|right,3000|down,2000|left,5000,collect5|down,4000|right,6000|right,6000"
explorePath["wolfsfang_peak_exploration"] = "right,1500|findmove|left,1|findmove|up,1|findmove|up,1|findmove|up,1|findmove|up,1|findmove|up,1|right,6000|up,1000|right,500|up,1500|right,2500|up,1500|left,3000|findmove|right,1|findmove|right,1|findmove|right,1|up,1500|up,500|right,2000|up,5500|left,1500|up,2|left,1500|right,2|up,3000|left,1500|down,1|right,2|up,1000|right,500|down,1|right,2500|down,3500|up,4|battle,lr,1977,right|right,3000|left,2|up,1500|left,5|up,1500|left,2|up,1000|left,1500|up,1|right,1000|up,1|right,1|right,500|up,500|right,2|up,500|left,1|up,1|left,6000|up,1500|right,2000|left,1|up,500|right,1|up,1500|right,1|up,1|right,1|up,1000|left,2|up,1|left,1|up,2000|right,1|up,500|left,1|up,1000|left,3|up,500|right,1000|up,1000|battle,lr,3500,right|right,3000|up,6500"
explorePath["dwarves_forge_exploration"] = "right,1000|ur,4000|down,3000|up,3000|dl,1000|dl,5000|up,6000|ur,3000|up,4000|left,1000|up,5000|battle,ud,3204,up|right,1000|down,4000|left,1|down,1000|left,6000|left,4000|ul,4000|down,5000|dr,2000|dr,2000|right,5000|down,1|down,3000|left,3000|down,1000|left,1000|up,1000|left,3000|ur,2000|left,4000|up,1000|right,5000|ur,1000|right,4000|right,8000|right,4000|right,4000|dl,3000|left,5000|up,1|up,3000|right,4000|ul,2000|up,6000|right,1000|up,2000|ul,2000|up,3000|ur,2000|battle,ud,7888,up|ul,2000|up,2000|ur,2000|up,2000|up,4000|right,3000|down,2000|left,3000|down,1000|right,3000|down,3000|left,1000|dl,2000|left,5000|up,1000|ur,3000|ul,2000|up,4000|left,4000|up,1000|left,3000|ur,4000|down,1000|dl,5000|right,4000|up,1000|ur,9000"
explorePath["water_shrine_exploration"] = "leaveafterboss|bosscheck,40|right,700|up,2000|right,2500|up,1800|down,1800|left,1|down,1200|left,1950|up,700|left,5|up,3000|up,2100|right,1500|down,3|right,1500|battleex,lr,4820,14,4500,right|right,4000|left,1|up,2700|down,4|right,1200|right,8500|down,1|left,9000|down,3000|left,3000|up,1200|left,4|up,2500|left,2000|right,1|up,2000|down,4|left,4500|right,3|up,2000|up,2300|right,4000|battleex,lr,11188,29,8000,right|right,8000|left,17|up,3000|up,3000"
explorePath["invincible_interior_exploration"] = "leaveafterboss|bosscheck,74|up,6500|down,9|right,5000|left,1|down,700|left,700|down,2|left,1|down,700|right,700|down,2|right,600|down,600|left,700|down,3000|down,3800|battleex,lr,6631,14,3500,left|left,4500|up,1|right,4500|up,3000|up,8000|up,5000|right,1|up,500|wait,8500|up,1|right,2500|battleex,ud,15300,29,3250,down|down,4000|up,3|left,3500|down,1250|down,1800|right,5000|left,2|down,4500|up,5|left,700|up,3000|down,2|left,3100|right,3|down,14|left,1250|left,2000|down,3500|left,2500|down,11|left,3000|up,4750|right,3500|left,11|down,10|down,12|right,2500|up,3250|right,5|up,3000|right,3000|right,1000|left,1|down,5000|down,2800|right,800|up,2300|right,1250|up,2|left,3200|up,1000|right,1250|up,2|left,3000|up,1|right,7|up,700|right,1250|up,3200|up,10000|up,2000|right,1|up,500"
explorePath["wind_shrine_exploration"] = "leaveafterboss|bosscheck,42|right,3800|left,12|up,3000|right,400|up,700|left,2|up,1500|left,700|up,700|left,1500|right,1|up,2000|left,3|down,3500|right,3000|up,800|left,3000|up,3500|left,2000|up,3000|right,2800|down,2500|right,3000|battleex,ud,3870,14,2800,up|up,3700|left,1|up,3000|right,3000|up,700|down,1|right,2500|left,3000|down,1000|left,2500|up,3000|right,700|battleex,ud,10500,29,2600,up|up,3000|left,2|up,7|left,3700|up,1|right,2800|up,1|right,6|up,1500|up,8000|up,1000"
explorePath["fire_shrine_exploration"] = "leaveafterboss|bosscheck,90|left,500|up,2750|right,1|up,2|left,4|down,1|up,1|right,4500|up,500|right,5|up,1000|right,2500|down,2250|left,1500|down,2250|left,1|down,2000|right,2250|down,2000|right,500|left,500|up,2000|left,3500|up,1|right,1500|up,2000|right,1750|left,1|battleex,ud,4350,14,2000,up|up,2500|right,1|up,1500|left,3000|down,3000|left,3000|left,15|up,2350|up,9|right,2500|down,2500|right,2250|right,2500|up,1|right,2750|up,2500|left,2500|up,500|left,1500|down,800|up,800|right,1500|down,1|right,2000|down,2500|left,3500|down,1|left,3100|left,2000|up,800|right,1|up,2500|left,1000|battleex,lr,11040,29,3200,left|left,4500|down,2750|left,2250|left,4500|up,300|right,1|down,3750|down,4350|right,1|up,2750|right,2750|left,1|up,3500|up,1750|down,2500|down,3500|left,3500|right,2|up,3750|up,3500|right,500|down,1500|right,4500|right,2000|left,1|up,3100|ur,5000|ur,5000|left,1|up,2500|up,3000|up,3000"
explorePath["ruggles_underground_pass_exploration"] = "bosscheck,18|down,2500|left,750|down,1750|left,3000|left,5000|right,2|down,3000|up,4000|right,5000|right,1500|up,2500|right,2000|up,3000|down,3|right,3000|down,2500|right,3000|right,5000|right,2500|right,2500|up,3000|up,1750|down,1|left,1250|right,2000|down,3500|down,2500|right,2500|down,2250|right,3500"
explorePath["timber_tracks_exploration"] = "leaveafterboss|bosscheck,38|right,1000|right,1|down,1000|battleex,lr,4812,14,2000,left|up,1500|right,2000|left,1|up,1|up,1|battleex,lr,9620,29,3000,right|left,10|up,1000|left,1000|down,1000|left,2500|right,4|down,1|left,2000|left,7000|down,1|left,7000|left,7|up,1000|left,1000|up,1000|left,2|up,1000|down,1000|right,3|down,1500|left,6000|left,7000|left,7000|left,7000|right,1000|right,13|up,1000|down,2|left,5000|left,7000|left,7000"
--allow 2 or more steps of bosscheck before the boss for safety reasons

waitmsg = {"Changing diaper", "Feeding baby", "Warming bottle", "Bathing baby", "Making coffee", "Burping baby"}

function score(target)
	if(exists(target)) then
		toast(target..getLastMatch():getScore())
	else
		toast("  not found")
	end
end

function string:save(filename)
	local f = io.open(scriptPath()..filename, "a+")
	f:write(self.."\t"..os.date().."\n")
	f:close()
end

function string:split(delimiter)
  local result = { }
  local from  = 1
  local delim_from, delim_to = string.find( self, delimiter, from  )
  while delim_from do
    table.insert( result, string.sub( self, from , delim_from-1 ) )
    from  = delim_to + 1
    delim_from, delim_to = string.find( self, delimiter, from  )
  end
  table.insert( result, string.sub( self, from  ) )
  return result
end

function runlog(str,istxt,linenumber)
	local mult = 10^(4)

	if(not istxt) then
		score = getLastMatch():getScore()
		if(score ~= nil) then
			if score >= 0 then score=math.floor(score * mult + 0.5) / mult	else score=math.ceil(num * mult - 0.5) / mult end
			str = str.."  "..score
		else
			str = str.."  nil"
		end
	end
	-- Pass "debug.getinfo(1).currentline" to linenumber in this function and the script line # that the log message was on will be prepended to the string
	if (linenumber ~= nil) then
		str = "Script Line #"..linenumber..": "..str
	end

	if (ALver >= "6.0.0") then
		setHighlightTextStyle (0xffffffff, 0xff000000, 22)
		debug_reg:highlight(str,1)
	else
--		toast(str)
	end
	str:save("run.log")
end

function getPath(str,pathIndex)
	str:save("run.log")
	if not pathIndex then pathIndex = 1 end
	local output = {}
	local temp = str:split("|")
	for i=pathIndex,#temp do output[#output+1] = temp[i] end
	return output
end

function pairsByKeys (t, f)
	local a = {}
    for n in pairs(t) do table.insert(a, n) end
    table.sort(a, f)
    local i = 0      -- iterator variable

    local iter = function ()   -- iterator function
      i = i + 1
      if a[i] == nil then return nil
      else return a[i], t[a[i]]
      end
    end

    return iter
    end

function pairsByValues(tbl, sortFunction)
  local keys = {}
  for key in pairs(tbl) do
    table.insert(keys, key)
  end

  table.sort(keys, function(a, b)
    return sortFunction(tbl[a], tbl[b])
  end)

  return keys
end

function getALVer()
	local ALstring = getVersion()
	local pro = false

	if string.match(ALstring, "pro") then pro = true end

	local temp = ALstring:split("-")
	return temp[1],pro
end

--Following two functions by NonceCents to match multiple IsReady icons
function existsIsReady(checkregion,howLong)

	if (checkregion == nil) then
		while(sb_reg == nil) do defineSBreg() end
		checkregion = sb_reg
	end
	if (howLong == nil) then
		howLong = 0
	--else
	--	howLong = howLong / #IsReady
	end

	for i=1, #IsReady do
		if (checkregion:exists(IsReady[i],howLong)) then
			return true
		end
	end
	return false
end

function existsClickIsReady(checkregion,howLong)

	if (checkregion == nil) then
		while(sb_reg == nil) do defineSBreg() end
		checkregion = sb_reg
	end
	if (howLong == nil) then
		howLong = 0
	--else
	--	howLong = howLong / #IsReady
	end

	for i=1, #IsReady do
		if (checkregion:existsClick(IsReady[i],howLong)) then
			return true
		end
	end
	return false
end

-- existsClick function with self-learning capabilities. Will store button regions for faster searching next time.
-- Warning : USE ONLY with buttons that are always located in one location. Otherwise use the standard function or define region manually first, then set buttonreg_learned[obj] to true.

function existsClickL(obj, howLong)
	
	local returnval = false
	local safetyMargin = 15
	local tX = 0
	local tY = 0
	local tW = 0
	local tH = 0

	if not howLong then howLong = 0 end
	
	if (not buttonreg_learned[obj]) then
		if (existsClick(obj, howLong)) then
			returnval = true
			tX = getLastMatch():getX()
			tY = getLastMatch():getY()
			tW = getLastMatch():getW()
			tH = getLastMatch():getH()
			buttonreg[obj] = Region(tX-safetyMargin,tY-safetyMargin,tW+safetyMargin*2,tH+safetyMargin*2)
			buttonreg_learned[obj] = true
		else
			returnval = false
		end
	else
		if (buttonreg[obj]:existsClick(obj, howLong)) then
			returnval = true
		else
			returnval = false
		end
	end
	
	return returnval
end

-- exists function with self-learning capabilities. Will store button regions for faster searching next time.
-- Warning : USE ONLY with buttons that are always located in one location. Otherwise use the standard function or define region manually first, then set buttonreg_learned[obj] to true.

function existsL(obj, howLong)
	
	local returnval = false
	local safetyMargin = 15
	local tX = 0
	local tY = 0
	local tW = 0
	local tH = 0

	if not howLong then howLong = 0 end
	
	if (not buttonreg_learned[obj]) then

		if (exists(obj, howLong)) then
			returnval = true
			tX = getLastMatch():getX()
			tY = getLastMatch():getY()
			tW = getLastMatch():getW()
			tH = getLastMatch():getH()
			buttonreg[obj] = Region(tX-safetyMargin,tY-safetyMargin,tW+safetyMargin*2,tH+safetyMargin*2)
			buttonreg_learned[obj] = true
		else
			returnval = false
		end
	else
		if (buttonreg[obj]:exists(obj, howLong)) then
			returnval = true
		else
			returnval = false
		end
	end
	
	return returnval
end

--Custom path
local f = io.open(scriptPath().."custom.txt", "r")
if( f ~= nil) then 
	custom_tbl = f:read("*all"):split("\n"); f:close()
	for i,v in pairs(custom_tbl) do 
		temp = custom_tbl[i]:split(":")
		table.insert(custom,"custom_"..temp[1])
		explorePath["custom_"..temp[1]] = temp[2]
	end
end

--Find Rain's position on explorations. Returns false if fails to find any.

function findMove()
	local center = nil
	usePreviousSnap(false)

	for i=1,#rain do 
		if(findMoveSet == false and exists(rain[i],0)) then 

			if (getLastMatch():getX() < findMoveX) then
				findMoveX = getLastMatch():getX()
--				if (debug_mode) then runlog("Rain X :"..findMoveX, true) end
			end
			if (getLastMatch():getY() < findMoveY) then
				findMoveY = getLastMatch():getY()
--				if (debug_mode) then runlog("Rain Y :"..findMoveY, true) end
			end
			if (getLastMatch():getX()+getLastMatch():getW() > findMoveX2) then
				findMoveX2 = getLastMatch():getX()+getLastMatch():getW()
--				if (debug_mode) then runlog("Rain X2 :"..findMoveX2, true) end
			end
			if (getLastMatch():getY()+getLastMatch():getH() > findMoveY2) then
				findMoveY2 = getLastMatch():getY()+getLastMatch():getH()
--				if (debug_mode) then runlog("Rain Y2 :"..findMoveY2, true) end
			end

			
			center = getLastMatch()
--			if(debug_mode) then runlog("Found Rain#"..i) end
--			center:highlight(.1)
			up[2] = center:getCenter()
--			center:offset(0,70):highlight(.1)
			down[2] = up[2]:offset(0,115)
--			center:offset(-35,50):highlight(.1)
			left[2] = up[2]:offset(-30,75)
--			center:offset(35,50):highlight(.1)
			right[2] = up[2]:offset(30,75)
			ul[2] = up[2]:offset(-30,0)
			ur[2] = up[2]:offset(30,0)
			dl[2] = down[2]:offset(-30,0)
			dr[2] = down[2]:offset(30,0)
			break
		elseif(findMoveSet == true and findMoveReg:exists(rain[i],0)) then 
			center = findMoveReg:getLastMatch()
--			center:highlight(.1)
			up[2] = center:getCenter()
--			center:offset(0,70):highlight(.1)
--			center:offset(-35,50):highlight(.1)
--			center:offset(35,50):highlight(.1)
			down[2] = up[2]:offset(0,115)
			left[2] = up[2]:offset(-30,75)
			right[2] = up[2]:offset(30,75)
			ul[2] = up[2]:offset(-30,0)
			ur[2] = up[2]:offset(30,0)
			dl[2] = down[2]:offset(-30,0)
			dr[2] = down[2]:offset(30,0)
			break
		end
		usePreviousSnap(true)
	end

	usePreviousSnap(false)

	if(center == nil) then 
		if(debug_mode) then runlog("Rain not found",true) end
		return false
	end
	return true
end

function selectDungeon()
	toast("Finding available dungeon...")
	--noinspection GlobalCreationOutsideO
	dungeonList = regionFindAllNoFindException(left_reg,dungeon)
--	dungeonList = findAllNoFindException(dungeon)
	if(debug_mode) then runlog("Custom dungeon found: "..#dungeonList,true) end
	dialogInit()
	addRadioGroup("custom_dungeon",1)
	for i=1,#dungeonList do
		addRadioButton("Dungeon #"..i,i)
	end
	dialogShow("Select Dungeon")
	dungeonfarm["dungeon_finder"] = dungeonList[custom_dungeon]
	if(debug_mode) then runlog("Custom dungeon select: "..custom_dungeon,true) end
end

-- Random exploration mode only executed when pathing fails. Better than just staying there doing nothing.

function chaosExploraton()
	local count = 0
	local random_1 = math.random(8)
	local random_2 = math.random(450+(lagx*100),7250+(lagx*250))
	
	if(debug_mode) then runlog("Random Exploration Start!",true)
	else
		toast("Random exploration, please stop and manually finish.")
	end	

	leave_after_boss = true
	
	while(true) do
		if (finished_explore == true) then break end
		if (existsL(revive,0)) then break end
		count = count + 1
		random_1 = math.random(12)
		random_2 = math.random(450+(lagx*100),7250+(lagx*250))
		if (random_1 == 1) then go("left",random_2)
		elseif (random_1 == 2) then go("right",random_2)
		elseif (random_1 == 3) then go("up",random_2)
		elseif (random_1 == 4) then go("down",random_2)
		elseif (random_1 == 5 or random_1 == 9) then go("ul",random_2*1.5)
		elseif (random_1 == 6 or random_1 == 10) then go("ur",random_2*1.5)
		elseif (random_1 == 7 or random_1 == 11) then go("dl",random_2*1.5)
		elseif (random_1 == 8 or random_1 == 12) then go("dr",random_2*1.5)
		end
		if (count%13 == 0) then
			if(debug_mode) then runlog("Exploration failure.",true)
			else
				toast("Exploration failure.")
			end	
		elseif (count%17 == 0) then
			if(debug_mode) then runlog("Please finish manually.",true)
			else
				toast("Please finish manually.")
			end	
		end
	end
end

-- Old findBattle function, preserved for compatibility.

function findBattle(loot_direction,limit,exit_direction)

	-- store optimization variables
	local lastEnableBossCheck = enable_bosscheck_counter
	local lastMoveCounter = move_counter
	local locBattleCount = 0
	local lapsWithoutBattle = 0

	-- no bosscheck
	enable_bosscheck_counter = 100000
		
	for i=0, 100 do 
		if(existsL(revive,0)) then return end
		toast("Lap "..i)
		local count = battle_counter
		if(loot_direction == "lr") then
			go("left",2500+1750*lagx)
			go("right",2500+1750*lagx)
		elseif(loot_direction == "ud") then
			go("up",2500+1750*lagx)
			go("down",2500+1750*lagx)
		end
		locBattleCount = locBattleCount + battle_counter - count
		if (battle_counter > count) then
			lapsWithoutBattle = 0
		else
			lapsWithoutBattle = lapsWithoutBattle + 1
		end
		if(((i>=30 and i%5==0) or (locBattleCount>=10 and count<battle_counter) or (lapsWithoutBattle > 2)) and checkGold(limit)) then break end
		if (lapsWithoutBattle > 7) then break end
		--if(battle_counter >= limit) then go(exit_direction,4000); break end
	end

	toast("Exiting farming...")
	go(exit_direction,1234);go(exit_direction,2345)
		
	-- restore optimization variables
	enable_bosscheck_counter = lastEnableBossCheck
	move_counter = lastMoveCounter
	
end

-- New findbattle function.

function findBattleEx(loot_direction,limit,battle_limit,run_length,exit_direction)

	-- store optimization variables
	local lastEnableBossCheck = enable_bosscheck_counter
	local lastMoveCounter = move_counter
	local locBattleCount = 0
	local lapsWithoutBattle = 0

	-- no bosscheck
	enable_bosscheck_counter = 100000
		
	for i=0, 100 do 
		if(existsL(revive,0)) then return end
		toast("Lap "..i)
		local count = battle_counter
		if(loot_direction == "lr") then
			go("left",run_length*0.8+run_length*lagx*0.2)
			go("right",run_length*0.8+run_length*lagx*0.2)
		elseif(loot_direction == "ud") then
			go("up",run_length*0.8+run_length*lagx*0.2)
			go("down",run_length*0.8+run_length*lagx*0.2)
		end
		locBattleCount = locBattleCount + battle_counter - count
		if (battle_counter > count) then
			lapsWithoutBattle = 0
		else
			lapsWithoutBattle = lapsWithoutBattle + 1
		end
		if (battle_limit > 0 and battle_counter >= battle_limit) then break end
		if(((i>=30 and i%5==0) or (locBattleCount>=10 and count<battle_counter) or (lapsWithoutBattle > 2 and i%3 == 0)) and checkGold(limit)) then break end
		if (lapsWithoutBattle > 9) then break end
		--if(battle_counter >= limit) then go(exit_direction,4000); break end
	end

	toast("Exiting farming...")
	go(exit_direction,run_length)
		
	-- restore optimization variables
	enable_bosscheck_counter = lastEnableBossCheck
	move_counter = lastMoveCounter
	
end

-- Gold check function for exploration farming.

function checkGold(limit)
	local gold
	local returnval = false
	
	usePreviousSnap(false)

	for i=1,20 do
		existsClickL(menu,lagx/4)
		wait(lagx/8+0.1)
		if(existsL(gold_coin,lagx/4)) then

--			if(debug_mode) then runlog("Gold coin exists",true) end

			if(gold_reg == nil) then 
				gold_reg = Region(getLastMatch():getX()+40,getLastMatch():getY()+1,135,41*aRatio)
				if(debug_mode) then gold_reg:save("gold_reg.png") end
			else
				if(debug_mode) then gold_reg:highlight(0.25) end
				gold, returnval = numberOCRNoFindException(gold_reg,"gil")
				if (returnval) then
					existsClickL(menu_back,2)
					toast(gold.." gold")
					if(debug_mode) then runlog("Gold check: "..gold,true) end
					if(gold >= limit) then
						goldcheck_success = true
						return true
					else
						if (goldcheck_success == false and (gold < limit/5)) then
							gold_reg = Region(gold_reg:getX()-1,gold_reg:getY()-2,gold_reg:getW()+2,gold_reg:getH()+4)
							if(debug_mode) then runlog("Enlarging check region",true) end					
						end
						return false
					end
				else
					if(debug_mode) then runlog("Enlarging check region",true) end					
					gold_reg = Region(gold_reg:getX()-1,gold_reg:getY()-2,gold_reg:getW()+2,gold_reg:getH()+4)
				end
			end
		else
			wait(0.1)
		end
	end	

	existsClickL(menu_back,2)
	return 1000000 -- can't check, better quit
end

-- Handles all result screen shenanigans, including Game Over, Dailies, Rank ups, Companion request buttons.

function resultsExit()
	local numfunc = 6

	if(debug_mode) then runlog("Results exit start",true) end

	-- Handle all the connection stuff and gameovers first.
	for i=0, 3000000 do
		usePreviousSnap(false)
		if(existsClickL(results_big,0)) then break end		
		usePreviousSnap(true)
		if (i%5 == 0) then
			connectionCheckNoWait()
		elseif (i%5 == 1) then
			if(existsL(backbtn,0)) then break end		
		elseif (i%5 == 2) then
			if(existsL(lapis,0)) then break end
		elseif (i%5 == 3) then
			if(existsL(revive,0)) then gameOver(); break end
		elseif (i%5 == 4) then
			if(existsL(giveup,0)) then gameOver(); break end
		end
	end

	-- Then do the clicking
	
	for i=0, 3000000 do
		usePreviousSnap(false)
		if(existsL(backbtn,0)) then break end
		usePreviousSnap(true)
		existsClickL(results_big,0)
		
		if ((existsClickL(nextbtn,0)) and debug_mode) then
			runlog("Next 1")
		elseif ((existsClickL(nextbtn2,0)) and debug_mode) then
			runlog("Next 2")
		elseif ((existsClickL(next_mission,0)) and debug_mode) then
			runlog("Next 3")
		elseif (i%numfunc == 1 and existsClickL(rank_up,0) and debug_mode) then
			runlog("Rank Up")
		elseif (i%numfunc == 3 and existsClickL(closebtn,0) and debug_mode) then
			runlog("Close Button")
		elseif (i%numfunc == 5 and existsClickL(no_request,0) and debug_mode) then
			runlog("No Request")
		end

	end

	usePreviousSnap(false)

	if(debug_mode) then  
		runlog("Results exit done",true)
	else
--		toast("Results exit done")
	end
end

-- Handles battle scenes in explorations

function exploreBattle()
	--boss = (boss or false)
	local auto_pressed = 0
	local findUnit = {}
	
	for i=0,10000 do
		usePreviousSnap(false)
		if (existsL(menuinbattle,0)) then break end
		usePreviousSnap(true)
		if (existsL(autobtn,0)) then break end
		if (existsL(autoonbtn,0)) then break end
		if (i > 100 and existsL(menu,0)) then return false end
		if (i > 200 and findMove()) then return false end
	end
	
	usePreviousSnap(false)

	if(debug_mode) then runlog("Explore battle start",true) end
	for i=0,300000 do
		if(existsClickL(results,0)) then
			if(debug_mode) then runlog("Result screen") end
		elseif (use_esper_battle and existsL(esperfilled,0)) then
			if (debug_mode) then getLastMatch():highlight(0.2); runlog("Esper Ready : ") end
			if (not existsClickL(autoonbtn,0)) then
				--if (bottom_reg:exists(IsReady,lagx/3)) then -- Old Version
				if (existsIsReady(bottom_reg,lagx/3)) then
					for p=1, #IsReady do
						findUnit[p] = findAllNoFindException(bottom_reg,IsReady[p])
						for i,u in ipairs(findUnit[p]) do
							dragDrop(Location(u:getX()+10,u:getY()+20),Location(u:getX()+190,u:getY()+20))
							wait(0.15+lagx/4)
							if (battleChoice("esper")) then break end
						end
					end

					endTurn("autobtn")
				end
			end
			auto_pressed = 0
		--elseif (exists(IsReady,lagx/3)) then --Old Version
		elseif (existsIsReady(sb_reg,lagx/3)) then
			endTurn()
		end
		usePreviousSnap(false)
		if(existsL(menu,0)) then break end
		usePreviousSnap(true)
		if(not existsL(menuinbattle,0)) then break end
		if(existsL(battle_won,0) or existsL(battle_won2,0) or existsL(continue_ask,0)) then break end
		if(existsL(revive,0)) then return end
		usePreviousSnap(false)
	end
	usePreviousSnap(false)
	battle_counter = battle_counter+1

	if(debug_mode) then
		runlog("Battle done: "..battle_counter,true) 
--	else
--		toast("Battle done: "..battle_counter)
	end

	for i=0,1000 do
		usePreviousSnap(false)
		if (existsL(menu,0)) then break end
		usePreviousSnap(true)
		if (findMove()) then break end
	end	
	
	return true
end

function exploreLeave()
	local rain_found = 0

	if(debug_mode) then runlog("Attempting to leave",true) end

	if(existsL(revive,0)) then return end

	for i=0,900000 do
		click(center)
		usePreviousSnap(false)
		existsClickL(explore_leave,0)
		usePreviousSnap(true)
		existsClickL(explore_yes,0)
		if(existsL(results_big,0)) then break end
		if(existsL(dungeon_clear,0)) then break end
		if(i%49 == 0 and i > 0 and findMove()) then rain_found = rain_found + 1 end
		if(rain_found > 5) then toast("Leave failed!") ; break end
		connectionCheckNoWait()
	end
	
	if (rain_found > 5) then
		if(debug_mode) then runlog("Leave failed!",true) end
		chaosExploraton()
	end

	usePreviousSnap(false)
end

function bossBattle()
	toast("Boss battle!")
	if(debug_mode) then runlog("Boss battle after move : "..move_counter,true) end
	for i=0,200000 do
		click(center)
		usePreviousSnap(false)
		existsClickL(explore_yes,0)
		usePreviousSnap(true)
		if(existsL(menuinbattle,0)) then 
			if (use_smart_battle) then
				smartBattle() ; break
			else
				exploreBattle() ; break
			end 
		end
		if(existsL(revive,0)) then return end
	end

	usePreviousSnap(false)

	if (bosses_encountered == 0 and enable_bosscheck_counter+4 <= move_counter) then enable_bosscheck_counter = move_counter - 3 end
	
	bosses_encountered = bosses_encountered + 1

	for i=0,30000 do
		if(existsL(revive,0)) then return end
--		usePreviousSnap(false)
		existsClickL(battle_won,0)
--		usePreviousSnap(true)
		existsClickL(battle_won2,0)
		if (leave_after_boss) then
			finished_explore = true
			existsClickL(explore_leave,0)
			break
		elseif(existsClickL(explore_continue,0)) then break end
		if(existsL(menu,0)) then break end
		if(existsL(revive,0)) then return end
	end

	usePreviousSnap(false)

end

function finishExplore()


	if(existsL(revive,0)) then return end

	if(not finished_explore and existsL(sense_hostile)) then 
		if(debug_mode) then runlog("Boss found") end
		bossBattle()
	else exploreLeave() end
	if (not findMoveSet) then
		findMoveSet = true
		findMoveReg = Region(findMoveX-15, findMoveY-15, findMoveX2-findMoveX+30, findMoveY2-findMoveY+30)
		if(debug_mode) then toast("Hightlighting Rain region"); findMoveReg:highlight(0.75) end
	end
	toast("Explore Finished!")
	if(debug_mode) then runlog("Explore Finished!",true) end
end

function connectionCheck()
--	if(debug_mode) then runlog("Connection check",true) end
	if(existsL(connection_error, lagx/4)) then 
		if(debug_mode) then runlog("Connection error") end
		if(existsClickL(connect_ok, lagx/4) and debug_mode) then runlog("Connect attempt") end
	end
end

function connectionCheckNoWait()
--	if(debug_mode) then runlog("Connection2 check",true) end
	if(existsL(connection_error, 0)) then 
		if(debug_mode) then runlog("Connection Error") end
		if(existsClickL(connect_ok, 0) and debug_mode) then runlog("Connect Attempt.") end
	end
end

function freeFarm()
	toast("Free farm")
	dialogInit()
	addRadioGroup("direction",1)
	addRadioButton("Left-Right",1)
	addRadioButton("Up-Down",2)
	dialogShow("Which direction?")
	findMove()
	enable_bosscheck_counter = 100000
	halt_on_gameover = true				-- never continue with free farm
	lagx = (0.01 * lagx) + 0.07
	while true do
		if(direction == 1) then
			go("left",2500+30000*lagx)
			go("right",2500+30000*lagx)
		elseif(direction == 2) then
			go("up",2500+30000*lagx)
			go("down",2500+30000*lagx)
		end
	end
end

function enchantedMaze()
	local lvbegin = Pattern("enchanted_maze_begin.png")
	local lv1 = Pattern("enchanted_maze_lv1.png")
	local lv2 = Pattern("enchanted_maze_lv2.png")
	local lv3 = Pattern("enchanted_maze_lv3.png")
	local lv4 = Pattern("enchanted_maze_lv4.png")
	local lv5 = Pattern("enchanted_maze_lv5.png")
	local lvexit = Pattern("enchanted_maze_exit.png")

	battle_counter = 0
	move_counter = 0
	bosses_encountered = 0
	enable_bosscheck_counter = 100
	
	if (debug_mode) then runlog("Enchanted maze start",true) end

	while(true) do
		if(existsL(lvbegin)) then
			if (debug_mode) then runlog("Enchanted maze begin",true) end
			go("up",3500+lagx*1000)
		end
		if(existsL(lv1)) then
			if (debug_mode) then runlog("Enchanted maze Lv.1",true) end
			go("up",3500+lagx*1000)
		end
		if(existsL(lv2)) then 
			if (debug_mode) then runlog("Enchanted maze Lv.2",true) end
			go("up",3500+lagx*1000) 
		end
		if(existsL(lv3)) then 
			if (debug_mode) then runlog("Enchanted maze Lv.3",true) end
--			go("up",1)
--			go("right",1)
			go("up",3500+lagx*500)
			go("left",3)
			go("up",1000+lagx*500)
		end
		if(existsL(lv4)) then
			if (debug_mode) then runlog("Enchanted maze Lv.4",true) end
--			go("up",1)
--			go("left",1)
			go("up",3500+lagx*500)
			go("right",3)
			go("up",1000+lagx*500)
		end
		if(existsL(lv5)) then
			if (debug_mode) then runlog("Enchanted maze Lv.5",true) end
			go("up",1000+lagx*500)
			go("left",3000+lagx*1000)
			go("up",3000+lagx*1000)
		end
		if(existsL(lvexit)) then
			if (debug_mode) then runlog("Enchanted maze exit",true) end
			go("up",4)
			break
		end
		if(existsL(results_big)) then 
			break
		end
	end
	
	if (debug_mode) then runlog("Enchanted maze done",true) end
end

-- earth shrine entrance SPEED mode. Ignores as much as possible to make it speedy.
-- One big self contained function.

function ese_speed(location)
	local func_state = 0
	local departed = false
	local unit1 = 1
	local unit2 = 3
	
	while (true) do
		if (departed == false) then 
		
			usePreviousSnap(false)
			if (existsL(lapis,0)) then
				usePreviousSnap(true)
			end

			connectionCheckNoWait()
			
			if (depart_count == 1) then wait(lagx*0.3) end
			
			if(existsClickL(special_farm["earth_shrine_entrance_speedmode"],0) and debug_mode) then runlog("Selected",true) end
					
			--out of energy handler
			if(func_state == 12 or existsL(no_nrg,0)) then 
				func_state = 12
				if(debug_mode) then runlog("Out of energy") end
				if(refill) then 
					toast("Burning lapis..."); if(debug_mode) then runlog("Refill lapis") end
					existsClickL(refill_lapis,0); 
					if (existsClickL(yesbtn,0)) then wait(lagx*0.3) ; func_state = 0  ; lapis_refill_count = lapis_refill_count + 1 end
				elseif (bottom_reg:existsClick(backbtn,0)) then -- DIFFERENT POSITION than the usual top left. Do NOT use learning.
					func_state = 0
					math.randomseed(os.time()); toast(waitmsg[math.random(#waitmsg)].. " now... Come back later."); wait(35+lagx*math.random(1,35))
				end
			end

			if (depart_count == 1) then wait(lagx*0.3) end

			-- next button
			if(existsL(backbtn,0)) then 
				if(existsClickL(next_i,0) and debug_mode) then runlog("Next!", true) end
			end
		
			if (depart_count == 1) then wait(lagx*0.3) end

			-- companion handler
			if(func_state == 21 or top_reg:exists(companion,0)) then				 -- DO NOT LEARN BUTTON LOC with this, as it may learn the button when it is still flying!
				if (func_state ~= 21) then
					func_state = 21
					if (friendsreg == nil) then
						wait(1.75) -- wait for animation
					else
					end
				elseif(friendsreg == nil and exists(friend,0)) then
					friendsreg = Region(getLastMatch():getX()-15,80,getLastMatch():getW()+90,height-60)
					if(debug_mode) then friendsreg:highlight(0.35) end
					friendsreg:existsClick(friend,0)
					if(debug_mode) then runlog("Companion : Standard", true) end
					func_state = 0
				elseif(friendsreg ~= nil and friendsreg:exists(friend,0)) then
					friendsreg:existsClick(friend,0)
					if(debug_mode) then friendsreg:getLastMatch():highlight(0.2) ; runlog("Companion : Standard", true) end
					func_state = 0
				elseif(top_reg:exists(no_companion,0)) then
					if(debug_mode) then getLastMatch():highlight(0.2) ; runlog("No Companions", true) end
					top_reg:existsClick(no_companion,0)
					func_state = 0
				else
					if(debug_mode) then runlog("Warning : Unknown Companion", true) end
--					click(Location(300,480))
--					func_state = 0
				end
			end
			
			if (depart_count == 1) then wait(lagx*0.3) end

			-- depart handler
			if(func_state == 31 or bottom_reg:exists(departbtn,0)) then     -- DO NOT LEARN BUTTON LOC with this, as it may learn the button when it is still flying!
				if (func_state ~= 31) then
					func_state = 31
					if (buttonreg[departbtn] == nil) then
						wait(0.7+lagx/2) -- wait for animation
					else
						wait(0.1)
					end
				elseif(existsClickL(departbtn,0)) then
					if(debug_mode) then getLastMatch():highlight(0.2) ; runlog("Depart Button : ") 	end
					departed = true
					func_state = 0
				end
			end
			
		else	-- departed is true

			usePreviousSnap(false)
			if (existsL(lapis,0)) then
				usePreviousSnap(true)
			end
				-- handle the unit data changed error
			if existsL(unitdatachanged,0) then
				if(debug_mode) then runlog("Depart failed - unit data changed") 	end
				departed = false
				existsClickL(connect_ok, 0)
				wait (0.5+lagx/3)
			elseif (existsL(connection_error,0)) then 
				if(debug_mode) then runlog("Connection Error") end
				if(existsClickL(connect_ok, 0) and debug_mode) then runlog("Pressed Ok") end
				break
			elseif (not existsL(lapis,0)) then
				if(debug_mode) then runlog("Departed : ") 	end
				break
			end
		end
	end

	--waiting for connection here
	while(true) do
		usePreviousSnap(false)
		if(existsL(menuinbattle,0)) then break end
		usePreviousSnap(true)
		if(existsL(menu,0)) then break end
		connectionCheckNoWait()
	end

	--extra wait for really checking if we're ready
	while(true) do
		if(existsL(menuinbattle,0)) then break end
	end

	--create regions
	while(sb_reg == nil) do
		defineSBreg()
	end
	
	if (depart_count == 1) then wait(lagx*0.3) end
	
    --battle functions
	while(existsL(menuinbattle,0)) do
		click(Location(sb_regunit[unit1]:getX() + sb_regunit[unit1]:getW()/2, sb_regunit[unit1]:getY() + (sb_regunit[unit1]:getH()/2)))		
		click(Location(sb_regunit[unit2]:getX() + sb_regunit[unit2]:getW()/2, sb_regunit[unit2]:getY() + (sb_regunit[unit2]:getH()/2)))		
	end

	-- Handle all the connection stuff and gameovers first.
	for i=0, 3000000 do
		if (depart_count == 1) then wait(lagx*0.2) end
		usePreviousSnap(false)
		if(existsClickL(results_big,0)) then break end		
		usePreviousSnap(true)
		connectionCheckNoWait()
	end

	-- Then do the clicking
	
	for i=0, 3000000 do
		if (depart_count == 1) then wait(lagx*0.5) end
		usePreviousSnap(false)
		if(existsL(backbtn,0)) then break end
		usePreviousSnap(true)
		existsClickL(results_big,0)
		
		if ((existsClickL(nextbtn,0)) and debug_mode) then
			runlog("Next 1")
		elseif ((existsClickL(nextbtn2,0)) and debug_mode) then
			runlog("Next 2")
		elseif ((existsClickL(next_mission,0)) and debug_mode) then
			runlog("Next 3")
		elseif (i%7 == 4 and existsClickL(rank_up,0) and debug_mode) then
			runlog("Rank Up")
		elseif (i%7 == 6 and existsClickL(closebtn,0) and debug_mode) then
			runlog("Close Button")
		elseif ((i%5 == 2 or buttonreg_learned[no_request] == true)) then
			if (buttonreg_learned[no_request] == false) then
				if (exists(no_request,0)) then
					wait(lagx * 0.75)													-- wait for animation
					usePreviousSnap(false)
					existsClickL(no_request,0)
					if (debug_mode) then runlog("No Request Learn") end
				end
			else
				if (debug_mode) then runlog("No Request") end
				usePreviousSnap(false)
				wait(lagx*0.1)
				existsClickL(no_request,0)
			end
		end

	end

	usePreviousSnap(false)
end

-- Main arena function
function arena()
	local func_state = 0
	local findRatio = nil
	
	while (true) do
		wait(lagx*0.5)
		usePreviousSnap(false)
		connectionCheckNoWait()
		usePreviousSnap(true)

		if(existsL(no_nrg) or exists(arena_emptyorbs)) then
			if(debug_mode) then runlog("Out of energy") end
			existsClickL(arena_no)
			if(refill) then
				toast("Burning lapis..."); if(debug_mode) then runlog("Refill lapis") end
				existsClickL(refill_lapis,0);
				if (existsClickL(yesbtn,0)) then
					wait(lagx*0.3)
					func_state = 0
					lapis_refill_count = lapis_refill_count + 1
				end
			elseif (bottom_reg:existsClick(backbtn,0)) then -- DIFFERENT POSITION than the usual top left. Do NOT use learning.
				func_state = 0
				math.randomseed(os.time()); toast(waitmsg[math.random(#waitmsg)].. " now... Come back later."); wait(60+lagx*math.random(40,95))
			else
				func_state = 0
				math.randomseed(os.time()); toast(waitmsg[math.random(#waitmsg)].. " now... Come back later."); wait(60+lagx*math.random(40,95))
			end
		end
		if (func_state == 0) then
			existsClickL(arena_ok)
			existsClickL(arena_setup)
			if (existsL(arena_opponent)) then
				func_state = 1
			end
		elseif (func_state == 1 ) then
			if (exists(arena_ratio)) then
				if (ratio_choice == "High") then
					findRatio = findAllNoFindException(arena_ratio)
					click(findRatio[1])
				else
					dragDrop(bottom,top)
					dragDrop(bottom,top)
					dragDrop(bottom,top)
					wait(lagx*0.2+0.3)
					findRatio = findAllNoFindException(arena_ratio)
					click(findRatio[#findRatio])
				end
				func_state = 2
			end
		elseif (func_state == 2 ) then
			if (existsL(arena_youcannotgoback)) then existsClick(arena_entryyes,0) end
			if (existsClickL(arena_begin)) then break end
		end
	end
	
	--waiting for connection here
	while(true) do
		usePreviousSnap(false)
		if(existsL(menuinbattle,lagx/3)) then break end
		usePreviousSnap(true)
		if(existsL(menu,0)) then break end
		connectionCheckNoWait()
		existsClickL(arena_begin)
	end
	if (use_repeat_battle) then
		endTurn("repeatbtn")
	else
		smartBattle_arena()
	end
	
	while(true) do
		usePreviousSnap(false)
		connectionCheckNoWait()
		usePreviousSnap(true)
		endTurn()
		existsClickL(arena_won)
		existsClickL(arena_lost)
		existsClickL(arena_resultsok1)
		existsClickL(arena_resultsok2)
		existsClickL(arena_resultsok3)
		if (existsL(arena_setup) or existsL(arena_opponent) or existsL(arena_ok)) then break end
	end
end


-- Main function for everything dungeons, explorations, vortexes, and raids.
-- Always assume start from mission selection screen.

function fFarm(location)
	local tempi = 0
	local func_state = 0
	local departed = false
	local findComp = nil
	local findCompReg = nil
	local compATK = -1
	local highestATK = -1
	local highestATKBtn = nil
	local returnval = false
	
	companion_used = false
	
	while (true) do
		if (departed == false) then 

			wait(0.1+lagx/10)
			
			usePreviousSnap(false)
			if (existsL(lapis,0)) then
				usePreviousSnap(true)
			end

			if(string.match(location,"custom_")) then 
				if(existsClickL(exploration,0) and debug_mode) then runlog("Custom Exploration",true) end
				tempbtn = getLastMatch()
			elseif(location=="dungeon_finder") then
				--toast("Custom dungeon")
				if (left_reg:exists(dungeon,0)) then
					click(dungeonfarm[location])
					tempbtn = dungeonfarm[location]
					if(debug_mode) then runlog("Dungeon Finder",true) end
				end
			else
				if(location=="orbonne_monastery_vault_exploration") then dragDrop(bottom,top);wait(3);dragDrop(bottom,top) end --swipe to vault explore section
				if(existsClickL((explorefarm[location]),0) and debug_mode) then runlog("Selected",true) end
				tempbtn = getLastMatch()
			end
					
			--out of raid orbs handler
			if(func_state == 11 or existsL(insufficient_raid_orbs,0)) then 
				func_state = 11
				if(debug_mode) then runlog("Out of raid orbs") end
				if(refill) then 
					toast("Burning lapis..."); if(debug_mode) then runlog("Refill lapis") end
					existsClickL(refill_lapis,0)
					if (existsClickL(yesbtn,0)) then wait(lagx*0.3) ; func_state = 0 ; lapis_refill_count = lapis_refill_count + 1 end
				elseif(existsClickL(raid_orbs_no,0)) then
					func_state = 0
					math.randomseed(os.time()); toast(waitmsg[math.random(#waitmsg)].. " now... Come back way later."); wait(90+lagx*3*math.random(1,4)*math.random(1,30))
				end
			end

			--out of energy handler
			if(func_state == 12 or existsL(no_nrg,0)) then
				func_state = 12
				if(debug_mode) then runlog("Out of energy") end
				if(refill) then
					toast("Burning lapis..."); if(debug_mode) then runlog("Refill lapis") end
					existsClickL(refill_lapis,0);
					if (existsClickL(yesbtn,0)) then wait(lagx*0.3) ; func_state = 0  ; lapis_refill_count = lapis_refill_count + 1 end
				elseif (bottom_reg:existsClick(backbtn,0)) then -- DIFFERENT POSITION than the usual top left. Do NOT use learning.
					func_state = 0
					math.randomseed(os.time()); toast(waitmsg[math.random(#waitmsg)].. " now... Come back later."); wait(35+lagx*math.random(1,35))
				end
			end

			-- next button
			if(existsL(backbtn,0)) then 
				if(existsClickL(next_i,0) and debug_mode) then runlog("Next!", true) end
			end
		
			-- companion handler
			if(func_state == 21 or exists(companion,0)) then				 -- DO NOT LEARN BUTTON LOC with this, as it may learn the button when it is still flying!
				if (func_state ~= 21) then
					func_state = 21
					if ((use_bonus_unit == true and friendsBONUSreg == nil) and (friendsreg == nil)) then
						wait(0.7 + lagx * 0.5) -- wait for animation
					else
						wait(0.2 + lagx * 0.2)
					end
				elseif use_bonus_unit == true and friendsBONUSreg == nil and left_reg:exists(bonus_unit,0.5+lagx*0.8) then			-- BONUS! image pulses, soooo needs time.
					tempbtn = left_reg:getLastMatch()
					friendsBONUSreg = Region(tempbtn:getX()-30,120,tempbtn:getW()+60,1000)
					if(debug_mode) then friendsBONUSreg:highlight(0.35) ; runlog("Companion : Bonus", true) end
					click(tempbtn)
					companion_used = true
					func_state = 0
				elseif use_bonus_unit == true and friendsBONUSreg ~= nil and friendsBONUSreg:existsClick(bonus_unit,(lagx*1.3)+0.9) then								-- BONUS! image pulses, soooo needs time.
					if(debug_mode) then runlog("Companion : Bonus", true) end
					companion_used = true
					func_state = 0
				elseif(friendsreg == nil and exists(friend,0)) then
					friendsreg = Region(getLastMatch():getX()-15,80,getLastMatch():getW()+30,height-60)
					if(debug_mode) then friendsreg:highlight(0.35) end
					if (use_highest_atk_companion == false) then
						friendsreg:existsClick(friend,0)
						companion_used = true
						if(debug_mode) then getLastMatch():highlight(0.2) ; runlog("Companion : Standard", true) end
					else
						findComp = regionFindAllNoFindException(friendsreg,friend)
						for i,u in ipairs(findComp) do
							findCompReg = Region(u:getX()+37,u:getY(),112,35)
							if (debug_mode) then findCompReg:highlight(0.15) end
							compATK, returnval = numberOCRNoFindException(findCompReg,"gil")
							if (returnval) then
								if(debug_mode) then runlog("CompATK :"..compATK,true) end
								if (compATK > highestATK) then
									highestATK = compATK
									highestATKBtn = u
								end
							end
						end
						companion_used = true
						click (highestATKBtn)
					end
					func_state = 0
				elseif(friendsreg ~= nil and friendsreg:exists(friend,0)) then
					if (use_highest_atk_companion == false) then
						friendsreg:existsClick(friend,0)
						companion_used = true
						if(debug_mode) then friendsreg:getLastMatch():highlight(0.2) ; runlog("Companion : Standard", true) end
					else
						findComp = regionFindAllNoFindException(friendsreg,friend)
						for i,u in ipairs(findComp) do
							findCompReg = Region(u:getX()+37,u:getY(),112,35)
							if (debug_mode) then findCompReg:highlight(0.15) end
							compATK, returnval = numberOCRNoFindException(findCompReg,"gil")
							if (returnval) then
								if(debug_mode) then runlog("CompATK :"..compATK,true) end
								if (compATK > highestATK) then
									highestATK = compATK
									highestATKBtn = u
								end
							end
						end
						companion_used = true
						click (highestATKBtn)
					end
					func_state = 0
				elseif(top_reg:exists(no_companion,0)) then
					tempbtn = top_reg:getLastMatch()
					if(debug_mode) then getLastMatch():highlight(0.2) ; runlog("No Companions", true) end
					click(tempbtn)
					companion_used = false
					func_state = 0
				else
					if(debug_mode) then runlog("Warning : Unknown Companion", true) end
					click(Location(300,350*aRatio))
					click(tempbtn)
					companion_used = false
					func_state = 0
				end
			end
			
			-- depart handler
			if(func_state == 31 or bottom_reg:exists(departbtn,0)) then     -- DO NOT LEARN BUTTON LOC with this, as it may learn the button when it is still flying!
				if (func_state ~= 31) then
					func_state = 31
					if (buttonreg[departbtn] == nil) then
						wait(0.7+lagx/2) -- wait for animation
					else
						wait(0.1)
					end
				elseif(existsClickL(departbtn,0)) then
					if(debug_mode) then getLastMatch():highlight(0.2) ; runlog("Depart Button : ") 	end
					departed = true
					func_state = 0
				end
			end
			
		else	-- departed is true

			usePreviousSnap(false)
			if (existsL(lapis,0)) then
				usePreviousSnap(true)
			end
				-- handle the unit data changed error
			if existsL(unitdatachanged,0) then
				if(debug_mode) then runlog("Depart failed - unit data changed") 	end
				departed = false
				existsClickL(connect_ok, 0)
				wait (0.5+lagx/3)
			elseif (existsL(connection_error,0)) then 
				if(debug_mode) then runlog("Connection Error") end
				if(existsClickL(connect_ok, 0) and debug_mode) then runlog("Pressed Ok") end
				break
			elseif (not existsL(lapis,0)) then
				if(debug_mode) then runlog("Departed : ") 	end
				break
			end
		end
	end

	--waiting for connection here
	while(true) do
		usePreviousSnap(false)
		if(existsL(menuinbattle,lagx/3)) then break end
		usePreviousSnap(true)
		if(existsL(menu,0)) then break end
		connectionCheckNoWait()
	end
	
	if(string.match(location,"_exploration") or string.match(location,"custom_")) then explore2(location)
	elseif(location=="enchanted_maze_BGN") then enchantedMaze()
	elseif(use_smart_battle==true) then smartBattle()
	elseif(use_esper_battle==true) then battleEsper()
	else
		while(existsL(menuinbattle,3)) do
			endTurn()
		end
	end
	resultsExit() -- handle results screen
end

-- Go x ms or steps in what direction function for explorations.

function go(loc,steps)
	steps = steps or 1
	move_counter = move_counter + 1
	if(step_mode==2) then  -- always single step
		if(steps > 100) then
			if(debug_mode) then runlog("Going "..loc.." "..(steps/100).." steps",true) end
			for i=1,steps/100 do --convert to single steps
				if (not findMove() and not (existsL(menu,0))) then break
				elseif(move_counter >= enable_bosscheck_counter and existsL(sense_hostile,0)) then break end
				click((_G[loc])[2])
				wait(0.1+math.max(0,(lagx-1)/3))
			end
			usePreviousSnap(false)
--			wait(0.25+lagx/2)
			if((not findMove()) and not (existsL(menu,0))) then 
				exploreBattle()
				if(existsL(revive,0)) then return end
				if (move_counter >= enable_bosscheck_counter) then
					move_counter = move_counter - 1
					go(loc,steps)
				else
					move_counter = move_counter - 1
					go(loc,steps-math.max(0,i-3))
				end
			elseif(move_counter >= enable_bosscheck_counter and existsL(sense_hostile,0.4+lagx/2)) then bossBattle()
			else
				go(loc,steps-math.max(0,i-2))
			end
		else
			if (not findMove() and not (existsL(menu,0))) then exploreBattle() end
			for i=1,steps do
				if(debug_mode) then runlog("Step #"..i.." of "..steps,true) end
				if(alt_step) then click((_G[loc])[2]) ; wait(0.1)
				else
					setDragDropTiming(100,20)
					dragDrop(center,(_G[loc])[1])
				end
				wait(0.1+math.max(0,(lagx-1)/3))
				if(move_counter >= enable_bosscheck_counter and existsL(sense_hostile,0.4+lagx/2)) then bossBattle()
				elseif(not findMove() and not (existsL(menu,0))) then exploreBattle() ; if(existsL(revive,0)) then return end end
			end
		end
	else -- swiping
		if(steps > 20) then -- swiping for ms
			--toast("Going "..loc.." "..steps.."ms")
			setDragDropTiming(100,steps)
			if(debug_mode) then runlog("Going "..loc.." "..steps.."ms",true) end
			dragDrop(center,_G[loc][1])
			wait(0.1+math.max(0,(lagx-1)/5))
			if(move_counter >= enable_bosscheck_counter and existsL(sense_hostile,0.4+lagx/2)) then bossBattle()
			elseif(not findMove() and not (existsL(menu,0))) then exploreBattle() ; if(existsL(revive,0)) then return end ; move_counter = move_counter - 1 ; go(loc,steps) end
		else
			if (not findMove() and not (existsL(menu,0))) then exploreBattle() ; if(existsL(revive,0)) then return end end
			for i=1,steps do -- single step click
				if(debug_mode) then runlog("Step #"..i.." of "..steps,true) end
				if(alt_step) then click((_G[loc])[2]) ; wait(0.1)
				else
					setDragDropTiming(100,20)
					dragDrop(center,(_G[loc])[1])
				end
				wait(0.1+math.max(0,(lagx-1)/3))
				if(move_counter >= enable_bosscheck_counter and existsL(sense_hostile,0.3+lagx/2)) then bossBattle()
				elseif (not findMove() and not (existsL(menu,0))) then exploreBattle() ; if(existsL(revive,0)) then return end end
			end
		end
	end
end

-- Handles game over events. To be called from resultsExit().

function gameOver()
	usePreviousSnap(false)
	if(existsL(revive,lagx/2)) then 
		if (not halt_on_gameover) then
			existsClickL(nobtn); wait(0.5+(1.2*lagx)) 
		else
			scriptExit("Game Over")
		end
	end
	if(existsL(giveup,lagx/2)) then existsClickL(yesbtn); wait(1+(1.25*lagx)); gameover_count = gameover_count + 1 end
end

function explore2(location)
	battle_counter = 0
	move_counter = 0
	bosses_encountered = 0
	finished_explore = false
	
	if (goldcheck_success == false) then gold_reg = nil end
	
	while(true) do
		connectionCheck()
		if(exists(menu,1)) then break end
	end
	if(debug_mode) then runlog("Explore start",true) end
	wait(lagx/4)
	
	findMove()
	
	for i,v in pairs(getPath(explorePath[location])) do
		if(finished_explore) then	break end
		if(exists(revive,0)) then return end
		
		if(v:split(",")[1]=="battle") then -- find battle
			if(loot) then findBattle(v:split(",")[2],tonumber(v:split(",")[3]),v:split(",")[4]) end
		elseif(v:split(",")[1]=="battleex") then -- find battleEx
			if(loot) then findBattleEx(v:split(",")[2],tonumber(v:split(",")[3]),tonumber(v:split(",")[4]),tonumber(v:split(",")[5]),v:split(",")[6]) end
		elseif(v:split(",")[1]=="findmove") then toast("Hello!") -- update position
		elseif(v:split(",")[1]=="wait") then 
			if(debug_mode) then runlog("Wait "..(tonumber(v:split(",")[2]) * (1+lagx/4)).." ms",true) end
			wait((tonumber(v:split(",")[2]) * (1+lagx/4))/1000) -- wait a while
		elseif(v:split(",")[1]=="transition") then 
			if(debug_mode) then runlog("Transition "..(tonumber(v:split(",")[2]) * (1+lagx/4)).." ms",true) end
			wait((tonumber(v:split(",")[2]) * (1+lagx/4))/1000) -- wait a while
			while (true) do
				if (exists(menu,0)) then break end
				if (findMove()) then break end
			end
		elseif(v:split(",")[1]=="leaveafterboss") then
--			if(debug_mode) then runlog("Leaving after boss",true) end		
			leave_after_boss = true -- leave after boss battle
		elseif(v:split(",")[1]=="bosscheck") then 
--			if(debug_mode) then runlog("Boss checks after move : "..tonumber(v:split(",")[2]),true) end				
			enable_bosscheck_counter = tonumber(v:split(",")[2]) -- boss check counter
		elseif(v:split(",")[1]=="ur" or v:split(",")[1]=="ul" or v:split(",")[1]=="dr" or v:split(",")[1]=="dl") then
			if(tonumber(v:split(",")[2])>20) then
				if(step_mode==2 or move_counter >= enable_bosscheck_counter or tonumber(v:split(",")[2])<1200) then
					go(v:split(",")[1],(tonumber(v:split(",")[2])*(0.70+(lagx*0.30))))
				elseif(tonumber(v:split(",")[2])<3500) then
					go(v:split(",")[1],(tonumber(v:split(",")[2])*(0.35+(lagx*0.16))))
					go(v:split(",")[1],(tonumber(v:split(",")[2])*(0.35+(lagx*0.16))))
				else
					go(v:split(",")[1],(tonumber(v:split(",")[2])*(0.235+(lagx*0.11))))
					go(v:split(",")[1],(tonumber(v:split(",")[2])*(0.235+(lagx*0.11))))
					go(v:split(",")[1],(tonumber(v:split(",")[2])*(0.235+(lagx*0.11))))
				end
			else
				go(v:split(",")[1],tonumber(v:split(",")[2]))  -- single steps
			end
		else
			if(tonumber(v:split(",")[2])>20) then
					go(v:split(",")[1],(tonumber(v:split(",")[2])*(0.70+(lagx*0.30))))
			else
				go(v:split(",")[1],tonumber(v:split(",")[2]))  -- single steps
			end
		end
	end
	finishExplore()
end

-- I guess this is only useful for "esper" for now.

function battleChoice(unittype)
	local Esper = Pattern("SB_Esper.png")

	if (unittype == "esper") then				-- ESPER only
		if(control_reg:existsClick(Esper,lagx*0.2)) then 
			if (debug_mode) then runlog("Esper click : ") end
			return true
		else
			control_reg:existsClick(BackButton,0)
			return false
		end
	end
	
	usePreviousSnap(false)
	wait(0.2)
	control_reg:existsClick(BackButton,0)
	return true
end

-- This function added by NonceCents 8/20/2017 for ffbeZ19
--This function takes an array of unit numbers and their cast delays in frames (60 frames per second).
--Doing this allows certain skills to be cast before others (breaks, buffs, etc), and other skills to be timed for chaining.
function skillCast(castdelay)

	--This creates an array of keys for the units which represents the order in which they will be clicked
	local sortedDelayKeys = pairsByValues(castdelay, function(a, b) return a < b end)
	local numunits = 0
	local waittime = 0
	local elapsedframes = 0
	local unitbuttonloc = {}
	local t = Timer()

	usePreviousSnap(false)

	--If Chain Helper Manual mode is used, unit button locations are built from manually-configured regions since the sb_reg and sb_regunits were not defined in order to maximize speed.
	if(farmloc == "chain_helper" and chain_mode == "Manual Select") then
		for n, r in pairs(castdelay) do
			unitbuttonloc[n] = Location(unitreg[n]:getX() + unitreg[n]:getW()/2, unitreg[n]:getY() + (unitreg[n]:getH()/2))
		end
	else
		--Iterates through the units to prepare tap locations
		for n, r in pairs(sb_regunit) do
			unitbuttonloc[n] = Location(sb_regunit[n]:getX() + sb_regunit[n]:getW()/2, sb_regunit[n]:getY() + (sb_regunit[n]:getH()/2))
		end
	end

	--Array that will contain actions, wait times and targets for clicking units
 	local castorder = {}

	--Builds the table that the manualTouch AnkuLua function will use to perform a fast series of timed taps on units
	for _, i in ipairs(sortedDelayKeys) do
		if (unitbuttonloc[i] ~= nil) then
			waittime = ((castdelay[i] - elapsedframes) / 60)
			table.insert(castorder, {action = "wait", target = waittime})
			table.insert(castorder, {action = "touchDown", target = unitbuttonloc[i]})
			table.insert(castorder, {action = "touchUp", target = unitbuttonloc[i]})
			elapsedframes = castdelay[i]
		end
	end

	t:set()
	--Taps units in order of earliest casts first with appropriate wait times between
	manualTouch(castorder)

	local taptime = t:check()*60

	if (debug_mode) then runlog("Skillcast took "..taptime.." frames to complete.") end

	if (farmloc ~= "chain_helper") then

		--This will tap anything left over (usually companion unit)
		--while (existsClick(IsReady,lagx*0.75)) do wait(0.25+lagx*0.35) end -- Old version
		while (existsClickIsReady(sb_reg,lagx*0.75)) do wait(0.25+lagx*0.35) end

		--On occasion, a series of units being tapped at the same time happens faster than the game recognizes
		--this will look for the menu button still existing, no units "ready" (they may have skills queued and not the sword icon)
		--this will use the endTurn function with the Auto button to address anything left over (including if somehow we entered a menu)
		--if ((existsL(menuinbattle,lagx*0.75) and not sb_reg:exists(IsReady,lagx*0.75)) or existsL(BackButton,lagx*0.75)) then --Old Version
		if ((existsL(menuinbattle,lagx*0.75) and not existsIsReady(sb_reg,lagx*0.75)) or existsL(BackButton,lagx*0.75)) then
			endTurn("autobtn")
		end

		usePreviousSnap(true)
	else
		--toast("Performed all taps in "..(t:check()*60).." frames.")
		setStopMessage("Performed all taps in "..taptime.." frames.")
	end
end

-- This function added by NonceCents 7/23/2017 for ffbeZ19
-- Used for consistent end-of-turn handling. Decides whether to push Auto or Repeat.
-- Passing "autobtn" or 'true'  to the function will force the use of the Auto button despite Press Repeat setting.
-- Passing "repeatbtn" or 'false' to the function will force the use of the Repeat button despite Press Auto setting.
-- Passing no value to the function will default to the Use Auto or Use Repeat preference specified by the player.
-- NOTE: default behavior unless Press Repeat is selected is to Press Auto (as "use_repeat_battle" is initialized as 'false')
function endTurn(forcebutton)
	usePreviousSnap(false)

	wait(lagx/2)

	--Clicks Back button if it exists
	if(existsClickL(BackButton, 0)) then
		runlog("Exists Click Back", true, debug.getinfo(1).currentline)
		wait(lagx/4)
	end

	-- Returns false if no longer in battle (Battle Menu button doesn't appear to exist)
	if(not existsL(menuinbattle, 0)) then
		--toast("Not in battle!")
		return false

	-- If Repeat button specified to be used clicks it, then looks for any units that may not have performed an ability and clicks on them
	elseif((forcebutton == "repeatbtn" or (forcebutton == nil and use_repeat_battle)) and existsClickL(repeatbtn,lagx/4)) then
		if(debug_mode) then runlog("Repeat : ") end
		--wait(lagx/4)
		--while (existsClick(IsReady,lagx*0.75)) do wait(0.25+lagx*0.35) end --Old version
		while (existsClickIsReady(bottom_reg,lagx/4)) do wait(0.25+lagx*0.35) end
		wait(lagx*0.5)
		return true

	-- If repeat button is not to be used, clicks the Auto button, then clicks the Auto-On button to turn Auto back off again
	elseif((forcebutton == "autobtn" or (forcebutton == nil and not use_repeat_battle)) and existsClickL(autobtn,lagx/4)) then
		if(debug_mode) then runlog("Auto : ") end
		wait(lagx/4)
		while(not existsL(autobtn,lagx)) do
			if(existsClickL(autoonbtn,lagx)) then return true
			elseif(existsClickL(BackButton, 0)) then
				runlog("Exists Click Back",true,debug.getinfo(1).currentline)
				wait(lagx/4)
			elseif(not existsL(menuinbattle, 0)) then return false
			end
		end
	end

	usePreviousSnap(true)
end

-- Auto Battle, the standard way in dungeons.

function battleAuto()
	local tempi = 0

	while(true) do
		tempi = tempi + 1
		endTurn()
		if(tempi%19==0) then connectionCheckNoWait() end
		if(tempi%17==0 and existsL(revive,0)) then break end
		existsClickL(text_continue,0)
		if(existsL(results_big,0)) then break end
		if(existsL(questclear,0)) then break end
		if(not existsL(menuinbattle,0)) then break end
	end
	usePreviousSnap(false)

end

-- Dungeon battle with Esper enabled.

function battleEsper()
	local tempi = 0
	--boss = (boss or false)
	local auto_pressed = false

	while(true) do
		tempi = tempi + 1
		usePreviousSnap(false)
		if (existsL(esperfilled,lagx/5)) then
			if (debug_mode) then getLastMatch():highlight(0.2); runlog("\tEsper - ") end
			if (not existsClickL(autoonbtn,0)) then
				usePreviousSnap(true)
				--if (bottom_reg:exists(IsReady,0)) then --Old Version
				if(existsIsReady(bottom_reg,0)) then
					auto_pressed = false
					dragDrop(Location(getLastMatch():getX()+20,getLastMatch():getY()+30),Location(getLastMatch():getX()+250,getLastMatch():getY()+30))
					wait(0.1+lagx/4)
					usePreviousSnap(false)
					battleChoice("esper")
					endTurn("autobtn")
				end
			end
			usePreviousSnap(false)
		elseif (tempi > 0 and tempi%49 == 0) then
			auto_pressed = false
		else
			if(not auto_pressed and endTurn("autobtn")) then 
				if (debug_mode) then getLastMatch():highlight(0.2); runlog("\tAuto - ") end
				auto_pressed = true
			elseif (not auto_pressed and existsL(autoonbtn,0)) then
				if (debug_mode) then getLastMatch():highlight(0.2); runlog("\tAuto is on ") end
				auto_pressed = true			
			end
		end
		if(existsL(results,0)) then
			if(debug_mode) then runlog("Result screen") end
			click(getLastMatch())
		end
		usePreviousSnap(true)
		if(existsL(menu,0) or existsL(battle_won,0) or existsL(battle_won2,0) or existsL(continue_ask,0)) then break end
		if(tempi%17==0 and exists(revive,0)) then break end
		if(existsL(results_big,0)) then click(getLastMatch()) ; click(center) ; click(Location(300,890 * aRatio)) ; break end
		if(existsL(questclear,0)) then break end
		existsClickL(text_continue,0)
		if(not existsL(menuinbattle,0)) then break end
	end
	usePreviousSnap(false)
end

-- Helper function for Attack text skill finding
function smartBattle_isAttack(text_reg)
	for t=1,#SB_Damage do 
		if(text_reg:exists(SB_Damage[t],0)) then 
			return true
		end
	end
	return false
end

-- Helper function for Attack Icon skill finding
function smartBattle_isAttackIcon(icon_reg)
	for t=1,#SB_AttackIcons do 
		if(icon_reg:exists(SB_AttackIcons[t],0)) then 
			return true
		end
	end
	return false
end

-- Helper function for Not Attack Icon skill finding
function smartBattle_isNotAttackIcon(icon_reg)
	for t=1,#SB_NonAttackIcons do 
		if(icon_reg:exists(SB_NonAttackIcons[t],0)) then 
			return true
		end
	end
	return false
end

-- Helper function for Abilities Unavailable finding
function smartBattle_AbilitiesAvailable(text_reg)
	if(text_reg:exists(SB_AbilitiesUnavailable,0)) then 
		return false
	end
	return true
end

-- Helper function for AoE skill finding
function smartBattle_isAoE(text_reg)
	for t=1,#SB_Enemies do 
		if(text_reg:exists(SB_Enemies[t],0)) then 
			return true
		end
	end
	return false
end

-- New function smart battle will select skills.
-- choose function for smartBattle
-- Needs to have regions defined first

function smartBattle_choose(skilluse, skillmp)

	while(sb_reg == nil) do
		defineSBreg()
	end

	local selection = nil
	local selectionmp = 0
	local checkValue = 0				-- add all MPs found in a formula and if it's the same then quit (we reached the end of the skill list)
	local checkValue_last = 12345

	local detectMaxMP = 0
	local mp = 0
	local retval = false
	local numunits = #sb_regunit

	-- Need to revisit this for scenarios where party < 5
	if (#sb_regunit == 6) then
		companion_used = true
		numunits = #sb_regunit-1
	end
	
	if (debug_mode) then runlog("Num Units "..numunits) end
	
	-- for loop iterates through each unit
	for i, r in pairs(sb_regunit) do
		if (i ~= 6) then
			if (debug_mode) then sb_regunit[i]:highlight(0.2) end
			if (skilluse[i] == "None") then --Does nothing if no skill selected
			elseif (skilluse[i] == "Any Attack" or skilluse[i] == "Any AoE Attack" or skilluse[i] == "Any Single-Target Attack") then
				smartBattle_auto(skilluse[i],skillmp[i],i)
				wait(0.2+lagx*0.25)
			--NonceCents: Disabled this block of code; smartBattle_Companion has been renamed smartBattle_auto and is taking over this functionality.
			--[[
			--This section looks for an appropriate skill if "Any Attack" or "Any AoE Attack" was specified by the user
			elseif (skilluse[i] == "Any Attack" or skilluse[i] == "Any AoE Attack") then
				selectionmp = 0
				detectMaxMP = 0
				checkValue = 0
				retval = false
				usePreviousSnap(false)

				--Check for unit being ready
				--if (sb_regunit[i]:exists(IsReady,lagx*0.75)) then -- Old Version
				if (existsIsReady(sb_regunit[i],lagx*0.75)) then
					skillSuccess = false
					skillTries = 0
					--if (debug_mode) then runlog("Unit #"..i.." action: "..skilluse[i]..", MP : "..skillmp[i], true, debug.getinfo(1).currentline) end
					setDragDropStepCount(50)
					setDragDropStepInterval(1)
					setDragDropTiming(100,20)
					--Swipes right on unit for skill menu
					dragDrop(Location(sb_regunit[i]:getX() + 15, sb_regunit[i]:getY() + (sb_regunit[i]:getH()/2)), Location(sb_regunit[i]:getX() + sb_regunit[i]:getW() - 15, sb_regunit[i]:getY() + (sb_regunit[i]:getH()/2)))
					usePreviousSnap(false)
					setDragDropStepCount(145+lagx*75)
					setDragDropStepInterval(1)
					setDragDropTiming(100,400+lagx*50)
					wait(0.2+lagx*0.25)

					-- Finds a skill with the minimum MP requirement then checks to see if it's an Attack or AoE skill
					while(true) do
						if (skillSuccess) then
							break
						elseif (sb_reg:exists(SB_MP, 0)) then
							usePreviousSnap(true)
							checkValue = 0
							findSkills = regionFindAllNoFindException(sb_reg,SB_MP)
							for n, m in ipairs(findSkills) do
								if (debug_mode) then m:highlight(0.2) end
								mp_reg = Region(m:getX()+m:getW(), m:getY()-10, 75,m:getH()+20)
								if (debug_mode) then mp_reg:highlight(0.2) end
								mp, retval = numberOCRNoFindException(mp_reg,"mp")
								if (not retval or mp ~= skillmp[i]) then
									mp, retval = numberOCRNoFindException(mp_reg,"gil")
								end
								if (retval and debug_mode) then
									runlog("MP found : "..mp,true,debug.getinfo(1).currentline)
									--mp_reg:save(mp..".png")
								end
								if (retval and mp >= skillmp[i]) then
									icon_reg = Region(m:getX()-20, m:getY()-90, 100,100)
									text_reg = Region(m:getX()-20, m:getY()-90, 290,100)
									if (debug_mode) then icon_reg:highlight(0.2) ; text_reg:highlight(0.2) end
									if (mp > selectionmp and (arena_mode and smartBattle_AbilitiesAvailable(text_reg)) and not smartBattle_isNotAttackIcon(icon_reg) and smartBattle_isAttack(text_reg)) then
										if (((skilluse[i] == "Any AoE Attack") and smartBattle_isAoE(text_reg)) or (skilluse[i] == "Any Attack")) then
											if(debug_mode) then runlog("Select this.", true,debug.getinfo(1).currentline) end
											selection = text_reg:getLastMatch()
											selectionmp = mp
											skillSuccess = true
											break
										elseif (mp > detectMaxMP) then
											detectMaxMP = mp
										end
									end
								elseif (retval) then
									checkValue = checkValue + mp*n
								end
							end --end of for loop

							if (skillSuccess) then
								click(selection)
								wait(0.2+lagx*0.25)
								-- ALWAYS self click to be safe from cure/buff/sing skills etc.
								click(Location(sb_regunit[i]:getX() + sb_regunit[i]:getW()/2, sb_regunit[i]:getY() + (sb_regunit[i]:getH()/2)))
								wait(0.05+lagx*0.05)
								break
							elseif (skillTries > 6 or checkValue == checkValue_last) then
								if (arena_mode and skilluse[i] == "Any AoE Attack") then
									if (skillmp[i] > 16) then
										skillmp[i] = skillmp[i]*0.5
									else
										skilluse[i] = "Any Attack"
										skillmp[i] = detectMaxMP*0.6
									end
									skillTries = 1
									-- Scrolls all the way back up
									dragDrop(Location(sb_reg:getX()+sb_reg:getW()/2 , sb_reg:getY()+25 ) , Location( sb_reg:getX()+sb_reg:getW()/2 , sb_reg:getY()+sb_reg:getH()-33 ) )
									wait(0.2+lagx*0.15)
									dragDrop(Location(sb_reg:getX()+sb_reg:getW()/2 , sb_reg:getY()+25 ) , Location( sb_reg:getX()+sb_reg:getW()/2 , sb_reg:getY()+sb_reg:getH()-33 ) )
									wait(0.2+lagx*0.15)
									dragDrop(Location(sb_reg:getX()+sb_reg:getW()/2 , sb_reg:getY()+25 ) , Location( sb_reg:getX()+sb_reg:getW()/2 , sb_reg:getY()+sb_reg:getH()-33 ) )
									wait(0.2+lagx*0.15)
									dragDrop(Location(sb_reg:getX()+sb_reg:getW()/2 , sb_reg:getY()+25 ) , Location( sb_reg:getX()+sb_reg:getW()/2 , sb_reg:getY()+sb_reg:getH()-33 ) )
									wait(0.2+lagx*0.15)
									dragDrop(Location(sb_reg:getX()+sb_reg:getW()/2 , sb_reg:getY()+25 ) , Location( sb_reg:getX()+sb_reg:getW()/2 , sb_reg:getY()+sb_reg:getH()-33 ) )
									wait(0.2+lagx*0.15)
									dragDrop(Location(sb_reg:getX()+sb_reg:getW()/2 , sb_reg:getY()+25 ) , Location( sb_reg:getX()+sb_reg:getW()/2 , sb_reg:getY()+sb_reg:getH()-33 ) )
									wait(0.2+lagx*0.15)
								else --ie this isn't arena mode where skill equals "Any AoE Attack"
									if (existsClick(BackButton, 0)) then
										wait(0.25+lagx*0.35)
										if (debug_mode) then runlog("Exists Click Back",true,debug.getinfo(1).currentline) end
										break
									end
								end
							else --ie could not find skill but has not scrolled 6 times yet
								if (debug_mode) then runlog("Skill find #"..skillTries.." not successful.",true,debug.getinfo(1).currentline) end
								--Scrolls down a set of skill icons
	--							dragDrop(Location(sb_reg:getX()+sb_reg:getW()/2 , sb_reg:getY()+sb_reg:getH()-33 ) , Location( sb_reg:getX()+sb_reg:getW()/2 , sb_reg:getY()+25 ) )
								dragDrop(Location(sb_reg:getX()+sb_reg:getW()/2 , sb_reg:getY()+sb_reg:getH()-33-51 ) , Location( sb_reg:getX()+sb_reg:getW()/2 , sb_reg:getY()+25+50 ) )
								wait(0.2+lagx*0.15)
								usePreviousSnap(false)
								skillTries = skillTries + 1
							end
							checkValue_last = checkValue
						else --ie no MP icon exists in SB region
							if (debug_mode) then runlog("Skill not found.",true,debug.getinfo(1).currentline) end
	--						dragDrop(Location(sb_reg:getX()+sb_reg:getW()/2,sb_reg:getY()+sb_reg:getH()-33 ), Location(sb_reg:getX()+sb_reg:getW()/2,sb_reg:getY()+25))
							dragDrop(Location(sb_reg:getX()+sb_reg:getW()/2 , sb_reg:getY()+sb_reg:getH()-33-51 ) , Location( sb_reg:getX()+sb_reg:getW()/2 , sb_reg:getY()+25+50 ) )
							wait(0.2+lagx*0.15)
							usePreviousSnap(false)
							skillTries = skillTries + 1
						end
					end --end of while loop looking for Any Attack or Any AoE Attack

				--elseif (not sb_reg:exists(IsReady, lagx*0.75)) then -- no unit is ready, turn is over or team is dead
				--	return false --return false to indicate skill selection did not make it through all units
				end
			--]]

			--Below handles if a specific skill & MP value needs to be searched for
			--elseif (sb_regunit[i]:exists(IsReady,lagx*0.75)) then --Old Version
			elseif (existsIsReady(sb_regunit[i],lagx*0.75)) then
				skillToUse = sb_skills[skilluse[i]]
				skillSuccess = false
				skillTries = 0
				--if (debug_mode) then runlog("Unit #"..i.." action. Skill : "..skilluse[i].." - MP : "..skillmp[i], true, debug.getinfo(1).currentline) end
				setDragDropStepCount(50)
				setDragDropStepInterval(1)
				setDragDropTiming(100,20)
				dragDrop(Location(sb_regunit[i]:getX() + 15, sb_regunit[i]:getY() + (sb_regunit[i]:getH()/2)), Location(sb_regunit[i]:getX() + sb_regunit[i]:getW() - 15, sb_regunit[i]:getY() + (sb_regunit[i]:getH()/2)))
				setDragDropStepCount(145+lagx*75)
				setDragDropStepInterval(1)
				setDragDropTiming(100,400+lagx*50)
				wait(0.2+lagx*0.25)
				while(true) do
					if (skillSuccess) then
						break
					elseif (skillTries > 6) then
						--if (debug_mode) then runlog("Exists Click Back",true,debug.getinfo(1).currentline) end
						if (existsClick(BackButton, 0)) then wait(0.25+lagx*0.35) ; break end

					--Skill icon we're looking for is present
					elseif (sb_reg:exists(skillToUse, 0)) then
						usePreviousSnap(true)
						findSkills = regionFindAllNoFindException(sb_reg,skillToUse)
						for n, m in ipairs(findSkills) do
							if (debug_mode) then m:highlight(0.2) end
							mp_reg = Region(m:getX(), m:getY()+m:getH()*0.8, 60,55*aRatio)
							--mp_reg = Region(m:getX(), m:getY()+m:getH(),60,55)
							if (debug_mode) then mp_reg:highlight(0.2) end
							mp, retval = numberOCRNoFindException(mp_reg,"mp")
							--if (not retval or mp ~= skillmp[i]) then
							--	mp, retval = numberOCRNoFindException(mp_reg,"gil")
							--end
							if (retval and debug_mode) then
								runlog("MP found : "..mp,true,debug.getinfo(1).currentline)
								--mp_reg:save(mp..".png")
							end
							if (retval and mp == skillmp[i]) then
								click(m)
								skillSuccess = true
							--[[
								if (skilluse[i] == "Resist" or skilluse[i] == "Cheer" or skilluse[i] == "Cure" or skilluse[i] == "Buff" or skilluse[i] == "Sing" or skilluse[i] == "Dance" or skilluse[i] == "Elements" or skilluse[i] == "Cover (Noctis)") then
									wait(0.05+lagx*0.5)
									click(Location(sb_regunit[i]:getX() + sb_regunit[i]:getW()/2, sb_regunit[i]:getY() + (sb_regunit[i]:getH()/2)))
									wait(0.2+lagx*0.25)
								end
							--]]
								wait(0.2+lagx*0.25)
								usePreviousSnap(false)
								-- If a glowing selection option is covering up the unit's ready marker, it'll self-click the unit to cast any AoE team spell
								-- Otherwise, if the unit shows ready but there's a back button, a buff / raise may have been selected.
								-- Will attempt to self-click, but if this doesn't work, it will click the Back button.
								if (not existsIsReady(sb_regunit[i],0) and existsL(BackButton, 0)) then
									click(Location(sb_regunit[i]:getX() + sb_regunit[i]:getW()/2, sb_regunit[i]:getY() + (sb_regunit[i]:getH()/2)))
									wait(0.2+lagx*0.25)
								elseif (existsL(BackButton, 0)) then
									click(Location(sb_regunit[i]:getX() + sb_regunit[i]:getW()/2, sb_regunit[i]:getY() + (sb_regunit[i]:getH()/2)))
									wait(lagx/2)
									while(existsClickL(BackButton, 0)) do wait(lagx/2) end
								end
								wait(0.2+lagx*0.25)
								break
							elseif (retval and (skillmp[i] == mp)) then
								click(m)
								skillSuccess = true
								--[[
                                    if (skilluse[i] == "Resist" or skilluse[i] == "Cheer" or skilluse[i] == "Cure" or skilluse[i] == "Buff" or skilluse[i] == "Sing" or skilluse[i] == "Dance" or skilluse[i] == "Elements" or skilluse[i] == "Cover (Noctis)") then
                                        wait(0.05+lagx*0.5)
                                        click(Location(sb_regunit[i]:getX() + sb_regunit[i]:getW()/2, sb_regunit[i]:getY() + (sb_regunit[i]:getH()/2)))
                                        wait(0.2+lagx*0.25)
                                    end
                                --]]
								wait(0.2+lagx*0.25)
								usePreviousSnap(false)
								-- If a glowing selection option is covering up the unit's ready marker, it'll self-click the unit to cast any AoE team spell
								-- Otherwise, if the unit shows ready but there's a back button, a buff / raise may have been selected.
								-- Will attempt to self-click, but if this doesn't work, it will click the Back button.
								if (not existsIsReady(sb_regunit[i],0) and existsL(BackButton, 0)) then
									click(Location(sb_regunit[i]:getX() + sb_regunit[i]:getW()/2, sb_regunit[i]:getY() + (sb_regunit[i]:getH()/2)))
									wait(0.2+lagx*0.25)
								elseif (existsL(BackButton, 0)) then
									click(Location(sb_regunit[i]:getX() + sb_regunit[i]:getW()/2, sb_regunit[i]:getY() + (sb_regunit[i]:getH()/2)))
									wait(lagx/2)
									while(existsClickL(BackButton, 0)) do wait(lagx/2) end
								end
								wait(0.2+lagx*0.25)
								break
							end
						end

						--Skill found on the screen wasn't the one we were looking for, scrolls onward
						if (not skillSuccess) then
							if (debug_mode) then runlog("Skill find #"..skillTries.." not successful.",true,debug.getinfo(1).currentline) end
							--dragDrop(Location(sb_reg:getX()+sb_reg:getW()/2 , sb_reg:getY()+sb_reg:getH()-33-51 ) , Location( sb_reg:getX()+sb_reg:getW()/2 , sb_reg:getY()+25+50 ) )
							--dragDrop(Location(sb_reg:getX()+sb_reg:getW()/2 , 855*aRatio) , Location( sb_reg:getX()+sb_reg:getW()/2 , 555*aRatio) )
							dragDrop(Location( sb_reg:getX()+sb_reg:getW()/2 , sb_reg:getY()+(sb_reg:getH()*0.865) ) , Location( sb_reg:getX()+sb_reg:getW()/2 , sb_reg:getY() ) )
							wait(0.1+lagx*0.15)
							usePreviousSnap(false)
							skillTries = skillTries + 1
						end

					--Skill we were looking for isn't present, scrolls onward
					else
						if (debug_mode) then runlog("Skill find #"..skillTries.." not successful.",true,debug.getinfo(1).currentline) end
						--dragDrop(Location(sb_reg:getX()+sb_reg:getW()/2 , sb_reg:getY()+sb_reg:getH()-33-51 ) , Location( sb_reg:getX()+sb_reg:getW()/2 , sb_reg:getY()+25+50 ) )
						--dragDrop(Location(sb_reg:getX()+sb_reg:getW()/2 , 855*aRatio) , Location( sb_reg:getX()+sb_reg:getW()/2 , 555*aRatio) )
						dragDrop(Location( sb_reg:getX()+sb_reg:getW()/2 , sb_reg:getY()+(sb_reg:getH()*0.865) ) , Location( sb_reg:getX()+sb_reg:getW()/2 , sb_reg:getY() ) )
						wait(0.1+lagx*0.15)
						usePreviousSnap(false)
						skillTries = skillTries + 1
					end
				end -- end of while loop looking for skills
			end -- end of main if/elseifs unit has a skill to use and is ready
		end
	end --end of for loop iterating through units

	usePreviousSnap(false)
	setDragDropStepCount(50)
	setDragDropStepInterval(1)
	setDragDropTiming(100,20)

	--return true to indicate all units made it through skill selection
	--return true
end

-- New function smart battle will select skills for companions.
-- Needs to have regions defined first
-- Just select based on minimum MP. Finds first skill with more than x MP. Then check if it's a Raise or not damage.

-- 9/3: NonceCents: I've made this a general function for all auto-skill selection, and disabled the auto-skill-selection parts of smartBattle_choose
-- Note that this function differs from smartBattle_choose in that it takes a single value and operates on a single unit
function smartBattle_auto(skilluse,skillmp, unit)
	local selection = nil
	local selectionmp = 0
	local checkValue = 0				-- add all MPs found in a formula and if it's the same then quit (we reached the end of the skill list)
	local checkValue_last = 12345
	local retval = false
	local mp = 0
	local i = unit

	while(sb_reg == nil) do
		defineSBreg()
	end

	-- NonceCents: Expanded this function to handle all automatic skill selection; companion state check no longer necessary
	--if (companion_used == false) then return true end

	if (debug_mode) then sb_regunit[i]:highlight(0.2) end
	
	usePreviousSnap(false)
	--if (sb_regunit[i]:exists(IsReady,lagx*0.75)) then --Old Version
	if (existsIsReady(sb_regunit[i],lagx*0.75)) then
		skillSuccess = false
		skillTries = 0
		if (debug_mode) then runlog("Unit #"..i.." action. MP : "..skillmp, true,debug.getinfo(1).currentline) end
		setDragDropStepCount(50)
		setDragDropStepInterval(1)
		setDragDropTiming(100,20)
		dragDrop(Location(sb_regunit[i]:getX() + 15, sb_regunit[i]:getY() + (sb_regunit[i]:getH()/2)), Location(sb_regunit[i]:getX() + sb_regunit[i]:getW() - 15, sb_regunit[i]:getY() + (sb_regunit[i]:getH()/2)))
		usePreviousSnap(false)
		setDragDropStepCount(145+lagx*75)
		setDragDropStepInterval(1)
		setDragDropTiming(100,400+lagx*50)
		wait(0.2+lagx*0.25)
		while(true) do
			if (skillSuccess) then
				break
			elseif (sb_reg:exists(SB_MP, 0)) then
				usePreviousSnap(true)
				checkValue = 0
				findSkills = regionFindAllNoFindException(sb_reg,SB_MP)
				for n, m in ipairs(findSkills) do
					if (debug_mode) then m:highlight(0.2) end
					mp_reg = Region(m:getX()+m:getW(), m:getY()-10, 75,m:getH()+20)
					if (debug_mode) then mp_reg:highlight(0.2) end								
					mp, retval = numberOCRNoFindException(mp_reg,"mp")
					if (not retval) then 
						mp, retval = numberOCRNoFindException(mp_reg,"gil")
					end
					if (retval and debug_mode) then 
						runlog("MP found : "..mp,true)
						--mp_reg:save(mp..".png")
					end
					if (retval and mp ~= nil and mp >= skillmp) then
						icon_reg = Region(m:getX()-20, m:getY()-90, 100,100)
						text_reg = Region(m:getX()-20, m:getY()-90, 290,100)
						if (debug_mode) then icon_reg:highlight(0.2) ; text_reg:highlight(0.2) end														
						if (icon_reg:exists(SB_Raise,0)) then                    -- Skills to NEVER use, i.e Raise type.
							if (debug_mode) then runlog("Exists Raise",true) end														
						elseif (not smartBattle_isNotAttackIcon(icon_reg)) then
							for t=1,#SB_Damage do

								if(text_reg:exists(SB_Damage[t],0) and mp > selectionmp) then 
									if (skilluse == "Any Attack") then
										if(debug_mode) then runlog("Any Damage - Select this.", true) end
										selection = text_reg:getLastMatch()
										selectionmp = mp
										skillSuccess = true
										break
									elseif(skilluse == "Any AoE Attack" and smartBattle_isAoE(text_reg)) then
										if(debug_mode) then runlog("Area Damage - Select this.", true) end
										selection = text_reg:getLastMatch()
										selectionmp = mp
										skillSuccess = true
									elseif(skilluse == "Any Single-Target Attack" and not smartBattle_isAoE(text_reg)) then
										if(debug_mode) then runlog("Single Target Damage - Select this.", true) end
										selection = text_reg:getLastMatch()
										selectionmp = mp
										skillSuccess = true
									end
								end
							end
						end
					elseif (retval) then
						checkValue = checkValue + mp*n
					end					
				end

				if (skillSuccess) then 
					click(selection)
					--[[
                        if (skilluse[i] == "Resist" or skilluse[i] == "Cheer" or skilluse[i] == "Cure" or skilluse[i] == "Buff" or skilluse[i] == "Sing" or skilluse[i] == "Dance" or skilluse[i] == "Elements" or skilluse[i] == "Cover (Noctis)") then
                            wait(0.05+lagx*0.5)
                            click(Location(sb_regunit[i]:getX() + sb_regunit[i]:getW()/2, sb_regunit[i]:getY() + (sb_regunit[i]:getH()/2)))
                            wait(0.2+lagx*0.25)
                        end
                    --]]
					wait(0.2+lagx*0.25)
					usePreviousSnap(false)
					-- If a glowing selection option is covering up the unit's ready marker, it'll self-click the unit to cast any AoE team spell
					-- Otherwise, if the unit shows ready but there's a back button, a buff / raise may have been selected.
					-- Will attempt to self-click, but if this doesn't work, it will click the Back button.
					if (not existsIsReady(sb_regunit[i],0) and existsL(BackButton, 0)) then
						click(Location(sb_regunit[i]:getX() + sb_regunit[i]:getW()/2, sb_regunit[i]:getY() + (sb_regunit[i]:getH()/2)))
						wait(0.2+lagx*0.25)
					elseif (existsL(BackButton, 0)) then
						click(Location(sb_regunit[i]:getX() + sb_regunit[i]:getW()/2, sb_regunit[i]:getY() + (sb_regunit[i]:getH()/2)))
						wait(lagx/2)
						while(existsClickL(BackButton, 0)) do wait(lagx/2) end
					end
					wait(0.2+lagx*0.25)
					break 
				elseif (skillTries > 6 or checkValue == checkValue_last) then
					if (debug_mode) then runlog("Exists Click Back",true,debug.getinfo(1).currentline) end
					wait(0.05+lagx*0.05)
					if (existsClick(BackButton, 0)) then wait(0.25+lagx*0.35) ; break end 
				else
					if (debug_mode) then runlog("Found not successful.",true,debug.getinfo(1).currentline) end
					--dragDrop(Location(sb_reg:getX()+sb_reg:getW()/2 , sb_reg:getY()+sb_reg:getH()-33-51 ) , Location( sb_reg:getX()+sb_reg:getW()/2 , sb_reg:getY()+25+50 ) )
					--dragDrop(Location(sb_reg:getX()+sb_reg:getW()/2 , 855*aRatio) , Location( sb_reg:getX()+sb_reg:getW()/2 , 555*aRatio) )
					dragDrop(Location( sb_reg:getX()+sb_reg:getW()/2 , sb_reg:getY()+(sb_reg:getH()*0.865) ) , Location( sb_reg:getX()+sb_reg:getW()/2 , sb_reg:getY() ) )
					wait(0.1+lagx*0.15)
					usePreviousSnap(false)
					skillTries = skillTries + 1
				end				
				checkValue_last = checkValue
			else
				if (debug_mode) then runlog("Not found.",true,debug.getinfo(1).currentline) end
				--dragDrop(Location(sb_reg:getX()+sb_reg:getW()/2 , sb_reg:getY()+sb_reg:getH()-33-51 ) , Location( sb_reg:getX()+sb_reg:getW()/2 , sb_reg:getY()+25+50 ) )
				--dragDrop(Location(sb_reg:getX()+sb_reg:getW()/2 , 855*aRatio) , Location( sb_reg:getX()+sb_reg:getW()/2 , 555*aRatio) )
				dragDrop(Location( sb_reg:getX()+sb_reg:getW()/2 , sb_reg:getY()+(sb_reg:getH()*0.865) ) , Location( sb_reg:getX()+sb_reg:getW()/2 , sb_reg:getY() ) )
				wait(0.1+lagx*0.15)
				usePreviousSnap(false)
				skillTries = skillTries + 1
			end
		end
	--elseif (not sb_reg:exists(IsReady,lagx*0.75)) then --Old Version
	elseif (not existsIsReady(sb_reg,lagx*0.75)) then
		return false
	end

	usePreviousSnap(false)
	setDragDropStepCount(50)
	setDragDropStepInterval(1)
	setDragDropTiming(100,20)

	return true 
end

--By NonceCents, quick little helper function to make sure the center of the first region passed to the function is within the boundaries of the second region passed to the function.
--Returns True or False
--Currently only used below in defineSBreg()
function centerIsWithin(insideregion,outsideregion)
	local insideCenterX = insideregion:getX() + insideregion:getW()/2
	local insideCenterY = insideregion:getY() + insideregion:getH()/2
	local outsideMaxX = outsideregion:getX() + outsideregion:getW()
	local outsideMaxY = outsideregion:getY() + outsideregion:getH()

	if ( ( ( insideCenterX > outsideregion:getX() ) and ( insideCenterX < outsideMaxX ) ) and ( ( insideCenterY > outsideregion:getY() ) and ( insideCenterY < outsideMaxY ) ) ) then
		return true
	else
		return false
	end
end

-- Define Regions first

function defineSBreg()

	--local rX = 99999
	--local rY = 99999
	--local rX2 = 0
	--local rY2 = 0
	local foundLeftUnits = 0
	local foundRightUnits = 0
	local findLeftUnit = {}
	local findRightUnit = {}
	local upperBound
	local lowerBound

	usePreviousSnap(false)

	if (existsClickL(BackButton, 0)) then wait(lagx/2) end

	--if (bottom_reg:exists(IsReady,lagx/3)) then --Old version
	if (existsIsReady(bottom_reg,lagx/3)) then

		--Attempts to define the smartbattle region by using the bottom of the healthbar base and the top of one of the bottom buttons as boundaries
		if (existsL(healthbar, 0)) then upperBound = getLastMatch():getY()+getLastMatch():getH() end
		if (existsL(autobtn, 0) or existsL(menuinbattle, 0) or existsL(autoonbtn, 0) or existsL(repeatbtn, 0)) then lowerBound = getLastMatch():getY()-20 end

		--If the boundaries were found, sets sb_reg accordingly.
		if (upperBound ~= nil and lowerBound ~= nil) then
			sb_reg = Region(0,upperBound,600,(lowerBound-upperBound))

		--If not, then it uses a hard-coded value with an aspect-ratio adjustment that should work at most resolutions
		else
			sb_reg = Region(0,550*aRatio,600,350*aRatio)
		end

		if (debug_mode) then sb_reg:highlight(1) end

		-- Defines the areas where the units "should" be.
		-- Ready units that are actually found are compared against these to find out which number/position they are.
		unitreg[1] = Region(sb_reg:getX(), sb_reg:getY(), sb_reg:getW()/2, sb_reg:getH()/3)
		unitreg[2] = Region(sb_reg:getX(), sb_reg:getY()+sb_reg:getH()/3, sb_reg:getW()/2, sb_reg:getH()/3)
		unitreg[3] = Region(sb_reg:getX(), sb_reg:getY()+sb_reg:getH()*2/3, sb_reg:getW()/2, sb_reg:getH()/3)
		unitreg[4] = Region(sb_reg:getW()/2, sb_reg:getY(), sb_reg:getW()/2, sb_reg:getH()/3)
		unitreg[5] = Region(sb_reg:getW()/2, sb_reg:getY()+sb_reg:getH()/3, sb_reg:getW()/2, sb_reg:getH()/3)
		unitreg[6] = Region(sb_reg:getW()/2, sb_reg:getY()+sb_reg:getH()*2/3, sb_reg:getW()/2, sb_reg:getH()/3)

		if (debug_mode) then
			for i=1, 6 do unitreg[i]:highlight(1) end
		end

		usePreviousSnap(true)

		-- Iterates through each pattern in the set of IsReady images to see if any units are ready
		for p=1, #IsReady do
			if (debug_mode) then left_reg:highlight(0.2) end
			findLeftUnit[p] = regionFindAllNoFindException(left_reg,IsReady[p])

			for i,u in ipairs(findLeftUnit[p]) do
				--sb_regunit[i+foundUnit] = Region(u:getX()-10,u:getY()-10,295,115) -- Old method assumed no dead units and would number first unit found as 1, etc

				--New code by NonceCents; checks to see if found region's center is within a known unit region, and associates it accordingly
				--This will require additional testing at other resolutions
				for n=1, 3 do
					if (sb_regunit[n] ~= nil) then
					elseif (centerIsWithin(Region(u:getX()-5,u:getY()-5,295,115*aRatio),unitreg[n])) then
						sb_regunit[n] = Region(u:getX()-5,u:getY()-5,295,115*aRatio)
						foundLeftUnits = foundLeftUnits + 1
						if (debug_mode) then
							u:highlight(0.2)
							runlog("Unit #"..n.." Match "..p.." :"..u:getScore(), true)
							--u:save("Unit"..n.."Match"..p..".png")
						end
						if (debug_mode or farmloc == "chain_helper") then sb_regunit[n]:highlight(0.2) end
					end
				end

				-- Old Code that determined sb_reg boundaries. Leaving here in case it proves useful in the future.
				--if (rX > u:getX()) then rX = u:getX() end
				--if (rY > u:getY()) then rY = u:getY() end
				--if (rX2 < (u:getX() + u:getW())) then rX2 = u:getX()+u:getW() end
				--if (rY2 < (u:getY() + u:getH())) then rY2 = u:getY()+u:getH() end

			end
			if (foundLeftUnits == 3) then break end
		end

		-- Iterates through each pattern in the set of IsReady images to see if any units are ready
		for p=1, #IsReady do
			if (debug_mode) then right_reg:highlight(0.2) end
			findRightUnit[p] = regionFindAllNoFindException(right_reg,IsReady[p])

			for i,u in ipairs(findRightUnit[p]) do
				--sb_regunit[i+foundUnit] = Region(u:getX()-10,u:getY()-10,295,115) -- Old method assumed no dead units and would number first unit found as 1, etc

				--New code by NonceCents; checks to see if found region's center is within a known unit region, and associates it accordingly
				--This will require additional testing at other resolutions
				for n=4, 6 do
					if (sb_regunit[n] ~= nil) then
					elseif (centerIsWithin(Region(u:getX()-5,u:getY()-5,295,115*aRatio),unitreg[n])) then
						sb_regunit[n] = Region(u:getX()-5,u:getY()-5,295,115*aRatio)
						foundRightUnits = foundRightUnits + 1
						if (debug_mode) then
							u:highlight(0.2)
							runlog("Unit #"..(n).." Match "..p.." :"..u:getScore(), true)
							--u:save("Unit"..n.."Match"..p..".png")
						end
						if (debug_mode or farmloc == "chain_helper") then sb_regunit[n]:highlight(0.2) end
						if (n == 6) then companion_used = true end
					end
				end

				-- Old Code that determined sb_reg boundaries. Leaving here in case it proves useful in the future.
				--if (rX > u:getX()) then rX = u:getX() end
				--if (rY > u:getY()) then rY = u:getY() end
				--if (rX2 < (u:getX() + u:getW())) then rX2 = u:getX()+u:getW() end
				--if (rY2 < (u:getY() + u:getH())) then rY2 = u:getY()+u:getH() end

			end
			if (foundRightUnits == 3 or (foundRightUnits == 2 and not companion_used)) then break end
		end

		sb_regunit_num = foundLeftUnits + foundRightUnits
		--sb_reg = Region(rX, rY, rX2-rX+263, rY2-rY+(103)) -- NonceCents: Old method that built unit region by finding max and min X values from found units
		-- Unfortunately it doesn't work right when the function scans a party that is incomplete or already has units that are not ready / KO

	end
	usePreviousSnap(false)
end

-- Main smartBattle function
function smartBattle()
	local findUnit = nil
	local findSkills = nil
	local skillToUse = nil
	local mp = 0
	local mp_reg = nil
	local retval = false
	local skillSuccess = false
	local skillTries = 0
	local state = 0
	local round = 0
	local boss_found = false
	local boss_battle_check_delay = 0
	local iterations = 0

	while(sb_reg == nil) do
		defineSBreg()
	end

	while(true) do
		iterations = iterations + 1
		usePreviousSnap(false)
		if (existsL(boss,0.25+lagx*0.25+boss_battle_check_delay)) then boss_found = true end
		while (boss_battle_check_delay > 0 and not boss_found) do
			usePreviousSnap(false)
			if (existsL(boss,0.25+lagx*0.25+boss_battle_check_delay)) then boss_found = true end
			usePreviousSnap(true)
			--if(sb_reg:exists(IsReady,0)) then boss_battle_check_delay = 0 end --Old version
			if(existsIsReady(sb_reg,0)) then boss_battle_check_delay = 0 end
		end

		usePreviousSnap(true)
		if(existsL(revive,0)) then break end
		if(iterations%7 == 0) then existsClickL(text_continue,0) end
		if(not existsL(menuinbattle,0)) then break end
		--if(sb_reg:exists(IsReady,0)) then --Old version
		if(existsIsReady(sb_reg,0)) then
			usePreviousSnap(false)
			if(state == 0) then		-- 0-9 are states for first smart battle handling
				wait(0.1)
				smartBattle_choose(sb_skilluse, sb_skillmp)
				wait(0.05+lagx*0.05)
				if(use_smart_battle_companion) then
					smartBattle_auto(use_smart_battle_companion_damage,use_smart_battle_companion_mp,6)
					wait(0.2+lagx*0.25)
				end
				if (use_smart_battle_custom_cast_times) then 
					skillCast(sb_skillcast)
				else
					endTurn("autobtn")
				end
				state = 9
				round = 1
			elseif(state == 9) then
				usePreviousSnap(true)
				if(use_smart_battle_boss and (boss_found)) then
					state = 20
				elseif(use_smart_battle_2nd and round >= use_smart_battle_2nd_round) then
					state = 10
				else
					if (use_smart_battle_custom_cast_times) then
						wait(0.1)
						smartBattle_choose(sb_skilluse, sb_skillmp)
						wait(0.05+lagx*0.05)
						if(use_smart_battle_companion) then
							smartBattle_auto(use_smart_battle_companion_damage,use_smart_battle_companion_mp,6)
							wait(0.2+lagx*0.25)
						end
						skillCast(sb_skillcast)
					else
						endTurn("repeatbtn")
					end
					round = round + 1
				end

			elseif(state == 10) then									-- 10-19 for 2nd smart battle
				wait(0.1)
				smartBattle_choose(sb_skilluse2, sb_skillmp2)
				wait(0.05+lagx*0.05)
				if(use_smart_battle_companion_2nd) then
					smartBattle_auto(use_smart_battle_companion_2nd_damage,use_smart_battle_companion_2nd_mp,6)
					wait(0.2+lagx*0.25)
				end
				if (use_smart_battle_custom_cast_times) then 
					skillCast(sb_skillcast2)
				else
					endTurn("autobtn")
				end
				state = 19
				round = round + 1

			elseif(state == 19) then				
				usePreviousSnap(true)
				if(use_smart_battle_boss and boss_found) then
					state = 20
				else
					if (use_smart_battle_custom_cast_times) then
						wait(0.1)
						smartBattle_choose(sb_skilluse2, sb_skillmp2)
						wait(0.05+lagx*0.05)
						if(use_smart_battle_companion_2nd) then
							smartBattle_auto(use_smart_battle_companion_2nd_damage,use_smart_battle_companion_2nd_mp,6)
							wait(0.2+lagx*0.25)
						end
						skillCast(sb_skillcast2)
					else
						endTurn("repeatbtn")
					end
					round = round + 1
				end

			-- state for handling boss battle
			elseif(state == 20) then
				wait(0.1)
				smartBattle_choose(sb_skilluse_boss, sb_skillmp_boss)
				wait(0.05+lagx*0.05)
				if(use_smart_battle_boss_companion) then
					smartBattle_auto(use_smart_battle_boss_companion_damage,use_smart_battle_boss_companion_mp,6)
					wait(0.2+lagx*0.25)
				end
				if (use_smart_battle_custom_cast_times) then 
					skillCast(sb_skillcast_boss)
				else
					endTurn("autobtn")
				end
				wait(0.15+lagx*0.15)
				round = round + 1		
				if (use_smart_battle_boss_2nd) then
					state = 21
				else
					state = 29
				end
				boss_found = false
			elseif(state == 21) then
				wait(0.1)
				smartBattle_choose(sb_skilluse_boss2, sb_skillmp_boss2)
				wait(0.05+lagx*0.05)
				if(use_smart_battle_boss_companion_2nd) then
					smartBattle_auto(use_smart_battle_boss_companion_2nd_damage,use_smart_battle_boss_companion_2nd_mp,6)
					wait(0.2+lagx*0.25)
				end
				if (use_smart_battle_custom_cast_times) then 
					skillCast(sb_skillcast_boss2)
				else
					endTurn("autobtn")
				end
				wait(0.15+lagx*0.15)
				state = 29
				round = round + 1		
			elseif(state == 29) then				
				usePreviousSnap(true)

				if (use_smart_battle_custom_cast_times and use_smart_battle_boss_2nd) then
					wait(0.1)
					smartBattle_choose(sb_skilluse_boss2, sb_skillmp_boss2)
					wait(0.05+lagx*0.05)
					if(use_smart_battle_boss_companion_2nd) then
						smartBattle_auto(use_smart_battle_boss_companion_2nd_damage,use_smart_battle_boss_companion_2nd_mp,6)
						wait(0.2+lagx*0.25)
					end
					skillCast(sb_skillcast_boss2)
				elseif (use_smart_battle_custom_cast_times and not use_smart_battle_boss_2nd) then
					wait(0.1)
					smartBattle_choose(sb_skilluse_boss, sb_skillmp_boss)
					wait(0.05+lagx*0.05)
					if(use_smart_battle_boss_companion) then
						smartBattle_auto(use_smart_battle_boss_companion_damage,use_smart_battle_boss_companion_mp,6)
						wait(0.2+lagx*0.25)
					end
					skillCast(sb_skillcast_boss)
				else
					endTurn("repeatbtn")
				end
				round = round + 1
			end
		elseif (existsL(battle_transition,0)) then
			boss_battle_check_delay = 0.65 + lagx*0.65
		else
			boss_battle_check_delay = 0
		end
	end
end


-- Arena Battle

function smartBattle_arena()
	local findUnit = nil
	local findSkills = nil
	local skillToUse = nil
	local mp = 0
	local mp_reg = nil
	local retval = false
	local skillSuccess = false
	local skillTries = 0
	local state = 0
	local round = 0
	local iterations = 0
	local enemy_first = false



	usePreviousSnap(false)

	--handles optionally using separate set of skills if enemy strikes first
	if (use_arena_enemyfirst_battle and existsL(arena_enemyfirst,lagx*5)) then enemy_first = true end

	while(true) do
		iterations = iterations + 1
		usePreviousSnap(false)
		if(not existsL(menuinbattle,0)) then break end
		usePreviousSnap(true)
		if(existsL(arena_lost,0)) then break end
		if(existsL(arena_won,0)) then break end
		usePreviousSnap(false)

		while(sb_reg == nil) do
			defineSBreg()
		end

		--if(exists(IsReady,0) and #sb_regunit > 0) then --Old Version
		if(existsIsReady(sb_reg,0)) then
			usePreviousSnap(false)
			if(state == 0) then -- 0-9 are states for first arena battle handling
				wait(0.1)
				if (arena_mode) then
					for i, r in pairs(sb_regunit) do
						smartBattle_auto(arena_autoskilluse,arena_autoskillmp,i)
						wait(0.2+lagx*0.25)
					end
					state = 99
				elseif (enemy_first) then
					if (use_arena_enemyfirst_battle) then
						smartBattle_choose(arena_skilluse_enemy, arena_skillmp_enemy) --will select custom skill selection for enemy first strike
					end
					state = 0
					enemy_first = false
					sb_reg = nil --Forces sb_reg to be redefined next turn in case any friendly units have recovered
				else
					smartBattle_choose(arena_skilluse, arena_skillmp)
					state = 99
				end
--				state = 1
				endTurn("autobtn")

			-- This state is currently disabled; single-target attacks are pretty worthless in Arena.
			elseif(state == 1) then
				wait(0.1)
				if (arena_mode) then
					arena_autoskilluse = "Any Attack"
					arena_autoskillmp = math.random(10,24)
					for i, r in pairs(sb_regunit) do
						smartBattle_auto(arena_autoskilluse,arena_autoskillmp,i)
						wait(0.2+lagx*0.25)
					end
				else
					smartBattle_choose(arena_skilluse, arena_skillmp)
				end
				state = 99
				endTurn("autobtn")

			--Later states just press Repeat
			elseif(state == 99) then
				usePreviousSnap(true)
				round = round + 1
				endTurn("repeatbtn")
			end
		end
	end
end

-- Help screen

function helpscreen()
	dialogInit()
	addTextView("Welcome to ffbeAuto Z Help Screen")
	if (ALver >= "6.8.0") then
		addSeparator()
		addSeparator()
	else
		newRow()
		newRow()
	end
	addTextView("First thing first, turn off any Superuser toast messages in your superuser app.")	
	newRow()
	addTextView("If you're using a device, make sure the screen stays awake. This can be done via developer options or other methods.")	
	newRow()
	addTextView("Please reposition the play button somewhere safe, like in the upper leftmost region of the screen.")	
	newRow()
	addTextView("Always start from quest selection screen.")	
	newRow()
	addTextView("Use a reasonable Device Lag Multiplier, minimum 1.0 for high end devices, adjust with device performance.")	
	newRow()
	addTextView("Please note that emulators needs a higher Lag Multiplier due to the inherent choppiness to be safe.")	
	if (ALver >= "6.8.0") then
		addSeparator()
		addSeparator()
	else
		newRow()
		newRow()
	end
	addTextView("Thank you and enjoy.")	
	newRow()
	newRow()	
	addCheckBox("custom_help_screen", "Show custom battle help?", false)
	dialogShow("Help")
	
	if (custom_help_screen) then
		dialogInit()
		addTextView("Welcome to ffbeAuto Z Custom Battle Help Screen")
		if (ALver >= "6.8.0") then
			addSeparator()
			addSeparator()
		else
			newRow()
			newRow()
		end
		addTextView("Custom Battle is divided into four main action sets : ")	
		newRow()
		addTextView("The first actions are to be performed at dungeon start.")	
		newRow()
		addTextView("The second actions are performed after adjustable rounds in dungeons if there isn't a boss. Boss actions take precedence over this.")	
		newRow()
		addTextView("The first boss actions are performed at the start of a boss. Can optionally try to perform an attack action for companion unit as well.")	
		newRow()
		addTextView("The second boss actions are performed after the first. Also able to perform companion action.")	
		newRow()
		newRow()
		addTextView("After those actions the script will always press repeat and nothing else.")	
		newRow()
		newRow()
		addTextView("The skill chosen is a combination of ICON and MP. You choose an Icon and MP for the script to find.")	
		newRow()
		if (ALver >= "6.8.0") then
			addSeparator()
			addSeparator()
		else
			newRow()
			newRow()
		end
		newRow()
		newRow()
		addCheckBox("skill_help_screen", "Show the list of custom skills?", false)
		dialogShow("Custom Battle Help")
	end

	if (skill_help_screen) then
		dialogInit()
		addTextView("Welcome to ffbeAuto Z Custom Battle Skill Screen")
		if (ALver >= "6.8.0") then
			addSeparator()
			addSeparator()
		else
			newRow()
			newRow()
		end
		addTextView("None (Default) : Autoattack (or limit if it's filled and you have it enabled in game options)")	
		newRow()
		addTextView("Fire, Blizzard, Thunder, Stone, Water, Aero, Holy, Dark, Poison, Drain, Ultima, Meteor, and Cure are icons based on their respective magics")	
		newRow()
		addTextView("Katana icon is for skills such as Mirror of Equity, Barrage, and Tri-Attack.")	
		newRow()
		addTextView("Sword icon is for skills such as Full Break, Undermine, and Divine Ruination.")	
		newRow()
		addTextView("Blast icon is for skills such as Area Blast, Hyperdrive, Hit All, and Red Card.")	
		newRow()
		addTextView("Shot icon is for skills such as True Shot, Burst Shot, Blazing Glory.")	
		newRow()
		addTextView("Buff icon is for skills such as Focus, Protect, and Shell.")	
		newRow()
		addTextView("Cheer icon is for skills such as Cheer and Embolden.")	
		newRow()
		addTextView("Kick icon is for skills such as, well, Kick. And also Raging Fist of course, but it's still a kick.")	
		newRow()
		addTextView("Provoke icon is for those living in the face of enemies taunting them. Of course it's for Provoke.")	
		newRow()
		addTextView("Dance is for all dance skills and Sing is for singing (duh!).")	
		newRow()
		addTextView("Elements is for skills such as Maduin Guard and Omni-Veil.")	
		newRow()
		addTextView("Status is for skills such as Trine and Binding Cold.")	
		newRow()
		addTextView("Rapid Fire is for skills such as King's Rapid Fire")	
		newRow()
		addTextView("Critical is for skills such as Finisher")	
		newRow()
		addTextView("Cover (Noctis) is self-explanatory, as well as Alterna.")	
		newRow()
		if (ALver >= "6.8.0") then
			addSeparator()
			addSeparator()
		else
			newRow()
			newRow()
		end
		newRow()
		newRow()
		dialogShow("Custom Battle Skills")
	end

end

-- Custom Battle Menu
-- NOTE THAT skilltable and mptable ARE strings. 'cause addSpinner only accept strings.
-- AnkuLua remembers unique spinner variables between sessions, and token is used to differentiate them.

function cbattlemenu(skilltable, mptable, casttable, titletype, token)

	skillsList = {}

	for i,v in ipairs(sb_autoskills) do
		skillsList[#skillsList+1] = v
	end

	for i,v in pairsByKeys(sb_skills) do
		skillsList[#skillsList+1] = i
	end

	dialogInit()
	addTextView(" Set unit skill icons and MP usage below : ")
	newRow()
	addTextView(" \"Any\"-type ability selection will use the minimum MP specified.")
	newRow()
	addTextView(" Explicitly-defined abilities will match the MP specified.")
	newRow()
	if (ALver >= "6.8.0") then
		newRow()
		addSeparator()
		newRow()
	else
		newRow()
		newRow()
		newRow()
	end
	addTextView(" Battle Actions : ")
	newRow()
	newRow()
	addTextView(" Unit 1 :")
	addSpinner("skill1"..token,skillsList,"None")
	addTextView("MP :")
	addEditNumber("mp1"..token,0)
	if (use_smart_battle_custom_cast_times) then 
		addTextView("\tCast Frame Delay: ")
		addEditNumber("cast1"..token,0)
	else
		addTextView("\tUsing Auto & Repeat")
	end
	newRow()
	addTextView(" Unit 2 :")
	addSpinner("skill2"..token,skillsList,"None")
	addTextView("MP :")
	addEditNumber("mp2"..token,0)
	if (use_smart_battle_custom_cast_times) then 
		addTextView("\tCast Frame Delay: ")
		addEditNumber("cast2"..token,0)
	else
		addTextView("\tUsing Auto & Repeat")
	end
	newRow()
	addTextView(" Unit 3 :")
	addSpinner("skill3"..token,skillsList,"None")
	addTextView("MP :")
	addEditNumber("mp3"..token,0)
	if (use_smart_battle_custom_cast_times) then 
		addTextView("\tCast Frame Delay: ")
		addEditNumber("cast3"..token,0)
	else
		addTextView("\tUsing Auto & Repeat")
	end
	newRow()
	addTextView(" Unit 4 :")
	addSpinner("skill4"..token,skillsList,"None")
	addTextView("MP :")
	addEditNumber("mp4"..token,0)
	if (use_smart_battle_custom_cast_times) then 
		addTextView("\tCast Frame Delay: ")
		addEditNumber("cast4"..token,0)
	else
		addTextView("\tUsing Auto & Repeat")
	end
	newRow()
	addTextView(" Unit 5 :")
	addSpinner("skill5"..token,skillsList,"None")
	addTextView("MP :")
	addEditNumber("mp5"..token,0)
	if (use_smart_battle_custom_cast_times) then 
		addTextView("\tCast Frame Delay: ")
		addEditNumber("cast5"..token,0)
	else
		addTextView("\tUsing Auto & Repeat")
	end
	if(use_smart_battle_companion and token == "a") then
		newRow()
		addTextView(" Companion :")
		addSpinner("use_smart_battle_companion_damage", damage_methods, damage_methods[2])
		addTextView("\tMin MP : ")
		addEditNumber("use_smart_battle_companion_mp",10)
		if (use_smart_battle_custom_cast_times) then
			addTextView("\tCast Frame Delay: ")
			addEditNumber("cast6"..token,0)
		else
			addTextView("\tUsing Auto & Repeat")
		end
	elseif(use_smart_battle_companion_2nd and token == "b") then
		newRow()
		addTextView("Companion :")
		addSpinner("use_smart_battle_companion_2nd_damage", damage_methods, damage_methods[2])
		addTextView("\tMin MP : ")
		addEditNumber("use_smart_battle_companion_2nd_mp",10)
		if (use_smart_battle_custom_cast_times) then
			addTextView("\tCast Frame Delay: ")
			addEditNumber("cast6"..token,0)
		else
			addTextView("\tUsing Auto and Repeat.")
		end
	elseif(use_smart_battle_boss_companion and token == "c") then
		newRow()
		addTextView("Companion :")
		addSpinner("use_smart_battle_boss_companion_damage", damage_methods, damage_methods[3])
		addTextView("\tMin MP : ")
		addEditNumber("use_smart_battle_boss_companion_mp",25)
		if (use_smart_battle_custom_cast_times) then
			addTextView("\tCast Frame Delay: ")
			addEditNumber("cast6"..token,0)
		else
			addTextView("\tUsing Auto and Repeat.")
		end
	elseif(use_smart_battle_boss_companion and token == "d") then
		newRow()
		addTextView("Companion :")
		addSpinner("use_smart_battle_boss_companion_2nd_damage", damage_methods, damage_methods[3])
		addTextView("\tMin MP : ")
		addEditNumber("use_smart_battle_boss_companion_2nd_mp",25)
		if (use_smart_battle_custom_cast_times) then
			addTextView("\tCast Frame Delay: ")
			addEditNumber("cast6"..token,0)
		else
			addTextView("\tUsing Auto and Repeat.")
		end
	end

	newRow()
	newRow()
	newRow()
	dialogShow(titletype)
	
	skilltable[1] = _G["skill1"..token]
	skilltable[2] = _G["skill2"..token]
	skilltable[3] = _G["skill3"..token]
	skilltable[4] = _G["skill4"..token]
	skilltable[5] = _G["skill5"..token]
	
	mptable[1] = _G["mp1"..token]
	mptable[2] = _G["mp2"..token]
	mptable[3] = _G["mp3"..token]
	mptable[4] = _G["mp4"..token]
	mptable[5] = _G["mp5"..token]
	
	if (use_smart_battle_custom_cast_times) then 
		casttable[1] = _G["cast1"..token]
		casttable[2] = _G["cast2"..token]
		casttable[3] = _G["cast3"..token]
		casttable[4] = _G["cast4"..token]
		casttable[5] = _G["cast5"..token]
		casttable[6] = _G["cast6"..token]
	end

end

function chainhelpermenu(chaintable)

	local chaintitle
	if (chain_mode == "All Ready Units") then
		while(sb_reg == nil) do
			defineSBreg()
		end
		chaintitle = "Chain Helper - All Ready Units"
	else
		chaintitle = "Chain Helper - Manual Select"
	end


	if (chain_mode == "All Ready Units") then
		dialogInit()
		addTextView("Ready units were discovered and tap regions defined.")
		newRow()
		addTextView("")
		newRow()
		addTextView("Input desired frame times: ")
		newRow()
		addTextView("")
		newRow()
		for u=1, 6 do
			if (sb_regunit[u] == nil) then
				addTextView("\tUnit "..u.." Not ready.")
				newRow()
				addTextView("")
				newRow()
			else
				addTextView("\tUnit "..u.." Ability Frame Delay: ")
				addEditNumber("chain"..u,0)
				newRow()
				addTextView("")
				newRow()
			end
		end
	else
		dialogInit()
		addTextView("To maximize speed, unit ready status has been ignored and tap regions statically defined.")
		newRow()
		addTextView("Please report any issues experienced in this mode.")
		addTextView("")
		newRow()
		addTextView("Select Enable for units you want to have tapped and input desired frame times: ")
		newRow()
		addTextView("")
		newRow()
		for u=1, 6 do
			addCheckBox("enablechain"..u, "Enable: ", false)
			addTextView("\tUnit "..u.." Ability Frame Delay: ")
			addEditNumber("chain"..u,0)
			newRow()
			addTextView("")
			newRow()
		end
	end


	--[[
	addTextView("\tUnit 2 Ability Frame Delay: ")
	addEditNumber("chain2",0)
	newRow()
	addTextView("")
	newRow()
	addTextView("\tUnit 3 Ability Frame Delay: ")
	addEditNumber("chain3",0)
	newRow()
	addTextView("")
	newRow()
	addTextView("\tUnit 4 Ability Frame Delay: ")
	addEditNumber("chain4",0)
	newRow()
	addTextView("")
	newRow()
	addTextView("\tUnit 5 Ability Frame Delay: ")
	addEditNumber("chain5",0)
	newRow()
	addTextView("")
	newRow()
	addTextView("\tUnit 6 Ability Frame Delay: ")
	addEditNumber("chain6",0)
	newRow()
	addTextView("")
	newRow()
	--]]
	dialogShow(chaintitle)

	if (chain_mode == "All Ready Units") then
		for n=1, 6 do
			if ("chain"..n ~= nil) then
				chaintable[n] = _G["chain"..n]
			end
		end
	else
		for n=1, 6 do
			if ("chain"..n ~= nil and "enablechain"..n == true) then
				chaintable[n] = _G["chain"..n]
			end
		end
	end

--[[
	chaintable[1] = _G[chaintable[1]
	chaintable[2] = _G[chaintable[2]
	chaintable[3] = _G[chaintable[3]
	chaintable[4] = _G[chaintable[4]
	chaintable[5] = _G[chaintable[5]
	chaintable[6] = _G[chaintable[6]
--]]
	--return chaintable

end

function lapisConfirm()
	dialogInit()
	addTextView("")
	newRow()
	addTextView("YOU ARE AUTHORIZING THE SCRIPT TO REFILL YOUR NRG OR ORBS USING LAPIS.")
	newRow()
    addTextView("")
    newRow()
	addTextView("THIS COULD BE VERY EXPENSIVE IF LEFT UNMONITORED.")
    newRow()
    addTextView("")
    newRow()
	addTextView("YOU ARE DEPARTING TO "..farmloc.." FOR "..max_depart_count.." RUNS.")
	newRow()
	addTextView("")
	newRow()
	addTextView("PROCEED?")
    newRow()
    addTextView("")
    newRow()
	dialogShow(farmloc.." - CONFIRM LAPIS REFILL?")
	newRow()
	addTextView("")
end
------------------------------------------------------------------------------------------------------------
-------------------------------------------- MAIN FUNCTION START -------------------------------------------
------------------------------------------------------------------------------------------------------------

-- Check version of AnkuLua first.
ALver, ALpro = getALVer()

if(ALver >= "6.9.0") then
	setButtonPosition(0,30*aRatio)
else
	toast("Old version of AnkuLua detected.")
end

farmList = {}
chainoptions = {"Manual Select","All Ready Units" }
ratio_options = {"High","Low"}

dialogInit()
addTextView("")
newRow()

-- No longer necessary
--[[
for i,v in pairsByKeys(special_farm) do
	farmList[#farmList+1] = i
end
for i,v in pairsByKeys(farm) do
	farmList[#farmList+1] = i
end
for i,v in pairsByKeys(custom) do
	farmList[#farmList+1] = v
end


--addTextView("Farm location:")
--addSpinner("farmloc",farmList,"earth_shrine_entrance")
--]]

addTextView("Select a function:")
newRow()
addRadioGroup("script_function", 1)
addRadioButton("Arena Battle", 1)

addRadioButton("Dungeon Farm", 2)
addRadioButton("Exploration Farm", 3)
addRadioButton("TMR Farm", 4)
addRadioButton("Chain Helper", 5)
newRow()
addTextView("\t\t")
addSpinner("chain_mode", chainoptions, chainoptions[1])
--addRadioGroup("chain_mode", 1)
--addRadioButton("\tManual", 1)
--addRadioButton("\tAuto", 2)
newRow()
addTextView("")
newRow()
--if (ALver >= "6.8.0") then
--	addSeparator()
--end
newRow()
addTextView("")
newRow()
--addCheckBox("loot", "Find Battle?", false)
addTextView("Device Lag multiplier: ")
addEditNumber("lagx",1.3)
newRow()
if (ALpro) then addCheckBox("dimscreen", "Dim screen?", false) else dimscreen = false end
newRow()
addCheckBox("debug_mode", "Debug mode?", false)
newRow()

--[[
addTextView("Companion mode :")
addRadioGroup("comp_mode", 1)
addRadioButton("Any", 1)
addRadioButton("Use Bonus", 2)
addRadioButton("Highest ATK", 3)
newRow()
addTextView("Battle mode :")
addRadioGroup("battle_mode", 1)
addRadioButton("Just press Auto", 1)
addRadioButton("Just press Repeat", 4)
addRadioButton("Use Espers", 2)
addRadioButton("Custom (Dungeons Only)", 3)
newRow()
--addTextView("Swipe mode")
--addRadioGroup("trace_mode",1)
--addRadioButton("1 (Preferred)",1)
--addRadioButton("2 (Alternative)",2)
--newRow()
--addTextView("Use Click for step:")
--addRadioGroup("step_mode",1)
--addRadioButton("Single (Preferred)",1)
--addRadioButton("Always (Slow)",2)
--newRow()
]]--
--addTextView("Depart count (99999 for infinite) :")
--addEditNumber("max_depart_count",99999)
--newRow()
addCheckBox("help_screen", "Show help?", false)

dialogShow(ver)

if (help_screen) then
	helpscreen()
	scriptExit("Help Finished")
end

--Displays Arena Battle Options
if(script_function == 1) then

	farmloc = "arena"

	dialogInit()
	addTextView("")
	newRow()
	addTextView("This will run from the Arena battle screen where you are prompted to begin Setup.")
	newRow()
	addTextView("")
	newRow()
	addTextView("Find Opponents with ")
	addSpinner("ratio_choice",ratio_options,ratio_options[1])
	addTextView("Ratio.")
	newRow()
	addTextView("")
	newRow()
	addTextView("Battle method:")
	newRow()
	addRadioGroup("battle_mode", 1)
	addRadioButton("Auto-select Skills", 1)
	addRadioButton("Press Repeat", 4)
	addRadioButton("Custom Skill Selection", 3)
	newRow()
	addTextView("\t\t")
	addCheckBox("use_arena_enemyfirst_battle", "Use a different set of skills if the enemy strikes first?", false)
	-- Another wishlist item here; allow an option to pick either a high ratio challenger or low one.
	newRow()
	addTextView("")
	newRow()
	addTextView("Iteration:")
	newRow()
	addCheckBox("refill", "Refill Orbs usng Lapis?", false)
	newRow()
	addCheckBox("halt_on_gameover", "Halt script if a battle is lost?", false)
	newRow()
	addTextView("Depart count (99999 for infinite) :")
	addEditNumber("max_depart_count",99999)
	newRow()
	dialogShow("Arena Battle Options:")

	if(refill) then lapisConfirm() end

	if(battle_mode == 1) then
		dialogInit()
		newRow()
		addTextView("")
		newRow()
		addTextView("AoE Abilities with a minimum of ")
		addEditNumber("arena_autoskillmp",28)
		addTextView(" MP will be selected.")
		--WHEN DUALCAST SUPPORT IS ADDED, OPTION TO SEARCH FOR IT SHOULD BE ADDED HERE
		newRow()
		addTextView("")
		newRow()
		dialogShow("Arena Auto-Battle Min MP")
	end

--Displays Dungeon Farm Options
elseif(script_function == 2) then

	farmList[1] = "dungeon_finder"

	for i,v in pairsByKeys(dungeonfarm) do
		if (i ~= "dungeon_finder") then farmList[#farmList+1] = i end
	end

	dialogInit()
	addTextView("")
	newRow()
	addTextView("This will run from the appropriate battle select screen for the dungeon or raid you wish to farm.")
	newRow()
	addTextView("The dungeon_finder function can locate all dungeons on the screen and allow you to select one.")
	newRow()
	addTextView("")
	newRow()
	addTextView("Select a location to farm: ")
	addSpinner("farmloc",farmList,"dungeon_finder")
	newRow()
	addTextView("")
	newRow()
	addTextView("Battle method:")
	newRow()
	addRadioGroup("battle_mode", 1)
	addRadioButton("Press Auto", 1)
	addRadioButton("Press Repeat", 4)
	addRadioButton("Use Espers", 2)
	addRadioButton("Custom skill selection", 3)
	newRow()
	addTextView("")
	newRow()
	addTextView("Companion mode:")
	newRow()
	addRadioGroup("comp_mode", 1)
	addRadioButton("Any", 1)
	addRadioButton("Use Bonus", 2)
	addRadioButton("Highest ATK", 3)
	newRow()
	addTextView("")
	newRow()
	addTextView("Iteration:")
	newRow()
	addCheckBox("refill", "Refill Energy/Orbs using Lapis?", false)
	newRow()
	addCheckBox("halt_on_gameover", "Halt script if a battle is lost?", false)
	newRow()
	addTextView("Depart count (99999 for infinite) :")
	addEditNumber("max_depart_count",99999)
	newRow()
	dialogShow("Dungeon Farm Options:")

	if(refill) then lapisConfirm() end

--Displays Exploration Farm Options
elseif(script_function == 3) then

	farmList[1] = "free_farm"

	for i,v in pairsByKeys(explorefarm) do
		if (i ~= "free_farm") then farmList[#farmList+1] = i end
	end

	for i,v in pairsByKeys(custom) do
		farmList[#farmList+1] = v
	end

	dialogInit()
	addTextView("")
	newRow()
	addTextView("This will run from the appropriate battle select screen for the exploration you wish to farm.")
	newRow()
	addTextView("Alternatively, the free_farm function can be run at any time from within an exploration you've already started.")
	newRow()
	addTextView("")
	newRow()
	addTextView("Select a location to farm: ")
	addSpinner("farmloc",farmList,"free_farm")
	newRow()
	addTextView("")
	newRow()
	addCheckBox("loot", "Farm unit experience? ", false)
	newRow()
	addTextView("")
	newRow()
	addTextView("Battle method:")
	newRow()
	addRadioGroup("battle_mode", 1)
	addRadioButton("Press Auto", 1)
	addRadioButton("Press Repeat", 4)
	addRadioButton("Use Espers", 2)
	--addRadioButton("Custom skill selection", 3)
	-- This hopefully coming soon!
	newRow()
	addTextView("")
	newRow()
	addTextView("Companion mode:")
	addRadioGroup("comp_mode", 1)
	addRadioButton("Any", 1)
	addRadioButton("Highest ATK", 3)
	--Wishlist item here; add option to add Highest MAG. Fryevia is love, Fryevia is life.
	newRow()
	addTextView("")
	newRow()
	addTextView("Iteration:")
	newRow()
	addCheckBox("refill", "Refill Energy using Lapis?", false)
	newRow()
	addCheckBox("halt_on_gameover", "Halt script if a battle is lost?", false)
	newRow()
	addTextView("Depart count (99999 for infinite) :")
	addEditNumber("max_depart_count",99999)
	newRow()
	dialogShow("Exploration Farm Options:")

	if(refill) then lapisConfirm() end

--Displays TMR Farm Options
elseif(script_function == 4) then

	farmloc = "earth_shrine_entrance_speedmode"

	dialogInit()
	addTextView("")
	newRow()
	addTextView("This will run from the Earth Shrine battle selection screen.")
	newRow()
	addTextView("Place your units with the shortest attack animations in party slots 1 and 3 for best performance.")
	newRow()
	addTextView("")
	newRow()
	battle_mode = 1
	comp_mode = 1
	addTextView("Iteration:")
	newRow()
	addCheckBox("refill", "Refill Energy?", false)
	newRow()
	addCheckBox("halt_on_gameover", "Halt script if a battle is lost?", false)
	newRow()
	addTextView("Depart count (99999 for infinite) :")
	addEditNumber("max_depart_count",99999)
	newRow()
	dialogShow("TMR Farm Options:")

	if(refill) then lapisConfirm() end

elseif(script_function == 5) then

	farmloc = "chain_helper"
	battle_mode = 1
	comp_mode = 1
	max_depart_count = 1
	halt_on_gameover = true
	chainhelpermenu(chain_skillcast)
	skillCast(chain_skillcast)

end

if(farmloc == "dungeon_finder") then selectDungeon() -- get custom dungeon location
elseif(farmloc == "free_farm") then freeFarm() end

if string.match(farmloc, "speedmode") then
elseif (battle_mode == 3 and (string.match(farmloc, "exploration") or string.match(farmloc, "custom_"))) then
	toast("Explorations can't use Custom Battle, reverting to Esper mode")
	battle_mode = 2
elseif (battle_mode == 3 and farmloc == "arena") then
	use_smart_battle = true
	cbattlemenu(arena_skilluse,arena_skillmp,arena_skillcast,"Custom Battle - Arena","arena")
	if(use_arena_enemyfirst_battle) then
		cbattlemenu(arena_skilluse_enemy,arena_skillmp_enemy,arena_skillcast_enemy,"Custom Battle - Arena; Enemy First Strike","arenaenemy")
	end
elseif (battle_mode == 3) then

	use_smart_battle = true

	dialogInit()
	addTextView("")
	addCheckBox("use_smart_battle_custom_cast_times", "Use custom cast times for unit skils?", false)
	newRow()
	addCheckBox("use_smart_battle_companion", "Use damage skills for companions on first turn?", true)
	newRow()
	--[[
	addTextView("\t\t\t\tDamage Method:")
	addSpinner("use_smart_battle_companion_damage", damage_methods, damage_methods[2])
	addTextView("\tMin MP : ")
	addEditNumber("use_smart_battle_companion_mp",10)
	--]]
	newRow()
	newRow()
	addCheckBox("use_smart_battle_2nd", "Use different actions after x rounds below?", true)
	newRow()
	addTextView("\t\tRounds : ")
	addEditNumber("use_smart_battle_2nd_round",3)
	newRow()
	addTextView("\t\t")
	addCheckBox("use_smart_battle_companion_2nd", "Use damage skills for companions on above?", true)
	newRow()
	--[[
	addTextView("\t\t\t\tDamage Method:")
	addSpinner("use_smart_battle_companion_2nd_damage", damage_methods, damage_methods[2])
	addTextView("\tMin MP : ")
	addEditNumber("use_smart_battle_companion_2nd_mp",10)
	--]]
	newRow()
	newRow()
	addCheckBox("use_smart_battle_boss", "Use different actions on BOSS?", true)
	newRow()
	addTextView("\t\t")
	addCheckBox("use_smart_battle_boss_companion", "Use damage skills for companions on above?", true)
	newRow()
	--[[
	addTextView("\t\t\t\tDamage Method:")
	addSpinner("use_smart_battle_boss_companion_damage", damage_methods, damage_methods[3])
	addTextView("\tMin MP : ")
	addEditNumber("use_smart_battle_boss_companion_mp",25)
	--]]
	newRow()
	newRow()
	addCheckBox("use_smart_battle_boss_2nd", "Use different actions on 2nd turn of BOSS?", true)
	newRow()
	addTextView("\t\t")
	addCheckBox("use_smart_battle_boss_companion_2nd", "Use damage skills for companions on above?", true)
	newRow()
	--[[
	addTextView("\t\t\t\tDamage Method:")
	addSpinner("use_smart_battle_boss_companion_2nd_damage", damage_methods, damage_methods[3])
	addTextView("\tMin MP : ")
	addEditNumber("use_smart_battle_boss_companion_2nd_mp",25)
	--]]
	dialogShow("Select custom actions to be performed")

	cbattlemenu(sb_skilluse,sb_skillmp,sb_skillcast,"Custom Battle - First Actions","a")

	if(use_smart_battle_2nd) then
		cbattlemenu(sb_skilluse2,sb_skillmp2,sb_skillcast2,"Custom Battle - Actions after "..use_smart_battle_2nd_round.." turns","b")
	end

	if(use_smart_battle_boss) then
		cbattlemenu(sb_skilluse_boss,sb_skillmp_boss,sb_skillcast_boss,"Custom Battle - Actions on Boss 1st turn","c")
	end

	if(use_smart_battle_boss_2nd) then
		cbattlemenu(sb_skilluse_boss2,sb_skillmp_boss2,sb_skillcastboss2,"Custom Battle - Actions on Boss 2nd turn","d")
	end
end

config_log = "\nApp Screen size: "..screen:getX().."x"..screen:getY().."\tr_x: "..r_x.."\tr_y: "..r_y.."\tr_w: "..r_w.."\tr_h: "..r_h..":\nTask: "..farmloc.."\nFind Battle: "..tostring(loot).."\nDim: "..tostring(dimscreen).."\nRefill: "..tostring(refill).."\nSwipe mode: "..trace_mode.."\nStep mode: "..step_mode.."\nLagx: "..lagx

if(trace_mode == 1) then
	setDragDropStepCount(50)
	setDragDropStepInterval(1)
	setDragDropTiming(100,20)
elseif(trace_mode == 2) then
	setDragDropStepCount(100)
	setDragDropStepInterval(0.1)
	setDragDropTiming(100,20)
elseif(trace_mode == 3) then
	setDragDropStepCount(100)
	setDragDropStepInterval(1)
	setDragDropTiming(100,20)
end

if(debug_mode) then config_log:save("run.log") end
if(dimscreen) then setBrightness(0) end --dim screen only on pro
if(bonus_unit_menu) then use_bonus_unit = true end
if(battle_mode == 2) then use_esper_battle = true end
if(battle_mode == 4) then use_repeat_battle = true end
if(comp_mode == 2) then use_bonus_unit = true end
if(comp_mode == 3) then use_highest_atk_companion = true end

while true do
	if(farmloc == "chain_helper") then
		--while(sb_reg:exists(IsReady,lagx)) do --Old version
		while(existsIsReady(bottom_reg,lagx)) do
			wait(lagx)
		end
		scriptExit()
	end
	depart_count = depart_count + 1
	if (ALver >= "6.6.0") then setStopMessage("Task : "..farmloc.."\n\nDepart : "..depart_count.."\nGame Over : "..gameover_count.."\nLapis Refill : "..lapis_refill_count) end
	if (debug_mode) then runlog("Depart #"..depart_count, true) end
	if (farmloc == "earth_shrine_entrance_speedmode") then
		ese_speed(farmloc)
	elseif (farmloc == "arena") then
		if(battle_mode == 1) then arena_mode = true
		elseif(battlemode == 3) then use_smart_battle = true
		elseif(battlemode == 4) then use_repeat_battle = true end
		arena()
	else
		fFarm(farmloc)
	end
	if (max_depart_count ~= 99999 and depart_count >= max_depart_count) then scriptExit("Finished") end
end
