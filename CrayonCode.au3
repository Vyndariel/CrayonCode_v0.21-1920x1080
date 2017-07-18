#cs ----------------------------------------------------------------------------

	AutoIt Version: 3.3.14.2
	Author:         CrayonCode
	Version:		 Alpha 0.21
	Contact:		 https://discord.gg/yEqadvZ last edited by s3anlike & Rodent11

#ce ----------------------------------------------------------------------------

#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Compile_Both=y  ;required for ImageSearch.au3
#AutoIt3Wrapper_UseX64=y  ;required for ImageSearch.au3
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#RequireAdmin
#include "ImageSearch.au3"
#include "FastFind.au3"
#include <File.au3>
#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <TabConstants.au3>
#include <WindowsConstants.au3>
#include <ListViewConstants.au3>
#include <GuiListView.au3>
#include <WinAPI.au3>
#include <SQLite.dll.au3>

#Region ### START Koda GUI section ### Form=c:\program files (x86)\autoit3\scite\koda\forms\newfish3.kxf
$CrayonCode = GUICreate("CrayonCode", 401, 501, 2, 511, -1, BitOR($WS_EX_TOPMOST, $WS_EX_WINDOWEDGE))
GUISetBkColor(0xFFFFFF)
$Tab = GUICtrlCreateTab(0, 0, 400, 432)
$Tab_Main = GUICtrlCreateTabItem("Main")
$Group4 = GUICtrlCreateGroup("Stats", 8, 32, 377, 385)
$Label6 = GUICtrlCreateLabel("Inventory:", 32, 56, 51, 17)
$E_Inventory = GUICtrlCreateEdit("", 104, 56, 265, 17, BitOR($ES_CENTER, $ES_NOHIDESEL, $ES_READONLY))
GUICtrlSetTip(-1, "Number of looted items / Avaible Inventory Slots ( Reserved Slots). Stops fishing when limit is reached.")
$ListView1 = GUICtrlCreateListView("Type|Session|Total", 24, 88, 354, 270, BitOR($LVS_REPORT, $LVS_SHOWSELALWAYS, $WS_VSCROLL), $LVS_EX_FULLROWSELECT)
GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 0, 100)
GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 1, 90)
GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 2, 100)
$Label2 = GUICtrlCreateLabel("Press CTRL + F1 to terminate the bot in case it gets stuck", 72, 384, 276, 17)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Tab_Settings = GUICtrlCreateTabItem("Settings")
$Loot_Settings = GUICtrlCreateGroup("Loot Settings", 8, 40, 121, 169)
$LRarity = GUICtrlCreateLabel("Minimum Rarity:", 20, 63, 78, 17)
$CRarity = GUICtrlCreateCombo("", 28, 87, 82, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
GUICtrlSetData(-1, "Gold|Blue|Green|White|Specials Only", "Blue")
GUICtrlSetTip(-1, "Pick up items that are equal or higher Rarity.")
$CBSpecial1 = GUICtrlCreateCheckbox("Loot Silver Key", 20, 119, 97, 17)
GUICtrlSetState(-1, $GUI_CHECKED)
GUICtrlSetTip(-1, "Pick up Silverkey. (Ignores Minimum Rarity)")
$CBSpecial2 = GUICtrlCreateCheckbox("Loot Ancient Relic", 20, 135, 105, 17)
GUICtrlSetState(-1, $GUI_CHECKED)
GUICtrlSetTip(-1, "Pick up Ancient Relics. (Ignores Minimum Rarity)")
$CBSpecial3 = GUICtrlCreateCheckbox("Loot Coelacanth", 20, 151, 97, 17)
GUICtrlSetState(-1, $GUI_CHECKED)
GUICtrlSetTip(-1, "Pick up Coealacanth. (Ignores Minimum Rarity)")
$CBEvent = GUICtrlCreateCheckbox("Loot Event items", 20, 168, 97, 17)
GUICtrlSetState(-1, $GUI_CHECKED)
GUICtrlSetTip(-1, "Pick up event items. (Ignores Minimum Rarity) [You can add new even items by putting a cropped .bmp to res/event]")
$CBTrash = GUICtrlCreateCheckbox("Loot Trash", 20, 184, 97, 17)
GUICtrlSetTip(-1, "Do you want to pick up trash? Are you sure? (Will loot white rarity items with quantity)")
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Inventory_Settings = GUICtrlCreateGroup("Inventory Settings", 136, 40, 121, 169)
$LRelicReserve = GUICtrlCreateLabel("Reserved for Relics", 144, 96, 97, 17)
$IRelicReserve = GUICtrlCreateInput("48", 168, 120, 49, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_NUMBER))
GUICtrlSetLimit(-1, 3)
GUICtrlSetTip(-1, "Number of empty slots in your inventory.")
$LBuffer = GUICtrlCreateLabel("Sell/Process Buffer", 144, 152, 95, 17)
GUICtrlSetTip(-1, "When the free inventory slots are full, these slots will be reserved for Ancient Relics and Coelacanths.")
$IBuffer = GUICtrlCreateInput("4", 168, 176, 49, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_NUMBER))
GUICtrlSetLimit(-1, 2)
GUICtrlSetTip(-1, "Keep selected amount of empty slots. ( 2 or more should prevent all 'inventory full' errors)")
$CBEmptyAuto = GUICtrlCreateCheckbox("Autodetect", 152, 64, 97, 17)
GUICtrlSetState(-1, $GUI_CHECKED)
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlSetTip(-1, "Counts empty inventory slots.")
GUICtrlCreateGroup("", -99, -99, 1, 1)
$GBuffFood = GUICtrlCreateGroup("Buff Food", 264, 40, 121, 169)
$CBBuffFood = GUICtrlCreateCheckbox("Use Buff Food", 280, 64, 97, 17)
$CBuffFood = GUICtrlCreateCombo("", 304, 120, 41, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
GUICtrlSetData(-1, "1|2|3|4|5|6|7|8|9|0", "0")
GUICtrlSetTip(-1, "Put your food on one of the hotkeys.")
$LHotkey = GUICtrlCreateLabel("Hotkey:", 280, 96, 41, 17)
$LInterval = GUICtrlCreateLabel("Interval:", 280, 152, 42, 17)
$IBuffFood = GUICtrlCreateInput("30", 304, 176, 41, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_NUMBER))
GUICtrlSetLimit(-1, 3)
GUICtrlSetTip(-1, "Interval in minutes.")
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Misc_Settings = GUICtrlCreateGroup("Misc Settings", 8, 216, 377, 209)
$CBFeedWorker = GUICtrlCreateCheckbox("Enable Feed Worker", 20, 248, 121, 17)
GUICtrlSetTip(-1, "Will feed workers every 90 minutes. Make sure to have beer in the inventory.")
$CBDiscardRods = GUICtrlCreateCheckbox("Enable Discard Rods", 20, 328, 121, 17)
GUICtrlSetTip(-1, "Discards disposable fishingrods. (Those that can't be repaired)")
$CBDryFish = GUICtrlCreateCheckbox("Enable Drying Fish", 20, 288, 121, 17)
GUICtrlSetTip(-1, "Will dry fish when inventory is almost full. Empty Slots will be automatically evaluated after.")
$CDryFish = GUICtrlCreateCombo("", 226, 286, 82, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
GUICtrlSetData(-1, "White|Green|Blue|Gold", "White")
GUICtrlSetTip(-1, "Maxmum rarity to use for drying.")
$LDryingRarity = GUICtrlCreateLabel("Max Rarity:", 166, 290, 57, 17)
$IFeedWorkerTime = GUICtrlCreateInput("30", 226, 246, 41, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_NUMBER))
GUICtrlSetLimit(-1, 3)
GUICtrlSetTip(-1, "Interval in minutes.")
$Label1 = GUICtrlCreateLabel("Interval:", 174, 250, 42, 17)
$BFeedWorker = GUICtrlCreateButton("Test", 328, 246, 50, 21)
$BDryFish = GUICtrlCreateButton("Test", 328, 286, 50, 21)
$CBRestart = GUICtrlCreateCheckbox("Enable Auto-Restart", 20, 368, 121, 17)
GUICtrlSetTip(-1, "On disconnect: Starts Launcher, enters password, starts game, enters main server, connects and start fishing again. PASSWORD WILL BE SAVED IN PLAIN TEXT config/data.ini!!!")
$IPassword = GUICtrlCreateInput("IPassword", 226, 366, 89, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_PASSWORD))
$LPassword = GUICtrlCreateLabel("Password:", 168, 370, 53, 17)
$BRestart = GUICtrlCreateButton("Test", 328, 366, 50, 21)
$IRestartPath = GUICtrlCreateInput("C:\Black Desert\", 160, 392, 129, 21)
$IRestartTimeout = GUICtrlCreateInput("90", 290, 392, 24, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_NUMBER))
GUICtrlSetTip(-1, "Timeout in seconds (Increase if you have a slow computer)")
$LRestart = GUICtrlCreateLabel("BDO Path | Timeout", 56, 396, 98, 17)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Tab_Settings2 = GUICtrlCreateTabItem("Auto-Restock")
$GRestock_Settings = GUICtrlCreateGroup("Restock Settings", 8, 32, 385, 393)
$CBSell = GUICtrlCreateCheckbox("Trade Fish", 16, 128, 113, 17)
GUICtrlSetState(-1, $GUI_CHECKED)
GUICtrlSetTip(-1, "Visits <Trade Manager> to sell all fish/trade goods.")
$CBRepair = GUICtrlCreateCheckbox("Repair Inventory", 16, 152, 113, 17)
GUICtrlSetTip(-1, "Repairs all items in Inventory.")
$CBBroker = GUICtrlCreateCheckbox("Auction Relics", 16, 176, 113, 17)
GUICtrlSetTip(-1, "Puts Relics on the item exchange.")
$CBBank = GUICtrlCreateCheckbox("Store Relics/Money", 16, 200, 113, 17)
GUICtrlSetState(-1, $GUI_CHECKED)
GUICtrlSetTip(-1, "Puts Relics and Money in the bank.")
$ISell = GUICtrlCreateInput("", 136, 128, 209, 21)
GUICtrlSetTip(-1, "e.g. <Trade Manager> Bahar")
$IRepair = GUICtrlCreateInput("", 136, 152, 209, 21)
GUICtrlSetTip(-1, "e.g. <Blacksmith> Tranan")
$IBroker = GUICtrlCreateInput("", 136, 176, 209, 21)
GUICtrlSetTip(-1, "e.g. <Marketplace Director> Shiel")
$IBank = GUICtrlCreateInput("", 136, 200, 209, 21)
GUICtrlSetTip(-1, "e.g. <Storage Keeper> Ernill")
$RHorse = GUICtrlCreateRadio("Horse", 24, 80, 113, 17)
GUICtrlSetState(-1, $GUI_CHECKED)
$RBoat = GUICtrlCreateRadio("Boat", 24, 96, 113, 17)
$LNPCName = GUICtrlCreateLabel("NPC Name (Leave empty for nearest):", 152, 104, 183, 17)
GUICtrlSetTip(-1, "Always use the full title of the NPC! E.g. <Trade Manager> Bahar")
$LMount = GUICtrlCreateLabel("Walk back to mount:", 24, 64, 103, 17)
GUICtrlSetTip(-1, "Position your mount at you fishing spot so that you can fish after autopathing to this point.")
$BTestRestock = GUICtrlCreateButton("Test Auto-Restock", 148, 375, 115, 25)
GUICtrlSetTip(-1, "Test your route to make sure it works!")
$GRestock = GUICtrlCreateGroup("", 176, 48, 145, 41)
$CBRestock = GUICtrlCreateCheckbox("Enable Auto-Restock", 190, 62, 121, 17)
GUICtrlSetTip(-1, "Will visit selected NPCs when Inventory is full or no fishing rods are usable. Requires a mount as anchorpoint!")
GUICtrlCreateGroup("", -99, -99, 1, 1)
$CSell = GUICtrlCreateCombo("", 352, 128, 33, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
GUICtrlSetData(-1, "1|2|3|4|5|6|7|8", "1")
GUICtrlSetTip(-1, "Order in which the NPCs are visited. 1 will be first and 4 will be last.")
$CRepair = GUICtrlCreateCombo("", 352, 152, 33, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
GUICtrlSetData(-1, "1|2|3|4|5|6|7|8", "2")
GUICtrlSetTip(-1, "Order in which the NPCs are visited. 1 will be first and 4 will be last.")
$CBroker = GUICtrlCreateCombo("", 352, 176, 33, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
GUICtrlSetData(-1, "1|2|3|4|5|6|7|8", "3")
GUICtrlSetTip(-1, "Order in which the NPCs are visited. 1 will be first and 4 will be last.")
$CBank = GUICtrlCreateCombo("", 352, 200, 33, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
GUICtrlSetData(-1, "1|2|3|4|5|6|7|8", "4")
GUICtrlSetTip(-1, "Order in which the NPCs are visited. 1 will be first and 4 will be last.")
$LOrder = GUICtrlCreateLabel("Order:", 352, 104, 33, 17)
GUICtrlSetTip(-1, "Order in which the NPCs are visited. 1 will be first and 4 will be last.")
$IProxy1 = GUICtrlCreateInput("", 136, 254, 209, 21)
GUICtrlSetTip(-1, "e.g. <Storage Keeper> Ernill")
$IProxy2 = GUICtrlCreateInput("", 136, 278, 209, 21)
GUICtrlSetTip(-1, "e.g. <Storage Keeper> Ernill")
$IProxy3 = GUICtrlCreateInput("", 136, 302, 209, 21)
GUICtrlSetTip(-1, "e.g. <Storage Keeper> Ernill")
$IProxy4 = GUICtrlCreateInput("", 136, 326, 209, 21)
GUICtrlSetTip(-1, "e.g. <Storage Keeper> Ernill")
$CP1 = GUICtrlCreateCombo("", 352, 253, 33, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
GUICtrlSetData(-1, "1|2|3|4|5|6|7|8", "5")
GUICtrlSetTip(-1, "Order in which the NPCs are visited. 1 will be first and 4 will be last.")
$CP2 = GUICtrlCreateCombo("", 352, 277, 33, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
GUICtrlSetData(-1, "1|2|3|4|5|6|7|8", "6")
GUICtrlSetTip(-1, "Order in which the NPCs are visited. 1 will be first and 4 will be last.")
$CP3 = GUICtrlCreateCombo("", 352, 301, 33, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
GUICtrlSetData(-1, "1|2|3|4|5|6|7|8", "7")
GUICtrlSetTip(-1, "Order in which the NPCs are visited. 1 will be first and 4 will be last.")
$CP4 = GUICtrlCreateCombo("", 352, 325, 33, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
GUICtrlSetData(-1, "1|2|3|4|5|6|7|8", "8")
GUICtrlSetTip(-1, "Order in which the NPCs are visited. 1 will be first and 4 will be last.")
$LProxy1 = GUICtrlCreateLabel("NPC Name (Leave empty to disable):", 152, 232, 178, 17)
$LProxy2 = GUICtrlCreateLabel("Waypoint NPCs", 28, 292, 79, 17)
GUICtrlSetTip(-1, "Try pathfinding to different NPCs first, if you get stuck on your route.")
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Tab_Digging = GUICtrlCreateTabItem("Digging")
$GDigging_Settings = GUICtrlCreateGroup("Digging Settings", 8, 32, 377, 353)
$IDHK1 = GUICtrlCreateInput("IDHK1", 188, 86, 145, 21)
$IDHK2 = GUICtrlCreateInput("IDHK2", 188, 118, 145, 21)
$IDHK3 = GUICtrlCreateInput("IDHK3", 188, 150, 145, 21)
$LPurifiedLiquid = GUICtrlCreateLabel("Purified Liquid Hotkey:", 38, 88, 110, 17)
$LStarAniseHotkey = GUICtrlCreateLabel("Star Anise Tea Hotkey:", 38, 120, 114, 17)
$LHPPot = GUICtrlCreateLabel("HP Potion Hotkey:", 38, 152, 92, 17)
$BDigging = GUICtrlCreateButton("Start/Stop [F6]", 200, 328, 123, 33)
$LDiggingDesc = GUICtrlCreateLabel("Scans for Desert Debuff and uses Hotkey accordingly. Spams Shovel on CD.", 16, 56, 368, 17)
$IDHK4 = GUICtrlCreateInput("IDHK4", 188, 182, 145, 21)
$LHK4 = GUICtrlCreateLabel("Shovel Hotkey:", 38, 184, 77, 17)
$IDCD = GUICtrlCreateInput("30", 188, 214, 145, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_NUMBER))
$LDCD = GUICtrlCreateLabel("Shovel CD in seconds:", 38, 216, 112, 17)
$CBDBF = GUICtrlCreateCheckbox("Apply Buff Food Settings", 112, 272, 137, 17)
GUICtrlSetTip(-1, "Will use the Buff Food that is defined in the Settings Tab.")
$LDCD2 = GUICtrlCreateLabel("Shovel CD = 0 uses Lootwindow detection instead of spamming.", 38, 240, 307, 17)
GUICtrlSetTip(-1, "When the Lootwindow pop up, because of a Crystal Shard it will use the shovel hotkey.")
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Tab_MP = GUICtrlCreateTabItem("Martketplace")
$GMarketplace = GUICtrlCreateGroup("Marketplace Settings", 8, 32, 385, 385)
$BMarketplace = GUICtrlCreateButton("Start/Stop [F5]", 136, 344, 123, 33)
$Label3 = GUICtrlCreateLabel("Select your item in the marketplace.", 112, 80, 172, 17)
$Label4 = GUICtrlCreateLabel("You should see 'Previous' and 'Refresh on the bottom.", 64, 104, 259, 17)
$Label5 = GUICtrlCreateLabel("Start with F5 and it will Bid and Buy for you.", 104, 128, 207, 17)
$Label8 = GUICtrlCreateLabel("No settings avaible at the moment.", 112, 152, 167, 17)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Tab_Milk = GUICtrlCreateTabItem("Milking")
$GMilk = GUICtrlCreateGroup("Milking Settings", 8, 32, 385, 385)
$LMilkCD = GUICtrlCreateLabel("Milking CD in seconds (Default 90):", 38, 120, 170, 17)
GUICtrlSetTip(-1, "The amount of time before pressing R. (Cow takes ~90s to respawn)")
$IMilkCD = GUICtrlCreateInput("0", 240, 118, 33, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_NUMBER))
GUICtrlSetLimit(-1, 2)
$Label9 = GUICtrlCreateLabel("CD = 0 will only do the minigame. (e.g. actively switchting cows)", 38, 144, 303, 17)
$BMilk = GUICtrlCreateButton("Start/Stop [F7]", 136, 344, 123, 33)
$LMilkDesc = GUICtrlCreateLabel("Plays the complete Milking Game. Add CD if you AFK on one cow.", 38, 72, 316, 17)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Tab_RandomSettings = GUICtrlCreateTabItem("Randomization")
$GRandomization = GUICtrlCreateGroup("Randomization Settings", 8, 32, 377, 137)
$I_RS_ReelIn_Min = GUICtrlCreateInput("1000", 96, 88, 121, 21)
$L_RS_ReelIn = GUICtrlCreateLabel("Reel In:", 24, 88, 41, 17)
GUICtrlSetTip(-1, "Waits random amount of time when the fishing icon appears over your head.")
$L_RS_Min = GUICtrlCreateLabel("Min (Milliseconds)", 112, 64, 87, 17)
$L_RS_Max = GUICtrlCreateLabel("Max (Milliseconds)", 256, 64, 90, 17)
$I_RS_ReelIn_Max = GUICtrlCreateInput("5000", 240, 88, 121, 21)
$I_RS_Riddle_Min = GUICtrlCreateInput("50", 96, 120, 121, 21)
$I_RS_Riddle_Max = GUICtrlCreateInput("500", 240, 120, 121, 21)
$L_RS_Riddle = GUICtrlCreateLabel("Riddle:", 24, 120, 37, 17)
GUICtrlSetTip(-1, "Waits random time between sending the keystrokes.")
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Tab_Info = GUICtrlCreateTabItem("Info")
$Credits = GUICtrlCreateEdit("", 32, 72, 337, 289, BitOR($ES_CENTER, $ES_READONLY))
GUICtrlSetData(-1, "Author: CrayonCode")
GUICtrlCreateTabItem("")
$BStart = GUICtrlCreateButton("Start/Stop [F4]", 278, 460, 115, 33)
GUICtrlSetTip(-1, "Starts/Stops fishing. Shortcut is F4.")
$BReset = GUICtrlCreateButton("Reset Session [F8]", 156, 460, 115, 33)
GUICtrlSetTip(-1, "Sets Inventory and Session stats back to zero. Shortcut is F8.")
$BSave = GUICtrlCreateButton("Save Settings", 10, 460, 115, 33)
GUICtrlSetTip(-1, "Sets Inventory and Session stats back to zero. Shortcut is F8.")
$E_Status = GUICtrlCreateEdit("", 47, 437, 345, 17, BitOR($ES_CENTER, $ES_NOHIDESEL, $ES_READONLY))
$Label7 = GUICtrlCreateLabel("Status:", 10, 440, 37, 17)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

#Region - Global
OnAutoItExitRegister(_ImageSearchShutdown)
OnAutoItExitRegister(CloseLog)
Opt("MouseClickDownDelay", 100)
Opt("MouseClickDelay", 50)
Opt("SendKeyDelay", 50)
Global $hBDO = "BLACK DESERT -"
Global $Fish = False, $Marketplace = False, $Processing = False
Global $Digging = False, $Milking = False, $WorkerFeeding = False
Global $Bufftimer = TimerInit(), $FeedWorkertimer = TimerInit()
Global $Breaktimer
Global $DryFishCooldownTimer = 0
Global $LastGUIStatus
Global $freedetectedslots = 0
Global $ResOffset[4] = [0, 0, 0, 0]
Global $LogFile = ""
Global Static $LogEnable = IniRead("res/data.ini", "LOGFILE", "Enable", 1)
$ListView1_0 = GUICtrlCreateListViewItem("White", $ListView1)
$ListView1_1 = GUICtrlCreateListViewItem("Green", $ListView1)
$ListView1_2 = GUICtrlCreateListViewItem("Blue", $ListView1)
$ListView1_3 = GUICtrlCreateListViewItem("Gold", $ListView1)
$ListView1_4 = GUICtrlCreateListViewItem("Silver Key", $ListView1)
$ListView1_5 = GUICtrlCreateListViewItem("Ancient Relic", $ListView1)
$ListView1_6 = GUICtrlCreateListViewItem("Coelacanth", $ListView1)
$ListView1_7 = GUICtrlCreateListViewItem("Event items", $ListView1)
$ListView1_8 = GUICtrlCreateListViewItem("Trash", $ListView1)


HotKeySet("^{F1}", "_terminate")
HotKeySet("{F4}", "Fish")
HotKeySet("{F5}", "RunMarketplace")
HotKeySet("{F6}", "DesertDebuff")
HotKeySet("{F7}", "Milking")
HotKeySet("{F8}", "ResetSession")
HotKeySet("{F9}", "FeedWorkerLoop")
#EndRegion - Global

#Region - Support
Func InitGUI()

	; Loot Settings
	Global $LootSettings = IniReadSection("config/data.ini", "LootSettings")
	Switch $LootSettings[1][1]
		Case 0
			GUICtrlSetData($CRarity, "|Gold|Blue|Green|White|Specials Only", "White")
		Case 1
			GUICtrlSetData($CRarity, "|Gold|Blue|Green|White|Specials Only", "Green")
		Case 2
			GUICtrlSetData($CRarity, "|Gold|Blue|Green|White|Specials Only", "Blue")
		Case 3
			GUICtrlSetData($CRarity, "|Gold|Blue|Green|White|Specials Only", "Gold")
		Case 4
			GUICtrlSetData($CRarity, "|Gold|Blue|Green|White|Specials Only", "Specials Only")
	EndSwitch
	GUICtrlSetState($CBSpecial1, CBT($LootSettings[2][1]))
	GUICtrlSetState($CBSpecial2, CBT($LootSettings[3][1]))
	GUICtrlSetState($CBSpecial3, CBT($LootSettings[4][1]))
	GUICtrlSetState($CBEvent, CBT($LootSettings[5][1]))
	GUICtrlSetState($CBTrash, CBT($LootSettings[6][1]))

	; Inventory Settings
	Global $InventorySettings = IniReadSection("config/data.ini", "InventorySettings")
	GUICtrlSetData($IRelicReserve, $InventorySettings[1][1])
	GUICtrlSetData($IBuffer, $InventorySettings[2][1])
	GUICtrlSetState($CBDiscardRods, CBT($InventorySettings[3][1]))
	GUICtrlSetState($CBEmptyAuto, CBT($InventorySettings[4][1]))

	; Digging Settings
	Global $DiggingsSettings = IniReadSection("config/data.ini", "DiggingSettings")
	GUICtrlSetData($IDHK1, $DiggingsSettings[1][1])
	GUICtrlSetData($IDHK2, $DiggingsSettings[2][1])
	GUICtrlSetData($IDHK3, $DiggingsSettings[3][1])
	GUICtrlSetData($IDHK4, $DiggingsSettings[4][1])
	GUICtrlSetData($IDCD, $DiggingsSettings[5][1])
	GUICtrlSetState($CBDBF, CBT($DiggingsSettings[6][1]))

	; Milking Settings
	Global $MilkingSettings = IniReadSection("config/data.ini", "MilkingSettings")
	GUICtrlSetData($IMilkCD, $MilkingSettings[1][1])

	; Drying Settings
	Global $DryingSettings = IniReadSection("config/data.ini", "DryingSettings")
	GUICtrlSetState($CBDryFish, CBT($DryingSettings[1][1]))
	Switch $DryingSettings[2][1]
		Case 0
			GUICtrlSetData($CDryFish, "|Gold|Blue|Green|White", "White")
		Case 1
			GUICtrlSetData($CDryFish, "|Gold|Blue|Green|White", "Green")
		Case 2
			GUICtrlSetData($CDryFish, "|Gold|Blue|Green|White", "Blue")
		Case 3
			GUICtrlSetData($CDryFish, "|Gold|Blue|Green|White", "Gold")
	EndSwitch

	; Restart Settings
	Global $StartUpSettings = IniReadSection("config/data.ini", "StartUpSettings")
	GUICtrlSetState($CBRestart, CBT($StartUpSettings[1][1]))
	GUICtrlSetData($IPassword, $StartUpSettings[3][1])
	GUICtrlSetData($IRestartPath, $StartUpSettings[2][1])
	GUICtrlSetData($IRestartTimeout, $StartUpSettings[4][1])

	; Food Settings
	Global $FoodSettings = IniReadSection("config/data.ini", "FoodSettings")
	GUICtrlSetState($CBBuffFood, CBT($FoodSettings[1][1]))
	GUICtrlSetData($CBuffFood, $FoodSettings[2][1])
	GUICtrlSetData($IBuffFood, $FoodSettings[3][1])

	; Restock Settings
	Global $RestockSettings = IniReadSection("config/data.ini", "RestockSettings")
	GUICtrlSetState($CBRestock, CBT($RestockSettings[1][1])) ; Enable Auto-Restock
	If $RestockSettings[2][1] = 0 Then ; Select Horse or Boat
		GUICtrlSetState($RHorse, 1)
	Else
		GUICtrlSetState($RBoat, 1)
	EndIf
	GUICtrlSetState($CBSell, CBT($RestockSettings[3][1])) ; Trade Fish
	GUICtrlSetState($CBRepair, CBT($RestockSettings[4][1])) ; Repair Inventory
	GUICtrlSetState($CBBroker, CBT($RestockSettings[5][1])) ; Auction Relics
	GUICtrlSetState($CBBank, CBT($RestockSettings[6][1])) ; Store Relics/Money
	GUICtrlSetData($ISell, $RestockSettings[7][1])
	GUICtrlSetData($IRepair, $RestockSettings[8][1])
	GUICtrlSetData($IBroker, $RestockSettings[9][1])
	GUICtrlSetData($IBank, $RestockSettings[10][1])
	GUICtrlSetData($CSell, $RestockSettings[11][1])
	GUICtrlSetData($CRepair, $RestockSettings[12][1])
	GUICtrlSetData($CBroker, $RestockSettings[13][1])
	GUICtrlSetData($CBank, $RestockSettings[14][1])
	GUICtrlSetData($CP1, $RestockSettings[15][1])
	GUICtrlSetData($CP2, $RestockSettings[16][1])
	GUICtrlSetData($CP3, $RestockSettings[17][1])
	GUICtrlSetData($CP4, $RestockSettings[18][1])
	GUICtrlSetData($IProxy1, $RestockSettings[19][1])
	GUICtrlSetData($IProxy2, $RestockSettings[20][1])
	GUICtrlSetData($IProxy3, $RestockSettings[21][1])
	GUICtrlSetData($IProxy4, $RestockSettings[22][1])

	; WorkerSettings
	Global $WorkerSettings = IniReadSection("config/data.ini", "WorkerSettings")
	GUICtrlSetState($CBFeedWorker, CBT($WorkerSettings[1][1]))

	; Randomization Settings
	Global $RandomSettings = IniReadSection("config/data.ini", "RandomSettings")
	GUICtrlSetData($I_RS_ReelIn_Min, $RandomSettings[1][1])
	GUICtrlSetData($I_RS_ReelIn_Max, $RandomSettings[2][1])
	GUICtrlSetData($I_RS_Riddle_Min, $RandomSettings[3][1])
	GUICtrlSetData($I_RS_Riddle_Max, $RandomSettings[4][1])

	; Stats
	Global $SessionStats = IniReadSection("config/stats.ini", "SessionStats")
	Global $TotalStats = IniReadSection("config/stats.ini", "TotalStats")
	GUICtrlSetData($ListView1_0, $SessionStats[1][0] & "|" & $SessionStats[1][1] & "|" & $TotalStats[1][1], "")
	GUICtrlSetData($ListView1_1, $SessionStats[2][0] & "|" & $SessionStats[2][1] & "|" & $TotalStats[2][1], "")
	GUICtrlSetData($ListView1_2, $SessionStats[3][0] & "|" & $SessionStats[3][1] & "|" & $TotalStats[3][1], "")
	GUICtrlSetData($ListView1_3, $SessionStats[4][0] & "|" & $SessionStats[4][1] & "|" & $TotalStats[4][1], "")
	GUICtrlSetData($ListView1_4, $SessionStats[5][0] & "|" & $SessionStats[5][1] & "|" & $TotalStats[5][1], "")
	GUICtrlSetData($ListView1_5, $SessionStats[6][0] & "|" & $SessionStats[6][1] & "|" & $TotalStats[6][1], "")
	GUICtrlSetData($ListView1_6, $SessionStats[7][0] & "|" & $SessionStats[7][1] & "|" & $TotalStats[7][1], "")
	GUICtrlSetData($ListView1_7, $SessionStats[8][0] & "|" & $SessionStats[8][1] & "|" & $TotalStats[8][1], "")
	GUICtrlSetData($ListView1_8, $SessionStats[9][0] & "|" & $SessionStats[9][1] & "|" & $TotalStats[9][1], "")

	; Inventory Status
	Global $CurrentStats = IniReadSection("config/data.ini", "CurrentStats")
	SetGUIInventory(0)
	GUICtrlSetData($E_Status, "Please equip a fishing rod. Then start.", "")

	; Credits
	Local $creditstext = "Author: CrayonCode" & @CRLF & @CRLF
	$creditstext &= "This project is specifically made for the english Black Desert EU/NA client." & @CRLF & $creditstext
	$creditstext &= "Requirements are 1920x1080 Windowed Fullscreen and the default font." & @CRLF & @CRLF
	$creditstext &= "This project is Open Source and serves for educational purposes only." & @CRLF & @CRLF
	$creditstext &= "Contact & Feedback @ http://www.elitepvpers.com/forum/black-desert/4268940-autoit-crayoncode-bot-project-opensource-free.html"
	GUICtrlSetData($Credits, $creditstext)

EndFunc   ;==>InitGUI

Func StoreGUI()

	; Loot Settings
	Global $LootSettings = IniReadSection("config/data.ini", "LootSettings")
	Switch GUICtrlRead($CRarity)
		Case "White"
			$LootSettings[1][1] = 0
		Case "Green"
			$LootSettings[1][1] = 1
		Case "Blue"
			$LootSettings[1][1] = 2
		Case "Gold"
			$LootSettings[1][1] = 3
		Case "Specials Only"
			$LootSettings[1][1] = 4
	EndSwitch
	$LootSettings[2][1] = CBT(GUICtrlRead($CBSpecial1))
	$LootSettings[3][1] = CBT(GUICtrlRead($CBSpecial2))
	$LootSettings[4][1] = CBT(GUICtrlRead($CBSpecial3))
	$LootSettings[5][1] = CBT(GUICtrlRead($CBEvent))
	$LootSettings[6][1] = CBT(GUICtrlRead($CBTrash))
	IniWriteSection("config/data.ini", "LootSettings", $LootSettings)

	; Inventory Settings
	Global $InventorySettings = IniReadSection("config/data.ini", "InventorySettings")
	$InventorySettings[1][1] = Int(GUICtrlRead($IRelicReserve))
	$InventorySettings[2][1] = Int(GUICtrlRead($IBuffer))
	If $InventorySettings[2][1] < 1 Then $InventorySettings[2][1] = 1
	$InventorySettings[3][1] = CBT(GUICtrlRead($CBDiscardRods)) ; Discard Rods
	$InventorySettings[4][1] = CBT(GUICtrlRead($CBEmptyAuto))
	IniWriteSection("config/data.ini", "InventorySettings", $InventorySettings)

	; Digging Settings
	Global $DiggingsSettings = IniReadSection("config/data.ini", "DiggingSettings")
	$DiggingsSettings[1][1] = GUICtrlRead($IDHK1)
	$DiggingsSettings[2][1] = GUICtrlRead($IDHK2)
	$DiggingsSettings[3][1] = GUICtrlRead($IDHK3)
	$DiggingsSettings[4][1] = GUICtrlRead($IDHK4)
	$DiggingsSettings[5][1] = GUICtrlRead($IDCD)
	$DiggingsSettings[6][1] = CBT(GUICtrlRead($CBDBF))
	IniWriteSection("config/data.ini", "DiggingSettings", $DiggingsSettings)

	; Milking Settings
	Global $MilkingSettings = IniReadSection("config/data.ini", "MilkingSettings")
	$MilkingSettings[1][1] = GUICtrlRead($IMilkCD)
	IniWriteSection("config/data.ini", "MilkingSettings", $MilkingSettings)

	; Drying Settings
	Global $DryingSettings = IniReadSection("config/data.ini", "DryingSettings")
	$DryingSettings[1][1] = CBT(GUICtrlRead($CBDryFish))
	Switch GUICtrlRead($CDryFish)
		Case "White"
			$DryingSettings[2][1] = 0
		Case "Green"
			$DryingSettings[2][1] = 1
		Case "Blue"
			$DryingSettings[2][1] = 2
		Case "Gold"
			$DryingSettings[2][1] = 3
	EndSwitch
	IniWriteSection("config/data.ini", "DryingSettings", $DryingSettings)

	; Restart Settings
	Global $StartUpSettings = IniReadSection("config/data.ini", "StartUpSettings")
	$StartUpSettings[1][1] = CBT(GUICtrlRead($CBRestart))
	$StartUpSettings[3][1] = GUICtrlRead($IPassword)
	$StartUpSettings[2][1] = GUICtrlRead($IRestartPath)
	$StartUpSettings[4][1] = Int(GUICtrlRead($IRestartTimeout))
	IniWriteSection("config/data.ini", "StartUpSettings", $StartUpSettings)

	; Food Settings
	Global $FoodSettings = IniReadSection("config/data.ini", "FoodSettings")
	$FoodSettings[1][1] = CBT(GUICtrlRead($CBBuffFood))
	$FoodSettings[2][1] = GUICtrlRead($CBuffFood)
	$FoodSettings[3][1] = GUICtrlRead($IBuffFood)
	IniWriteSection("config/data.ini", "FoodSettings", $FoodSettings)

	; Restock Settings
	Global $RestockSettings = IniReadSection("config/data.ini", "RestockSettings")
	$RestockSettings[1][1] = CBT(GUICtrlRead($CBRestock))
	If GUICtrlRead($RHorse) = 1 Then
		$RestockSettings[2][1] = 0
	Else
		$RestockSettings[2][1] = 1
	EndIf
	$RestockSettings[3][1] = CBT(GUICtrlRead($CBSell))
	$RestockSettings[4][1] = CBT(GUICtrlRead($CBRepair))
	$RestockSettings[5][1] = CBT(GUICtrlRead($CBBroker))
	$RestockSettings[6][1] = CBT(GUICtrlRead($CBBank))
	$RestockSettings[7][1] = GUICtrlRead($ISell)
	$RestockSettings[8][1] = GUICtrlRead($IRepair)
	$RestockSettings[9][1] = GUICtrlRead($IBroker)
	$RestockSettings[10][1] = GUICtrlRead($IBank)
	$RestockSettings[11][1] = Int(GUICtrlRead($CSell))
	$RestockSettings[12][1] = Int(GUICtrlRead($CRepair))
	$RestockSettings[13][1] = Int(GUICtrlRead($CBroker))
	$RestockSettings[14][1] = Int(GUICtrlRead($CBank))
	$RestockSettings[15][1] = Int(GUICtrlRead($CP1))
	$RestockSettings[16][1] = Int(GUICtrlRead($CP2))
	$RestockSettings[17][1] = Int(GUICtrlRead($CP3))
	$RestockSettings[18][1] = Int(GUICtrlRead($CP4))
	$RestockSettings[19][1] = GUICtrlRead($IProxy1)
	$RestockSettings[20][1] = GUICtrlRead($IProxy2)
	$RestockSettings[21][1] = GUICtrlRead($IProxy3)
	$RestockSettings[22][1] = GUICtrlRead($IProxy4)
	IniWriteSection("config/data.ini", "RestockSettings", $RestockSettings)

	; Worker Settings
	Global $WorkerSettings = IniReadSection("config/data.ini", "WorkerSettings")
	$WorkerSettings[1][1] = CBT(GUICtrlRead($CBFeedWorker))
	IniWriteSection("config/data.ini", "WorkerSettings", $WorkerSettings)

	; Randomization Settings
	Global $RandomSettings = IniReadSection("config/data.ini", "RandomSettings")
	$RandomSettings[1][1] = GUICtrlRead($I_RS_ReelIn_Min)
	$RandomSettings[2][1] = GUICtrlRead($I_RS_ReelIn_Max)
	$RandomSettings[3][1] = GUICtrlRead($I_RS_Riddle_Min)
	$RandomSettings[4][1] = GUICtrlRead($I_RS_Riddle_Max)
	IniWriteSection("config/data.ini", "RandomSettings", $RandomSettings)

	SetGUIStatus("Settings saved")
	InitGUI()
EndFunc   ;==>StoreGUI

Func SetGUIStatus($data)
	If $data <> $LastGUIStatus Then
		GUICtrlSetData($E_Status, $data, "")
		ConsoleWrite(@CRLF & @HOUR & ":" & @MIN & "." & @SEC & " " & $data)
		If $LogEnable = True Then LogData(@HOUR & ":" & @MIN & "." & @SEC & " " & $data)
		$LastGUIStatus = $data
	EndIf
EndFunc   ;==>SetGUIStatus

Func LogData($text)
	If $LogFile = "" Then $LogFile = FileOpen("LOGFILE.txt", 9)
	FileWriteLine($LogFile, $text)
EndFunc   ;==>LogData

Func CloseLog()
	If $LogFile <> "" Then
		FileClose($LogFile)
	EndIf
EndFunc   ;==>CloseLog

Func SetGUIInventory($PickedLoot)
	Local $InventorySettings = IniReadSection("config/data.ini", "InventorySettings")
	GUICtrlSetData($E_Inventory, $PickedLoot & " / " & $freedetectedslots - $InventorySettings[2][1] & " R:" & $InventorySettings[1][1], "")
	IniWrite("config/data.ini", "CurrentStats", "PickedLoot", $PickedLoot)
	Return ($PickedLoot)
EndFunc   ;==>SetGUIInventory

Func GUILoopSwitch()
	Switch GUIGetMsg()
		Case $GUI_EVENT_CLOSE
			Exit
		Case $BSave
			StoreGUI()
		Case $BReset
			ResetSession()
		Case $BStart
			Fish()
		Case $BTestRestock
			$ResOffset = DetectFullscreenToWindowedOffset()
			Restock()
		Case $BRestart
			LaunchMain()
			$Fish = False
		Case $BDryFish
			$ResOffset = DetectFullscreenToWindowedOffset()
			HandleDryFish(1)
			$Fish = False
		Case $BFeedWorker
			FeedWorkerTest()
		Case $BDigging
			DesertDebuff()
		Case $BMilk
			Milking()
	EndSwitch
EndFunc   ;==>GUILoopSwitch

Func ResetSession()
	Local $SessionStats = IniReadSection("config/stats.ini", "SessionStats")
	For $i = 1 To UBound($SessionStats) - 1 Step 1
		$SessionStats[$i][1] = 0
	Next
	IniWriteSection("config/stats.ini", "SessionStats", $SessionStats)
	InitGUI()
EndFunc   ;==>ResetSession

Func de_acvtivate($cbstate, $uitarget)
	If $cbstate = 1 Then
		GUICtrlSetState($uitarget, 128)
		Return True
	ElseIf $cbstate = 4 Then
		GUICtrlSetState($uitarget, 64)
		Return True
	EndIf
EndFunc   ;==>de_acvtivate

Func IsProcessConnected($ProcessName)
	Local $PID = ProcessExists($ProcessName)
	If Not $PID Then Return -1
	Local $Pattern = "\s" & $PID & "\s"
	Local $iPID = Run(@ComSpec & " /c netstat -aon", @SystemDir, @SW_HIDE, 4 + 2) ;  $STDERR_CHILD (0x4) + $STDOUT_CHILD (0x2)
	If Not $iPID Then Return -2
	Local $sOutput = ""

	While True
		$sOutput &= StdoutRead($iPID)
		If @error Then ; Exit the loop if the process closes or StdoutRead returns an error.
			ExitLoop
		EndIf
	WEnd

	Return (Int(StringRegExp($sOutput, $Pattern, 0))) ; Returns 1 if connceted, 0 if disconnected.
EndFunc   ;==>IsProcessConnected

Func _terminate()
	Exit (0)
EndFunc   ;==>_terminate

Func cw($text)
	ConsoleWrite(@CRLF & $text)
EndFunc   ;==>cw

Func CoSe($key, $raw = 0)
	$hwnd = WinActive($hBDO)
	If $hwnd = 0 Then $hwnd = WinActivate($hBDO)

	Local Static $Pos = WinGetPos($hwnd)

	Opt("MouseCoordMode", 2)
	If MouseGetPos(0) < 0 Or MouseGetPos(0) > $Pos[2] Or MouseGetPos(1) < 0 Or MouseGetPos(1) > $Pos[3] Then MouseMove(100, 100, 0)
	Opt("MouseCoordMode", 1)

	ControlSend($hwnd, "", "", $key, $raw)
EndFunc   ;==>CoSe

Func CBT($data) ; Transforms Checkbox values for ini
	Switch Int($data)
		Case 1
			Return 1
		Case 4
			Return 0
		Case 0
			Return 4
	EndSwitch
EndFunc   ;==>CBT

Func CheckClientResolution()
	Local Static $Resolution = IniReadSection("config/resolution_settings.ini", "Resolution")
	Local $CCR = WinGetClientSize($hBDO)
	If @error Then
		SetGUIStatus("E: WinGetClientSize failed")
		Return False
	EndIf
	If $CCR[0] = $Resolution[1][0] And $CCR[1] = $Resolution[1][1] Then
		SetGUIStatus("ClientSize matches Resolution Settings.")
		Return True
	Else
		SetGUIStatus("E: ClientSize does not match:" & $CCR[0] & "x" & $CCR[1] & "[" & $Resolution[1][0] & "x" & $Resolution[1][1])
		Return False
	EndIf
	Return False
EndFunc   ;==>CheckClientResolution

Func VisibleCursor()
	Local $cursor = _WinAPI_GetCursorInfo()
	Return ($cursor[1])
EndFunc   ;==>VisibleCursor

Func ObfuscateTitle($length = 5)
	Local $newtitle = ""
	If $length > 0 Then
		For $i = 1 To $length
			Switch Random(1, 3, 1)
				Case 1
					$newtitle &= Chr(Random(65, 90, 1)) ; small letter
				Case 2
					$newtitle &= Chr(Random(97, 122, 1)) ; big letter
				Case 3
					$newtitle &= Random(0, 9, 1) ; number
			EndSwitch
		Next
	EndIf
	$newtitle &= @HOUR & @MIN & @SEC
	WinSetTitle("CrayonCode", "", $newtitle)
	Return True
EndFunc   ;==>ObfuscateTitle

#EndRegion - Support

#Region - Fishing
Func DetectState(ByRef $C)
	Local $SSN = 1
	FFSnapShot(Int($C[0]) + $ResOffset[0], Int($C[1]) + $ResOffset[1], Int($C[2]) + $ResOffset[0], Int($C[3] + $ResOffset[1]), $SSN)

	For $i = 0 To 3 Step 1
		$FF = FFGetPixel(Int($C[0]) + $ResOffset[0], Int($C[1]) + $ResOffset[1] + $i, $SSN)
		$FF2 = FFGetPixel(Int($C[2]) + $ResOffset[0], Int($C[3]) + $ResOffset[1] - $i, $SSN)
		If $FF <> Int($C[4]) And $FF2 <> Int($C[4]) Then Return False
	Next
	Return True
EndFunc   ;==>DetectState

Func GetState()
	Local Static $FishingStandby = StringSplit(StringStripWS(IniRead("config/resolution_settings.ini", "Fishing", "FishingStandby", "679, 60, 1233, 64, 0xE4E4E4"), 8), ",", 2) ; FishingStandby
	Local Static $FishingCurrently = StringSplit(StringStripWS(IniRead("config/resolution_settings.ini", "Fishing", "FishingCurrently", "642, 60, 1256, 64, 0xE4E4E4"), 8), ",", 2) ; FishingCurrently
	Local Static $FishingBite = StringSplit(StringStripWS(IniRead("config/resolution_settings.ini", "Fishing", "FishingBite", "733, 60, 1179, 64, 0xE4E4E4"), 8), ",", 2) ; FishingBite

	If DetectState($FishingBite) = True Then Return (30)
	If DetectState($FishingCurrently) = True Then Return (20)
	If DetectState($FishingStandby) = True Then Return (10)
	Return False
EndFunc   ;==>GetState

Func ReelIn()
	Local Static $ReelIn = StringSplit(StringStripWS(IniRead("config/resolution_settings.ini", "Fishing", "ReelIn", "1030, 405, 1095, 424, 5933000"), 8), ",", 2) ; ReelIn, left, top, right, bottom, color
	Local Static $PressIt = StringSplit(StringStripWS(IniRead("config/resolution_settings.ini", "Fishing", "PressIt", "849, 368, 1068, 372, 0xFFFFFF"), 8), ",", 2) ; PressIt
	Local $RandomSettings = IniReadSection("config/data.ini", "RandomSettings")
	Local $RandomSleep = Random($RandomSettings[1][1], $RandomSettings[2][1], 1)
	Local $SSN = 1, $NS

	SetGUIStatus("Reeling in. (" & Round($RandomSleep / 1000, 0) & "s)")
	Sleep($RandomSleep)

	CoSe("{SPACE}")

	For $i = 0 To 40 Step 1 ; Sleep to prevent scanning before the bar appears
		Sleep(100)
		If DetectState($PressIt) = True Then
			SetGUIStatus("PressIt detected")
			ExitLoop
		EndIf
		If $i = 21 Then
			SetGUIStatus("Pressing SPACE again")
			CoSe("{SPACE}")
		EndIf
	Next
	Local $timer = TimerInit()
	SetGUIStatus("Scanning for blue bar")
	While TimerDiff($timer) / 1000 <= 5 And $Fish
		FFSnapShot($ReelIn[0] + $ResOffset[0], $ReelIn[1] + $ResOffset[1], $ReelIn[2] + $ResOffset[0], $ReelIn[3] + $ResOffset[1], $SSN)
		$NS = FFNearestSpot(1, 1, ($ReelIn[0] + $ResOffset[0] + $ReelIn[2] + $ResOffset[0]) / 2, ($ReelIn[1] + $ResOffset[1] + $ReelIn[3] + $ResOffset[1]) / 2, $ReelIn[4], 30, True, $ReelIn[0] + $ResOffset[0], $ReelIn[1] + $ResOffset[1], $ReelIn[2] + $ResOffset[0], $ReelIn[3] + $ResOffset[1], $SSN)
		If Not @error Then
			CoSe("{SPACE}")
			Return True
		EndIf
	WEnd
	Return False
EndFunc   ;==>ReelIn

Func FindRiddleAnchor()
	Local $timer = TimerInit()
	Local $C[2] = [-1, -1]
	Local $AnchorRegion[4] = [($ResOffset[0] + $ResOffset[2]) / 2 - 200, $ResOffset[1] + 200, ($ResOffset[0] + $ResOffset[2]) / 2 + 200, $ResOffset[3] - 200]
	While TimerDiff($timer) / 1000 <= 4 And $Fish
		If _ImageSearchArea("res/reference_timeline.bmp", 0, $AnchorRegion[0], $AnchorRegion[1], $AnchorRegion[2], $AnchorRegion[3], $C[0], $C[1], 0, 0) = 1 Then
			SetGUIStatus("Riddle anchor found " & $C[0] & ", " & $C[1])
			Return ($C)
		EndIf
	WEnd
	Return ($C)
EndFunc   ;==>FindRiddleAnchor

Func Riddle($iAnchorX, $iAnchorY, $AnchorColor, $SSN)
	Local Const $WordsX[8] = [-2, +3, +3, -2, -2, -2, +3, +3] ; SSWWDDAA
	Local Const $WordsY[8] = [-3, -3, +2, +2, +3, -3, +2, -2] ; SSWWDDAA
	Local $ai[8], $iL = 4

	For $i = 0 To 7 Step 1
		If FFGetPixel($iAnchorX + $WordsX[$i], $iAnchorY + $WordsY[$i], $SSN) = $AnchorColor Then
			$ai[$i] = 1
		Else
			$ai[$i] = 0
		EndIf
	Next

	For $j = 3 To 0 Step -1
		If $ai[$j * 2] + $ai[$j * 2 + 1] = 2 Then $iL = $j
	Next

	Return ($iL)
EndFunc   ;==>Riddle

Func Riddler()
	Local Const $COffset[2] = [60, 55] ; relative position to Anchor (pointing to center of the arrow beneath each letter)
	Local Const $L[5] = ["s", "w", "d", "a", "."] ; basic minigame letters ("." for unidentified)
	Local Const $Spacing = 35 ; Space between each Letter
	Local $SSN = 1
	Local $Word[10], $LetterColor, $text, $Riddle, $Wordlength = 0
	Local $RandomSettings = IniReadSection("config/data.ini", "RandomSettings")

	Local $C = FindRiddleAnchor()
	If $C[0] = -1 Or $C[1] = -1 Then Return False
	FFSnapShot($C[0] - 90, $C[1] - 90, $C[0] + $Spacing * 10 + 90, $C[1], $SSN)
	$LetterColor = FFGetPixel($C[0] - 90 + $COffset[0], $C[1] - 90 + $COffset[1], $SSN)
	Local $AnchorC[2] = [$C[0] - 90 + $COffset[0], $C[1] - 90 + $COffset[1]]

	For $i = 0 To 9 Step 1
		$Riddle = Riddle($AnchorC[0] + $Spacing * $i, $AnchorC[1], $LetterColor, $SSN)
		If $Riddle = 4 Then ; If unidentified exit loop
			$Word[$i] = $L[$Riddle]
			ExitLoop
		Else
			$Word[$i] = $L[$Riddle]
			$Wordlength += 1
		EndIf
	Next

	If $Wordlength < 2 Then
		Return (False)
	Else
		For $i = 0 To 9 Step 1
			If $Word[$i] <> "." Then
				Sleep(Random($RandomSettings[3][1], $RandomSettings[4][1], 1))
				CoSe($Word[$i])
				$text &= $Word[$i]
			EndIf
			Sleep(100)
		Next
		SetGUIStatus("Riddle: " & $text)
		Return (True)
	EndIf
EndFunc   ;==>Riddler

Func Fish()
	Local Static $CorrectRes = False
	$Fish = Not $Fish
	If $Fish = False Then
		SetGUIStatus("Pausing.")
	Else
		SetGUIStatus("Starting...")
		$ResOffset = DetectFullscreenToWindowedOffset()
		If $CorrectRes = False Then $CorrectRes = CheckClientResolution()
		If $CorrectRes = False Then
			SetGUIStatus("E: Client resolution deviates from resolution_settings.ini")
			$Fish = False
			Return False
		EndIf
		$freedetectedslots = DetectFreeInventory()
		SetGUIInventory(0)
	EndIf
EndFunc   ;==>Fish

Func OCInventory($open = True)
	Local Const $Offset[2] = [-298, 48] ; Offset from reference_inventory to left border of first Inventory Slot. For future use.
	Local $IS = False
	Local $C[2]
	Local $timer = TimerInit()
	While Not $IS And ($Fish Or $Processing)
		Sleep(250)
		$IS = _ImageSearchArea("res/reference_inventory.bmp", 0, $ResOffset[0], $ResOffset[1], $ResOffset[2], $ResOffset[3], $C[0], $C[1], 10, 0)
		Sleep(250)
		If $IS = True Then
			If $open = True Then
				$C[0] += $Offset[0]
				$C[1] += $Offset[1]
				Return ($C)
			ElseIf $open = False Then
				CoSe("i")
				Sleep(500)
			EndIf
		ElseIf $IS = False Then
			If $open = True Then
				CoSe("i")
				MouseMove($ResOffset[0] + 30, $ResOffset[1] + 30)
				Sleep(500)
			ElseIf $open = False Then
				SetGUIStatus("Inventory closed")
				Return False
			EndIf
		EndIf
		If TimerDiff($timer) / 1000 >= 6 Then
			SetGUIStatus("OCInventory Timeout")
			Return False
		EndIf
	WEnd
EndFunc   ;==>OCInventory

Func InspectFishingrod()
	Local $WeaponOffSet[2] = [-286, 256]
	Local $x, $y, $IS = False

	Local $InvA = OCInventory(True)
	If IsArray($InvA) = False Then Return False
	If MouseGetPos(0) >= $InvA[0] And MouseGetPos(0) <= $InvA[0] + 500 And MouseGetPos(1) >= $InvA[1] And MouseGetPos(1) <= $InvA[1] + 500 Then MouseMove($InvA[0] - 50, $InvA[1]) ; Keep mouse out of detection range
	$IS = _ImageSearchArea("res/rod_empty.bmp", 0, $InvA[0] + $WeaponOffSet[0] - 24, $InvA[1] + $WeaponOffSet[1] - 24, $InvA[0] + $WeaponOffSet[0] + 24, $InvA[1] + $WeaponOffSet[1] + 24, $x, $y, 50, 0)
	If $IS = True Then
		Return True
	ElseIf $IS = False Then
		OCInventory(False)
		Return False
	EndIf
EndFunc   ;==>InspectFishingrod

Func SwapFishingrod($discard = False)
	Local Const $InvS[3] = [1528, 350, 48] ; X,Y,OFFSET
	Local $x, $y, $IS = False
	Local $Fishingrods[5] = ["res/rod_default.bmp", "res/rod_balenos.bmp", "res/rod_calpheon.bmp", "res/rod_epheria.bmp", "res/rod_mediah.bmp"]

	OCInventory(False)
	Local $InvA = OCInventory(True)
	If IsArray($InvA) = False Then Return False

	For $L = 0 To 2 Step 1
		If MouseGetPos(0) >= $InvA[0] And MouseGetPos(0) <= $InvA[0] + 500 And MouseGetPos(1) >= $InvA[1] And MouseGetPos(1) <= $InvA[1] + 500 Then MouseMove($InvA[0] - 50, $InvA[1]) ; Keep mouse out of detection range
		For $j = 0 To 7 Step 1
			For $i = 0 To 7 Step 1
				For $k = 0 To UBound($Fishingrods) - 1 Step 1
					$IS = _ImageSearchArea($Fishingrods[$k], 0, $InvA[0] + $i * 48, $InvA[1] - 24 + $j * 48, $InvA[0] + 48 + $i * 48, $InvA[1] + 24 + $j * 48, $x, $y, 10, 0)
					If $IS = True Then
						MouseMove($InvA[0] + $i * 48, $InvA[1] + $j * 48)
						Sleep(50)
						MouseClick("right", $InvA[0] + 10 + $i * 48, $InvA[1] + $j * 48)
						SetGUIStatus("Fishingrod equipped from position " & $j & ", " & $i)
						If $discard = True Then DiscardEmptyRod()
						OCInventory(False)
						Return True
					EndIf
				Next
			Next
		Next
		If $L < 2 Then
			MouseMove($InvA[0] +8, $InvA[1])
			Sleep(50)
			For $mw = 0 To 7
			MouseWheel("down")
			Next
		EndIf
		Sleep(150)
	Next
	If $discard = True Then DiscardEmptyRod()
	OCInventory(False)
	Return False
EndFunc   ;==>SwapFishingrod

Func DiscardEmptyRod()
	Local Const $TrashCanOffset[2] = [360, 436] ; X,Y
	Local $x, $y, $IS = False
	Local $InvA = OCInventory(True)
	If IsArray($InvA) = False Then Return False
	If MouseGetPos(0) >= $InvA[0] And MouseGetPos(0) <= $InvA[0] + 500 And MouseGetPos(1) >= $InvA[1] And MouseGetPos(1) <= $InvA[1] + 500 Then MouseMove(10, 10) ; Keep mouse out of detection range
	For $j = 0 To 7 Step 1
		For $i = 0 To 7 Step 1
			$IS = _ImageSearchArea("res/rod_default_discard.bmp", 0, $InvA[0] + $i * 48, $InvA[1] - 24 + $j * 48, $InvA[0] + 48 + $i * 48, $InvA[1] + 24 + $j * 48, $x, $y, 20, 0)
			If $IS = True Then
				MouseMove($InvA[0] + $i * 48, $InvA[1] + $j * 48)
				Sleep(150)
				MouseClickDrag("left", $InvA[0] + 10 + $i * 48, $InvA[1] + $j * 48, $InvA[0] + 100 + $i * 48, $InvA[1] + $j * 48, 500)
				MouseMove($InvA[0] + $TrashCanOffset[0], $InvA[1] + $TrashCanOffset[1])
				MouseClick("left", $InvA[0] + $TrashCanOffset[0], $InvA[1] + $TrashCanOffset[1])
				Sleep(350)
				CoSe("{SPACE}")
				Sleep(200)
				OCInventory(False)
				Return True
			EndIf
		Next
	Next
	OCInventory(False)
	Return False
EndFunc   ;==>DiscardEmptyRod

Func Cast()
	Local Static $FishingCurrently = StringSplit(StringStripWS(IniRead("config/resolution_settings.ini", "Fishing", "FishingCurrently", "642, 60, 1256, 64, 0xE4E4E4"), 8), ",", 2) ; FishingCurrently
	If Buff($Bufftimer) = True Then $Bufftimer = TimerInit()
	If FeedWorker($FeedWorkertimer) = True Then $FeedWorkertimer = TimerInit()

	SetGUIStatus("Casting Fishingrod")
	Sleep(1000)
	CoSe("{SPACE}")

	$timer = TimerInit()
	While DetectState($FishingCurrently) = False And $Fish
		Sleep(500)
		If TimerDiff($timer) / 1000 >= 8 Then Return False
	WEnd
	Return True
EndFunc   ;==>Cast

#EndRegion - Fishing

#Region - Loot

Func DocLoot(ByRef $Loot)

	Local $TotalStats = IniReadSection("config/stats.ini", "TotalStats")
	Local $SessionStats = IniReadSection("config/stats.ini", "SessionStats")
	For $j = 0 To 8 Step 1
		_GUICtrlListView_SetItemSelected($ListView1, $j, False, False)
	Next

	For $i = 0 To UBound($Loot) - 1 Step 1
		Switch $Loot[$i][0]
			Case -1 ; Trash
				$TotalStats[9][1] += 1
				$SessionStats[9][1] += 1
				_GUICtrlListView_SetItemSelected($ListView1, 8, True, True)
			Case 0 ; White
				$TotalStats[1][1] += 1
				$SessionStats[1][1] += 1
				_GUICtrlListView_SetItemSelected($ListView1, 0, True, True)
			Case 1 ; Green
				$TotalStats[2][1] += 1
				$SessionStats[2][1] += 1
				_GUICtrlListView_SetItemSelected($ListView1, 1, True, True)
			Case 2 ; Blue
				$TotalStats[3][1] += 1
				$SessionStats[3][1] += 1
				_GUICtrlListView_SetItemSelected($ListView1, 2, True, True)
			Case 3 ; Gold
				$TotalStats[4][1] += 1
				$SessionStats[4][1] += 1
				_GUICtrlListView_SetItemSelected($ListView1, 3, True, True)
		EndSwitch

		Switch $Loot[$i][1]
			Case 1 ; Silverkey
				$TotalStats[5][1] += 1
				$SessionStats[5][1] += 1
				_GUICtrlListView_SetItemSelected($ListView1, 4, True, True)
			Case 2 ; AncientRelic
				$TotalStats[6][1] += 1
				$SessionStats[6][1] += 1
				_GUICtrlListView_SetItemSelected($ListView1, 5, True, True)
			Case 3 ; Coelacanth
				$TotalStats[7][1] += 1
				$SessionStats[7][1] += 1
				_GUICtrlListView_SetItemSelected($ListView1, 6, True, True)
		EndSwitch

		If $Loot[$i][2] > 0 Then ; Event items
			$TotalStats[8][1] += 1
			$SessionStats[8][1] += 1
			_GUICtrlListView_SetItemSelected($ListView1, 7, True, True)
		EndIf
	Next
	IniWriteSection("config/stats.ini", "TotalStats", $TotalStats)
	IniWriteSection("config/stats.ini", "SessionStats", $SessionStats)

	GUICtrlSetData($ListView1_0, $SessionStats[1][0] & "|" & $SessionStats[1][1] & "|" & $TotalStats[1][1], "")
	GUICtrlSetData($ListView1_1, $SessionStats[2][0] & "|" & $SessionStats[2][1] & "|" & $TotalStats[2][1], "")
	GUICtrlSetData($ListView1_2, $SessionStats[3][0] & "|" & $SessionStats[3][1] & "|" & $TotalStats[3][1], "")
	GUICtrlSetData($ListView1_3, $SessionStats[4][0] & "|" & $SessionStats[4][1] & "|" & $TotalStats[4][1], "")
	GUICtrlSetData($ListView1_4, $SessionStats[5][0] & "|" & $SessionStats[5][1] & "|" & $TotalStats[5][1], "")
	GUICtrlSetData($ListView1_5, $SessionStats[6][0] & "|" & $SessionStats[6][1] & "|" & $TotalStats[6][1], "")
	GUICtrlSetData($ListView1_6, $SessionStats[7][0] & "|" & $SessionStats[7][1] & "|" & $TotalStats[7][1], "")
	GUICtrlSetData($ListView1_7, $SessionStats[8][0] & "|" & $SessionStats[8][1] & "|" & $TotalStats[8][1], "")
	GUICtrlSetData($ListView1_8, $SessionStats[9][0] & "|" & $SessionStats[9][1] & "|" & $TotalStats[9][1], "")
EndFunc   ;==>DocLoot

Func DetectLoot()
	Local Const $Rarity[4] = ["", 4486950, 3966379, 10651464] ; Green, Blue, Gold
	Local Const $SpecialLootIdentifier[4] = ["res/loot_quantity.bmp", "res/loot_silverkey.bmp", "res/loot_ancientrelic.bmp", "res/loot_coelacanth.bmp"]
	Local Static $EventIdentifier = _FileListToArray("res/event/", "*", 0)
	Local Static $IgnoreIdentifier = _FileListToArray("res/ignore/", "*", 0)
	Local Static $LootWindow = StringSplit(StringStripWS(IniRead("config/resolution_settings.ini", "Fishing", "LootWindow", "1538, 594, 1540, 638, 46"), 8), ",", 2) ; LootWindow left, top, right, bottom, offset
	Local $LW[5] = [$LootWindow[0] + $ResOffset[0], $LootWindow[1] + $ResOffset[1], $LootWindow[2] + $ResOffset[0], $LootWindow[3] + $ResOffset[1], $LootWindow[4]] ; Adding offset for windowed mode

	Local $Loot[4][3] = [[0, 0, 0], [0, 0, 0], [0, 0, 0], [0, 0, 0]]
	Local $FF, $x, $y, $SSN = 1

	For $j = 0 To 3 Step 1
		For $i = 1 To UBound($Rarity) - 1 Step 1
			$FF = FFColorCount($Rarity[$i], 10, True, $LW[0] + $LW[4] * $j, $LW[1], $LW[2] + $LW[4] * $j, $LW[3], $SSN)
			If $FF > 10 Then
				$Loot[$j][0] = $i
			EndIf
		Next
		If $Loot[$j][0] = 0 Then
			$IS = _ImageSearchArea("res/reference_empty.bmp", 0, $LW[0] + $LW[4] * $j, $LW[1], $LW[2] + 44 + $LW[4] * $j, $LW[3], $x, $y, 50, 0)
			If $IS Then
				$Loot[$j][0] = -2
			Else
				$IS = _ImageSearchArea($SpecialLootIdentifier[0], 0, $LW[0] + $LW[4] * $j, $LW[1], $LW[2] + 44 + $LW[4] * $j, $LW[3], $x, $y, 40, 0)
				If $IS Then $Loot[$j][0] = -1
			EndIf
		EndIf
		For $i = 1 To UBound($SpecialLootIdentifier) - 1 Step 1
			If _ImageSearchArea($SpecialLootIdentifier[$i], 0, $LW[0] + $LW[4] * $j, $LW[1], $LW[2] + 44 + $LW[4] * $j, $LW[3], $x, $y, 20, 0) = 1 Then
				$Loot[$j][1] = $i
			EndIf
		Next
		For $i = 1 To UBound($EventIdentifier) - 1 Step 1
			If _ImageSearchArea("res/event/" & $EventIdentifier[$i], 0, $LW[0] + $LW[4] * $j, $LW[1], $LW[2] + 44 + $LW[4] * $j, $LW[3], $x, $y, 25, 0) = 1 Then
				$Loot[$j][2] = $i
			EndIf
		Next
		For $i = 1 To UBound($IgnoreIdentifier) - 1 Step 1
			If _ImageSearchArea("res/ignore/" & $IgnoreIdentifier[$i], 0, $LW[0] + $LW[4] * $j, $LW[1], $LW[2] + 44 + $LW[4] * $j, $LW[3], $x, $y, 25, 0) = 1 Then
				$Loot[$j][2] = -$i
			EndIf
		Next
	Next


	Local $CWLoot = "Loot:"

	For $j = 0 To UBound($Loot, 1) - 1 Step 1
		$CWLoot &= "["
		For $i = 0 To UBound($Loot, 2) - 1 Step 1
			$CWLoot &= $Loot[$j][$i]
		Next
		$CWLoot &= "]"
	Next
	SetGUIStatus($CWLoot)

	Return $Loot
EndFunc   ;==>DetectLoot

Func HandleLoot($Reserve = 0)
	Local $Loot = DetectLoot()
	Local $Pick[4] = [0, 0, 0, 0]
	Local Static $LootWindow = StringSplit(StringStripWS(IniRead("config/resolution_settings.ini", "Fishing", "LootWindow", "1538, 594, 1540, 638, 46"), 8), ",", 2) ; LootWindow left, top, right, bottom, offset
	Local $LW[5] = [$LootWindow[0] + $ResOffset[0], $LootWindow[1] + $ResOffset[1], $LootWindow[2] + $ResOffset[0], $LootWindow[3] + $ResOffset[1], $LootWindow[4]] ; Adding offset for windowed mode
	Local $LootSettings = IniReadSection("config/data.ini", "LootSettings")
	Local $PickedLoot = Int(IniRead("config/data.ini", "CurrentStats", "PickedLoot", 0))
	Local $Threshold = 0
	If $Reserve = 1 Then $Threshold = 20

	DocLoot($Loot)
	For $j = 0 To 3 Step 1
		If $Loot[$j][0] >= Int($LootSettings[1][1]) Then
			$Pick[$j] += 10 ; Rarity
		Else
			If $Loot[$j][0] = -1 And Int($LootSettings[6][1]) = 1 Then $Pick[$j] += 1 ; Trash
		EndIf
		Switch $Loot[$j][1]
			Case 1 ; Silverkey
				If Int($LootSettings[2][1]) Then $Pick[$j] += 1
			Case 2 ; Ancient Relic
				If Int($LootSettings[3][1]) Then $Pick[$j] += 30
			Case 3 ; Coelacanth
				If Int($LootSettings[4][1]) Then $Pick[$j] += 20
		EndSwitch
		If $Loot[$j][2] > 0 And Int($LootSettings[5][1]) Then $Pick[$j] += 1 ; Event items
		If $Loot[$j][2] < 0 Then $Pick[$j] = 0 ; ignore items
	Next

	SetGUIStatus("Pick:[" & $Pick[0] & "][" & $Pick[1] & "][" & $Pick[2] & "][" & $Pick[3] & "]")
	If $Reserve = 1 Then SetGUIStatus("Relic Reserve reached. Picks below 20 will be ignored.")
	For $j = 3 To 0 Step -1
		If $Pick[$j] > $Threshold Then
			If Int($LootSettings[7][1]) = 0 Then
				If Not VisibleCursor() Then CoSe("{LCTRL}")
				Sleep(50)
				If Mod($Pick[$j], 2) = 0 Then $PickedLoot += 1
				MouseMove($LW[0] + 20 + $LW[4] * $j, $LW[1] + 20)
				Sleep(50)
				MouseClick("right", $LW[0] + 20 + $LW[4] * $j, $LW[1] + 20, 1)
				Sleep(50)
				If VisibleCursor() Then CoSe("{LCTRL}")
				Sleep(50)
			Else
				CoSe("r")
				ExitLoop
			EndIf
		EndIf
	Next
	SetGUIInventory($PickedLoot)

	Return $PickedLoot
EndFunc   ;==>HandleLoot
#EndRegion - Loot

#Region - Fishing Misc
Func Buff($timer)
	Local $FoodSettings = IniReadSection("config/data.ini", "FoodSettings")
	If $FoodSettings[1][1] = 1 And TimerDiff($timer) / 1000 / 60 > Int($FoodSettings[3][1]) Then
		SetGUIStatus("Using Buff Food")
		CoSe($FoodSettings[2][1])
		For $i = 4 To UBound($FoodSettings) - 1
			CoSe($FoodSettings[$i][1])
		Next
		Return True
	EndIf
	Return False
EndFunc   ;==>Buff

Func FeedWorker($timer)

	Local Const $WorkerIcon = "res/esc_worker.bmp"
	Local $WorkerSettings = IniReadSection("config/data.ini", "WorkerSettings")
	Local Static $WorkerListPosition = StringSplit(StringStripWS(IniRead("config/resolution_settings.ini", "WorkerSettings", "WorkerListPosition", "899, 294"), 8), ",", 2)
	Local $WLP[2] = [$WorkerListPosition[0] + $ResOffset[0], $WorkerListPosition[1] + $ResOffset[1]]
	Local $WorkerCD = Int($WorkerSettings[2][1]) * 60 * 1000
	Local Const $WorkerOffsets[5][2] = [ _
		    [0, -110], _ ; Drag window
			[-60, 430], _ ;Recover All
			[-365, -44], _ ; Select food
			[-305, 110], _ ;Confirm
			[1, 430]] ; Repeat All
	Local $x, $y, $IS

	If $WorkerSettings[1][1] = 1 And TimerDiff($timer) > $WorkerCD Then
		SetGUIStatus("Feeding Worker")
		WaitForMenu(True)
		$IS = _ImageSearchArea($WorkerIcon, 1, $ResOffset[0], $ResOffset[1], $ResOffset[2], $ResOffset[3], $x, $y, 50, 0)
		MouseClick("left", $x, $y)

		MouseClickDrag("left", $WLP[0], $WLP[1], $WLP[0] + $WorkerOffsets[0][0], $WLP[1] + $WorkerOffsets[0][1])
		MouseClick("left", $WLP[0] + $WorkerOffsets[1][0], $WLP[1] + $WorkerOffsets[1][1])
		MouseClick("left", $WLP[0] + $WorkerOffsets[2][0], $WLP[1] + $WorkerOffsets[2][1])
		Sleep(50)
		MouseClick("left", $WLP[0] + $WorkerOffsets[3][0], $WLP[1] + $WorkerOffsets[3][1])
		Sleep(550)
		MouseClick("left", $WLP[0] + $WorkerOffsets[4][0], $WLP[1] + $WorkerOffsets[4][1])
		CoSe("{ESC}")
		SetGUIStatus("Feeding Worker CD: " & $WorkerSettings[2][1])
		Return True
	EndIf
	Return False
EndFunc   ;==>FeedWorker

Func FeedWorkerTest() ;TODO
	Local $FWTimer
	$ResOffset = DetectFullscreenToWindowedOffset()
	FeedWorker($FWTimer)
EndFunc   ;==>FeedWorkerTest

Func FeedWorkerLoop()
	$WorkerFeeding = Not $WorkerFeeding
	If $WorkerFeeding = False Then Return False


	$ResOffset = DetectFullscreenToWindowedOffset()
	$FeedWorkertimer = TimerInit()
	SetGUIStatus("Started FeedWorkerLoop")
	While $WorkerFeeding
		GUILoopSwitch()
		If FeedWorker($FeedWorkertimer) = True Then $FeedWorkertimer = TimerInit()
	WEnd
	SetGUIStatus("Stopped FeedWorkerLoop")
EndFunc   ;==>FeedWorkerLoop

Func HandleDryFish($dryingenabled = 0)
	Local $timer = TimerInit()
	If $dryingenabled > 0 Then
		$Fish = True
		SetGUIStatus("Drying enabled")
		If TimerDiff($DryFishCooldownTimer) / 1000 / 60 < 5 Then
			SetGUIStatus("Drying on Cooldown. " & Round(TimerDiff($DryFishCooldownTimer) / 1000 / 60, 1) & "m ago")
			Return False
		EndIf
		For $i = 0 To 10
			$DryFishCooldownTimer = TimerInit()
			Switch DryFish()
				Case -1 ; Processing failed
					ExitLoop
				Case 0 ; Wrong weather
					While $Fish
						SetGUIStatus("Waiting for clear weather to dry (" & Round(TimerDiff($timer) / 1000, 0) & "s)")
						If DryFish() <> 0 Or TimerDiff($timer) / 1000 / 60 > 15 Then ExitLoop
						Sleep(1000)
					WEnd
				Case 1 ; Completed one cycle
					SetGUIStatus("Processing completed")
				Case 2 ; No fish meets requirements
					$freedetectedslots = DetectFreeInventory()
					SetGUIInventory(0)
					Return $freedetectedslots
			EndSwitch
		Next
		Return False
	EndIf
EndFunc   ;==>HandleDryFish

Func DryFish()
	Local $DryingSettings = IniReadSection("config/data.ini", "DryingSettings")
	Local $weather = "res/weather_clear.bmp"
	Local Const $processing[4] = ["res/reference_highlight.bmp", "res/processing_check.bmp", "res/processing_activity.bmp", "res/processing_hammer.bmp"]
	Local Const $Rarity[4] = ["", 7184194, 6596799, 13742692] ; Green, Blue, Gold
	Local $DryingOffset[3][2] = [ _
			[189, -61], _ ; Dry Fish
			[256, -294], _ ; Start
			[195, -328]] ; Process all identical

	Local $IS, $x, $y, $xs, $ys, $FF, $SSN = 1
	Local $timer = TimerInit()
	Local $detectedrarity = 0
	Local $FFmean[3]
	$IS = _ImageSearchArea($weather, 1, $ResOffset[2] - 350, $ResOffset[1], $ResOffset[2], $ResOffset[1] + 100, $x, $y, 50, 0)
	If $IS = True Then
		SetGUIStatus("Clear weather: " & $IS)
		$IS = _ImageSearchArea($processing[3], 1, $ResOffset[0], $ResOffset[1], $ResOffset[2], $ResOffset[3], $x, $y, 50, 0)
		SetGUIStatus("Processing open: " & $IS)
		If Not $IS Then
			CoSe("l")
			Sleep(500)
		Else
			CoSe("l")
			CoSe("l")
			Sleep(500)
		EndIf
		$IS = _ImageSearchArea($processing[3], 1, $ResOffset[0], $ResOffset[1], $ResOffset[2], $ResOffset[3], $x, $y, 50, 0)
		SetGUIStatus("Processing open: " & $IS)
		If Not $IS Then
			UnequipRod()
			CoSe("l")
			Sleep(500)
		EndIf
		$IS = _ImageSearchArea($processing[3], 1, $ResOffset[0], $ResOffset[1], $ResOffset[2], $ResOffset[3], $x, $y, 50, 0)
		If $IS = False Then
			Return False
		Else
			SetGUIStatus("Processing open: " & $IS & " Setting anchor")
			$xs = $x
			$ys = $y
		EndIf
		Sleep(250)
		MouseClick("left", $xs + $DryingOffset[0][0], $ys + $DryingOffset[0][1]) ; Dry Fish
		Local $InvA = OCInventory(True)
		If IsArray($InvA) = False Then Return False
		Sleep(500)
		MouseClick("Left", $InvA[0] + 48 * 8, $InvA[1])
		For $L = 0 To 2 Step 1
			If MouseGetPos(0) >= $InvA[0] And MouseGetPos(0) <= $InvA[0] + 500 And MouseGetPos(1) >= $InvA[1] And MouseGetPos(1) <= $InvA[1] + 500 Then MouseMove($InvA[0] - 50, $InvA[1]) ; Keep mouse out of detection range
			For $j = 0 To 7 Step 1
				For $i = 0 To 7 Step 1
					$IS = _ImageSearchArea($processing[0], 0, $InvA[0] + $i * 48, $InvA[1] - 24 + $j * 48, $InvA[0] + 2 + $i * 48, $InvA[1] + 24 + $j * 48, $x, $y, 55, 0) ; looking for highlighted items
					If $IS Then
						SetGUIStatus("dryable fish [" & $L & $j & $i & "]")
						For $k = $DryingSettings[2][1] To UBound($Rarity) - 1 Step 1
							$FF = FFColorCount($Rarity[$k], 18, True, $InvA[0] + $i * 48, $InvA[1] - 15 + $j * 48, $InvA[0] + 1 + $i * 48, $InvA[1] + 15 + $j * 48, $SSN)
							If $FF > 10 Then
								$detectedrarity = $k
								SetGUIStatus("Rarity detected: " & $k & " Filter: <=" & $DryingSettings[2][1])
								If $k > Int($DryingSettings[2][1]) Then
									SetGUIStatus("Rarity too high")
									ExitLoop (2)
								EndIf
							EndIf
						Next
						If $detectedrarity = 0 Then SetGUIStatus("Rarity detected: " & $detectedrarity & " Filter: " & $DryingSettings[2][1])
						SetGUIStatus("Select fish.")
						Sleep(250)
						MouseClick("right", $InvA[0] + 10 + $i * 48, $InvA[1] + $j * 48, 2)
						Sleep(250)
						MouseClick("left", $xs + $DryingOffset[2][0] + 50, $ys + $DryingOffset[2][1]) ; Process all identical
						Sleep(100)
						$IS = _ImageSearchArea($processing[1], 0, $xs + $DryingOffset[2][0] - 10, $ys + $DryingOffset[2][1] - 10, $xs + $DryingOffset[2][0] + 10, $ys + $DryingOffset[2][1] + 10, $x, $y, 50, 0) ; Process all identical items?
						SetGUIStatus("Process identical items: " & $IS)
						MouseClick("left", $xs + $DryingOffset[1][0], $ys + $DryingOffset[1][1]) ; Start
						Sleep(100)
						If $IS = True Then CoSe("{SPACE}")
						Sleep(100)
						SetGUIStatus("Waiting for drying process to end")
						If Not ProductionActivityCheck() Then
							SetGUIStatus("Processing failed")
							Return -1
						EndIf
						SetGUIStatus("Processing stopped")
						Return 1
					Else
						SetGUIStatus("not dryable [" & $L & $j & $i & "]")
					EndIf
				Next
			Next
			If $L < 2 Then
				MouseMove($InvA[0] +8, $InvA[1])
				Sleep(50)
				For $mw = 0 To 7
				MouseWheel("down")
				Next
				Sleep(150)
			EndIf
			Sleep(150)
		Next
		SetGUIStatus("Inventory scan complete")
		Return 2
	Else
		Return 0
	EndIf
EndFunc   ;==>DryFish

Func ProductionActivityCheck()
	Local Const $processing = "res/processing_hammer.bmp"
	Local $IS, $x, $y
	Sleep(2000)
	$IS = _ImageSearchArea($processing, 1, $ResOffset[0], $ResOffset[1], $ResOffset[2], $ResOffset[3], $x, $y, 50, 0)
	If $IS = True Then Return False
	While $Fish Or $Processing
		$IS = _ImageSearchArea($processing, 1, $ResOffset[0], $ResOffset[1], $ResOffset[2], $ResOffset[3], $x, $y, 50, 0)
		If $IS = True Then Return True
		CoSe("l") ; reopen incase of interupt
		Sleep(1500)
		$IS = _ImageSearchArea($processing, 1, $ResOffset[0], $ResOffset[1], $ResOffset[2], $ResOffset[3], $x, $y, 50, 0)
		If $IS = True Then Return True
		Sleep(6500)
	WEnd
	Return False
EndFunc   ;==>ProductionActivityCheck

Func DetectFreeInventory()
	Local $Free, $IS, $x, $y
	SetGUIStatus("Detecting free inventory space")
	OCInventory(False)
	Local $InvA = OCInventory(True)
	If IsArray($InvA) = False Then Return False
	For $L = 0 To 2 Step 1
		If MouseGetPos(0) >= $InvA[0] And MouseGetPos(0) <= $InvA[0] + 500 And MouseGetPos(1) >= $InvA[1] And MouseGetPos(1) <= $InvA[1] + 500 Then MouseMove($InvA[0] - 50, $InvA[1]) ; Keep mouse out of detection range
		For $j = 0 To 7 Step 1
			For $i = 0 To 7 Step 1
				$IS = _ImageSearchArea("res/reference_empty.bmp", 0, $InvA[0] + $i * 48, $InvA[1] - 24 + $j * 48, $InvA[0] + 48 + $i * 48, $InvA[1] + 24 + $j * 48, $x, $y, 20, 0)
				If $IS Then
					$Free += 1
				EndIf
			Next
		Next
		If $L < 2 Then
			MouseMove($InvA[0] +8, $InvA[1])
			Sleep(50)
			For $mw = 0 To 7
			MouseWheel("down")
			Next
		EndIf
		Sleep(150)
	Next
	OCInventory(False)
	SetGUIStatus($Free & " empty slots")
	Return ($Free)
EndFunc   ;==>DetectFreeInventory

Func Turn()
	MouseMove(MouseGetPos(0) + 500, MouseGetPos(1))
	CoSe("ad")
EndFunc   ;==>Turn

Func DesertDebuff()
	$Digging = Not $Digging
	If $Digging = False Then Return False

	Local $x, $y, $IS
	Local Const $HeatStroke = "res/desert_stroke.bmp"
	Local Const $Hypothermia = "res/desert_hypothermia.bmp"
	Local $DesertSettings = IniReadSection("config/data.ini", "DiggingSettings")
	$ResOffset = DetectFullscreenToWindowedOffset()
	Local Static $LootWindow = StringSplit(StringStripWS(IniRead("config/resolution_settings.ini", "Fishing", "LootWindow", "1538, 594, 1540, 638, 46"), 8), ",", 2) ; LootWindow left, top, right, bottom, offset
	Local $LW[5] = [$LootWindow[0] + $ResOffset[0], $LootWindow[1] + $ResOffset[1], $LootWindow[2] + $ResOffset[0], $LootWindow[3] + $ResOffset[1], $LootWindow[4]] ; Adding offset for windowed mode




	Local $timer, $desertbufftimer = TimerInit()
	Local $shovelcd = Int($DesertSettings[5][1]) * 1000

	While $Digging
		SetGUIStatus("Waiting for Desert Debuff")
		GUILoopSwitch()
		$IS = _ImageSearchArea($HeatStroke, 0, $ResOffset[0], $ResOffset[1], $ResOffset[2], $ResOffset[3], $x, $y, 30, 0)
		If $IS = True Then
			SetGUIStatus("HeatStroke detected")
			CoSe($DesertSettings[1][1]) ; PurifiedLiquid
			CoSe($DesertSettings[3][1]) ; HPPotion
		EndIf
		$IS = _ImageSearchArea($Hypothermia, 0, $ResOffset[0], $ResOffset[1], $ResOffset[2], $ResOffset[3], $x, $y, 30, 0)
		If $IS = True Then
			SetGUIStatus("Hypothermia detected")
			CoSe($DesertSettings[2][1]) ; StarAniseTea
			CoSe($DesertSettings[3][1]) ; HPPotion
		EndIf
		If $shovelcd > 0 Then ; If timer = 0 then use lootwindow detection
			If TimerDiff($timer) > $shovelcd Then
				SetGUIStatus("Using shovel")
				CoSe($DesertSettings[4][1]) ; Shovel
				$timer = TimerInit()
			EndIf
		Else
			For $j = 0 To 3
				$IS = _ImageSearchArea("res/reference_empty.bmp", 0, $LW[0] + $LW[4] * $j, $LW[1], $LW[2] + 44 + $LW[4] * $j, $LW[3], $x, $y, 50, 0)
				If $IS = True Then
					SetGUIStatus("LootWindow detected. Using shovel.")
					CoSe($DesertSettings[4][1]) ; Shovel
					ExitLoop
				EndIf
			Next
		EndIf


		If $DesertSettings[5][1] Then
			If Buff($desertbufftimer) = True Then $desertbufftimer = TimerInit()
		EndIf
	WEnd
	SetGUIStatus("Stopped Digging")
EndFunc   ;==>DesertDebuff

Func Milking()
	$Milking = Not $Milking
	If $Milking = False Then Return False

	Local $x, $y, $IS
	Local Const $Milk[4] = ["res/milk_right.bmp", "res/milk_left.bmp", "res/milk_startL.bmp", "res/milk_startR.bmp"]
	Local $CowCDIni = Int(IniRead("config/data.ini", "MilkingSettings", "MilkCD", 0))
	$ResOffset = DetectFullscreenToWindowedOffset()
	Local $statustimer = TimerInit()
	Local $CowCDtimer = TimerInit()
	Local $CowCD = $CowCDIni * 1000

	SetGUIStatus("Ready for milking. Talk to a cow. (CD: " & $CowCDIni & ")")
	While $Milking
		GUILoopSwitch()
		Sleep(50)
		$IS = _ImageSearchArea($Milk[0], 0, $ResOffset[0], $ResOffset[1], $ResOffset[2], $ResOffset[3], $x, $y, 40, 0)
		If $IS = True Then
			If VisibleCursor() = True Then CoSe("{LCTRL}")
			SetGUIStatus("milk RIGHT")
			MouseDown("right")
			Sleep(120)
			MouseUp("right")
			$statustimer = TimerInit()
			ContinueLoop
		EndIf
		$IS = _ImageSearchArea($Milk[1], 0, $ResOffset[0], $ResOffset[1], $ResOffset[2], $ResOffset[3], $x, $y, 40, 0)
		If $IS = True Then
			If VisibleCursor() = True Then CoSe("{LCTRL}")
			SetGUIStatus("milk LEFT")
			MouseDown("left")
			Sleep(120)
			MouseUp("left")
			$statustimer = TimerInit()
			ContinueLoop
		EndIf
		$IS = _ImageSearchArea($Milk[2], 0, $ResOffset[0], $ResOffset[1], $ResOffset[2], $ResOffset[3], $x, $y, 20, 0)
		If $IS = True Then
			$IS = _ImageSearchArea($Milk[3], 0, $ResOffset[0], $ResOffset[1], $ResOffset[2], $ResOffset[3], $x, $y, 20, 0)
			If $IS = True Then
				If VisibleCursor() = True Then CoSe("{LCTRL}")
				SetGUIStatus("Start Milking")
				MouseClick("left")
				$statustimer = TimerInit()
				Sleep(100)
				ContinueLoop
			EndIf
		EndIf
		If TimerDiff($statustimer) > 2000 Then SetGUIStatus("Ready for milking. Talk to a cow.")
		If TimerDiff($CowCDtimer) > $CowCD And $CowCD > 0 Then
			SetGUIStatus("Milking Cooldoown over. Pressing R.")
			CoSe("r")
			Sleep(2000)
			$CowCDtimer = TimerInit()
		EndIf
	WEnd
	SetGUIStatus("Stopped Milking")
EndFunc   ;==>Milking

Func HandleRewardSpam()
	Local $x, $y, $IS
	Local Static $FailCounter = 0
	Local $RewardSpam = "res/daily_rewardspam.bmp"
	SetGUIStatus("Checking for daily reward spam")
	$IS = _ImageSearchArea($RewardSpam, 1, $ResOffset[0], $ResOffset[1], $ResOffset[2], $ResOffset[3], $x, $y, 50, 0)
	If $IS = True Then
		SetGUIStatus("Spam found. Escaping.")
		WaitForMenu(False)
	Else
		$FailCounter += 1
		If Mod($FailCounter, 3) = 0 Then
			SetGUIStatus("No Spam. Something else is fishy. Escaping anyway.")
			WaitForMenu(False)
		EndIf
		SetGUIStatus("No Spam. Something else is fishy.")
	EndIf
EndFunc   ;==>HandleRewardSpam

#EndRegion - Fishing Misc

#Region - Restock
Func UnequipRod()
	Local $WeaponOffSet[2] = [-286, 256]
	SetGUIStatus("Unequipping fishingrod")
	OCInventory(False)
	Local $InvA = OCInventory(True)
	If IsArray($InvA) = False Then Return False
	MouseClick("right", $InvA[0] + $WeaponOffSet[0], $InvA[1] + $WeaponOffSet[1])
	OCInventory(False)
	Return True
EndFunc   ;==>UnequipRod

Func TrackNPC($npcname)
	Local Static $NPCSearchIconIni = StringSplit(StringStripWS(IniRead("config/resolution_settings.ini", "Restock", "NPCSearchIcon", "1556, 30"), 8), ",", 2) ; x, y
	Local $NPCSearchIcon[2] = [$NPCSearchIconIni[0] + $ResOffset[0], $NPCSearchIconIni[1] + $ResOffset[1]]
	Local Const $Selected = 8960468
	Local Const $NPCs[4] = ["res/npc_bank.bmp", "res/npc_repair.bmp", "res/npc_trade.bmp", "res/npc_broker.bmp"]
	Local Const $Offset[2] = [515, 345]
	Local $FF, $x, $y, $IS, $counter = 3, $SSN = 1

	While $Fish
		UnequipRod()
		If Not VisibleCursor() Then CoSe("{LCTRL}")
		Sleep(250)
		MouseClick("left", $NPCSearchIcon[0], $NPCSearchIcon[1])
		Sleep(500)

		$IS = _ImageSearchArea($NPCs[1], 1, $ResOffset[0], $ResOffset[1], $ResOffset[2], $ResOffset[3], $x, $y, 60, 0)
		If $IS = True Then
			MouseMove($x, $y + $Offset[0])
			MouseClick("left", $x, $y + $Offset[0])
			Sleep(250)
			Send($npcname) ; Send instead of CoSe because of trouble with > key
			CoSe("{ENTER}")
			For $i = 0 To 2 Step 1
				Sleep(100)
				MouseClick("left", $x, $y + $Offset[1])
				Sleep(250)
				$FF = FFColorCount($Selected, 30, True, $x - 40, $y + $Offset[1] - 10, $x + 80, $y + $Offset[1] + 10, $SSN) ; Check if the text is highlighted
				If $FF > 4 Then
					CoSe("t")
					Sleep(50)
					ExitLoop
				EndIf
			Next
			CoSe("{ESC}")
			If VisibleCursor() Then CoSe("{LCTRL}")
			Return True
		Else
			$counter -= 1
			If $counter <= 0 Then Return False
		EndIf
	WEnd
EndFunc   ;==>TrackNPC

Func NearbyNPC($npc_type) ; 0 = bank, 1 = repair, 2 = trader, 3 = broker
	Local Static $NPCSearchIcon = StringSplit(StringStripWS(IniRead("config/resolution_settings.ini", "Restock", "NPCSearchIcon", "1556, 30"), 8), ",", 2) ; x, y
	Local Const $NPCs[5] = ["res/npc_bank.bmp", "res/npc_repair.bmp", "res/npc_trade.bmp", "res/npc_broker.bmp", "res/npc_skillinstructor.bmp"]
	Local Const $Selected = 15983484
	Local $FF, $x, $y, $IS, $counter = 3, $SSN = 1, $retry = 3

	While $Fish
		UnequipRod()
		If Not VisibleCursor() Then CoSe("{LCTRL}")
		Sleep(250)
		MouseClick("left", $NPCSearchIcon[0] + $ResOffset[0], $NPCSearchIcon[1] + $ResOffset[1])
		Sleep(600)

		$IS = _ImageSearchArea($NPCs[$npc_type], 1, $ResOffset[0], $ResOffset[1], $ResOffset[2], $ResOffset[3], $x, $y, 55, 0)
		If $IS = True Then
			For $i = 0 To 2 Step 1
				MouseMove($x, $y)
				Sleep(50)
				MouseClick("left", $x, $y)
				Sleep(50)
				$FF = FFColorCount($Selected, 30, True, $x + 10, $y - 10, $x + 80, $y + 10, $SSN) ; Check if the text is yellow
				If $FF > 4 Then
					CoSe("t")
					Sleep(50)
					ExitLoop
				EndIf
			Next

			CoSe("{ESC}")
			If VisibleCursor() Then CoSe("{LCTRL}")
			Return True
		Else
			cw("NPC Icon not found")
			$counter -= 1
			Sleep(500)
			If $counter <= 0 Then Return False
		EndIf
	WEnd
EndFunc   ;==>NearbyNPC

Func MapMovement()
	Local Static $MapRegionIni = StringSplit(StringStripWS(IniRead("config/resolution_settings.ini", "Restock", "MapRegion", "1215, 48, 1230, 50"), 8), ",", 2) ; left, top, right, bottom
	Local $MapRegion[4] = [$MapRegionIni[0] + $ResOffset[0], $MapRegionIni[1] + $ResOffset[1], $MapRegionIni[2] + $ResOffset[0], $MapRegionIni[3] + $ResOffset[1]]
	Local $FF[6][2]
	Local $dif = 0, $SSN = 1
	Local $timer = TimerInit()
	Local $timeout = 240

	While TimerDiff($timer) / 1000 <= $timeout And $Fish
		SetGUIStatus("Autopathing... timeout in (" & $timeout - Round(TimerDiff($timer) / 1000, 0) & "s")
		Sleep(250)
		FFSnapShot($MapRegion[0], $MapRegion[1], $MapRegion[2], $MapRegion[3], $SSN)
		For $i = 0 To UBound($FF) - 1 Step 1
			$FF[$i][0] = FFGetPixel($MapRegion[0] + 2 * $i, $MapRegion[1], $SSN)
		Next
		Sleep(500)
		FFSnapShot($MapRegion[0], $MapRegion[1], $MapRegion[2], $MapRegion[3], $SSN)
		For $i = 0 To UBound($FF) - 1 Step 1
			$FF[$i][1] = FFGetPixel($MapRegion[0] + 2 * $i, $MapRegion[1], $SSN)
			If $FF[$i][0] = $FF[$i][1] Then $dif += 1
		Next
		If $dif >= 3 Then
			Return True
		Else
			$dif = 0
			Sleep(4000)
			MouseMove(MouseGetPos(0) + 10, MouseGetPos(1)) ; Stop Screensaver
			MouseMove(MouseGetPos(0) - 10, MouseGetPos(1))
			Sleep(1000)
		EndIf
	WEnd
	SetGUIStatus("Autopathing failed")
	Return False
EndFunc   ;==>MapMovement

Func NPCType($type, $npcname) ; bank, repair, trade, broker
	Local Const $NPCs[4][2] = [["res/npc_bank.bmp", "res/npc_bank_button.bmp"], ["res/npc_repair.bmp", "res/npc_repair_button.bmp"], ["res/npc_trade.bmp", "res/npc_trade_button.bmp"], ["res/npc_broker.bmp", "res/npc_broker_button.bmp"]]
	Local Const $ESC = "res/esc_worker.bmp"
	Local $IS, $x, $y, $SSN = 1, $counter = 10

	If $npcname <> "" Then
		TrackNPC($npcname)
	Else
		NearbyNPC($type)
	EndIf
	SetGUIStatus("Autopathing to NPCType: " & $type & " " & $npcname)
	MapMovement()
	While $counter >= 0 And $Fish = True
		CoSe("r") ; Talk to NPC
		Sleep(750)
		$IS = _ImageSearchArea($NPCs[$type][1], 1, $ResOffset[0], $ResOffset[1], $ResOffset[2], $ResOffset[3], $x, $y, 20, 0)
		If $IS = True Then ; Check for correct dialogue
			MouseClick("left", $x, $y, 2)
			Sleep(500)
			Return True
		Else
			; Close dialog and slowly pan camera to the right in case multiple npcs are overlapping
			CoSe("{ESC}")
			Sleep(500)
			$IS = _ImageSearchArea($ESC, 1, $ResOffset[0], $ResOffset[1], $ResOffset[2], $ResOffset[3], $x, $y, 20, 0)
			If $IS = True Then
				CoSe("{ESC}")
				Sleep(500)
			EndIf
			MouseMove(MouseGetPos(0) + 500, MouseGetPos(1), 50)
		EndIf
		$counter -= 1
		If $counter <= 0 Then Return False
	WEnd
EndFunc   ;==>NPCType


Func NPCProxy($npcname)
	If $npcname = "" Then Return False
	TrackNPC($npcname)
	SetGUIStatus("Autopathing to Proxy: " & $npcname)
	MapMovement()
	Return True
EndFunc   ;==>NPCProxy



Func BankRelics($npcname = "")
	Local Const $Relic = "res/loot_ancientrelic.bmp"
	Local Const $MoneyOffset[2] = [26, 447]
	Local $IS, $x, $y

	If NPCType(0, $npcname) = True Then
		SetGUIStatus("Storing Relics & Money.")
		Local $InvA = OCInventory(True)
		If IsArray($InvA) = False Then Return False
		For $k = 0 To 2 Step 1
			If MouseGetPos(0) >= $InvA[0] And MouseGetPos(0) <= $InvA[0] + 500 And MouseGetPos(1) >= $InvA[1] And MouseGetPos(1) <= $InvA[1] + 500 Then MouseMove($InvA[0] - 50, $InvA[1]) ; Keep mouse out of detection range
			For $i = 0 To 7 Step 1
				For $j = 0 To 7 Step 1
					$IS = _ImageSearchArea($Relic, 1, $InvA[0] + $i * 48, $InvA[1] - 24 + $j * 48, $InvA[0] + 48 + $i * 48, $InvA[1] + 24 + $j * 48, $x, $y, 20, 0)
					If $IS = True Then
						MouseClick("right", $x, $y, 2)
						$j -= 1
					EndIf
				Next
			Next
			If $k < 2 Then
				MouseMove($InvA[0] +8, $InvA[1])
				Sleep(50)
				For $mw = 0 To 7
				MouseWheel("down")
				Next
			EndIf
			Sleep(150)
		Next
		MouseClick("left", $InvA[0] + $MoneyOffset[0], $InvA[1] + $MoneyOffset[1], 2)
		Sleep(150)
		CoSe("f")
		CoSe("{SPACE}")
		Sleep(250)
		CoSe("{ESC}")
		CoSe("{ESC}")
		Return True
	Else
		Return False
		; TODO ERROR HANDLING
	EndIf
EndFunc   ;==>BankRelics

Func RepairInv($npcname = "")
	Local $x, $y, $IS
	Local Const $RepairInvenButton = "res/npc_repair_inven_button.bmp"

	If NPCType(1, $npcname) = True Then
		SetGUIStatus("Repairing.")
		$IS = _ImageSearchArea($RepairInvenButton, 1, $ResOffset[0], $ResOffset[1], $ResOffset[2], $ResOffset[3], $x, $y, 20, 0)
		$IS = _ImageSearchArea($RepairInvenButton, 1, $x + 100, $ResOffset[1], $ResOffset[2], $ResOffset[3], $x, $y, 20, 0) ; Workaround because of same icon
		MouseClick("left", $x, $y, 2)
		Sleep(250)
		CoSe("{SPACE}")
		Sleep(250)
		CoSe("{ESC}")
		CoSe("{ESC}")
		Return True
	Else
		Return False
		; TODO ERROR HANDLING
	EndIf
EndFunc   ;==>RepairInv

Func BrokerRelics($npcname = "")
	Local $InvS[3] = [1528, 350, 48] ; X,Y,OFFSET
	Local Const $Relic = "res/broker_ancientrelic.bmp"
	Local $x, $y, $IS
	Local Const $MyListingsButton = "res/npc_broker_mylistings_button.bmp"
	Local Const $RegisterItemButton = "res/npc_broker_registeritem_button.bmp"
	Local Const $CollectMoneyButton = "res/npc_broker_collectmoney_button.bmp"
	Local Const $ConfirmButton = "res/npc_broker_confirm_button.bmp"

	If NPCType(3, $npcname) = True Then
		SetGUIStatus("Auctioning Relics.")
		$IS = _ImageSearchArea($MyListingsButton, 1, $ResOffset[0], $ResOffset[1], $ResOffset[2], $ResOffset[3], $x, $y, 20, 0)
		MouseClick("left", $x, $y, 2)
		Sleep(500)


		For $i = 0 To 20 Step 1
			$IS = _ImageSearchArea($CollectMoneyButton, 1, $ResOffset[0], $ResOffset[1], $ResOffset[2], $ResOffset[3], $x, $y, 20, 0)
			If $IS = True Then
				MouseClick("left", $x, $y, 2)
				Sleep(250)
				CoSe("{SPACE}")
				MouseMove($ResOffset[0] + 30, $ResOffset[1] + 30)
				Sleep(500)
			EndIf
		Next



		$IS = _ImageSearchArea($RegisterItemButton, 0, $ResOffset[0], $ResOffset[1], $ResOffset[2], $ResOffset[3], $x, $y, 20, 0)
		MouseClick("left", $x, $y, 2)
		Sleep(500)
		MouseMove($ResOffset[0] + 30, $ResOffset[1] + 30)
		Local $InvA = OCInventory(True)
		If IsArray($InvA) = False Then Return False
		For $k = 0 To 2 Step 1
			If MouseGetPos(0) >= $InvA[0] And MouseGetPos(0) <= $InvA[0] + 500 And MouseGetPos(1) >= $InvA[1] And MouseGetPos(1) <= $InvA[1] + 500 Then MouseMove($InvA[0] - 50, $InvA[1]) ; Keep mouse out of detection range
			For $i = 0 To 7 Step 1
				For $j = 0 To 7 Step 1
					$IS = _ImageSearchArea($Relic, 0, $InvA[0] + $i * 48, $InvA[1] - 24 + $j * 48, $InvA[0] + 48 + $i * 48, $InvA[1] + 24 + $j * 48, $x, $y, 20, 0)
					If $IS = True Then
						MouseClick("right", $x, $y, 2)
						Sleep(250)
						$IS = _ImageSearchArea($ConfirmButton, 1, $ResOffset[0], $ResOffset[1], $ResOffset[2], $ResOffset[3], $x, $y, 20, 0)
						If $IS = True Then
							MouseClick("left", $x, $y, 2)
							Sleep(250)
							CoSe("{SPACE}")
							CoSe("{SPACE}")
							$j -= 1
						EndIf
					EndIf
				Next
			Next
			If $k < 2 Then
				MouseMove($InvA[0] +8, $InvA[1])
				Sleep(50)
				For $mw = 0 To 7
				MouseWheel("down")
				Next
			EndIf
			Sleep(150)
		Next
		CoSe("{ESC}")
		CoSe("{ESC}")
		CoSe("{ESC}")
		Return True
	Else
		Return False
		; TODO ERROR HANDLING
	EndIf
EndFunc   ;==>BrokerRelics

Func SellFish($npcname = "")
	Local Static $SellAllIni = StringSplit(StringStripWS(IniRead("config/resolution_settings.ini", "Restock", "SellAllButton", "1120, 437"), 8), ",", 2) ; x, y
	Local $SellAllButton[2] = [$SellAllIni[0] + $ResOffset[0], $SellAllIni[1] + $ResOffset[1]]

	If NPCType(2, $npcname) = True Then
		SetGUIStatus("Selling Fish.")
		MouseClick("left", $SellAllButton[0], $SellAllButton[1])
		Sleep(500)
		CoSe("{SPACE}")
		Sleep(500)
		CoSe("{ESC}")
		CoSe("{ESC}")
		Sleep(500)
		Return True
	Else
		Return False
		; TODO ERROR HANDLING
	EndIf
EndFunc   ;==>SellFish

Func BackToMount($Boat = 0)
	Local Static $HorseIni = StringSplit(StringStripWS(IniRead("config/resolution_settings.ini", "Restock", "Horse", "44, 124"), 8), ",", 2) ; x, y
	Local Static $BoatIni = StringSplit(StringStripWS(IniRead("config/resolution_settings.ini", "Restock", "Boat", "93, 123"), 8), ",", 2) ; x, y
	Local Static $SwapMounts = Int(IniRead("config/data.ini", "RestockSwapMounts", "Enabled", 0))
	Local Const $Mount[2][2] = [[$HorseIni[0] + $ResOffset[0], $HorseIni[1] + $ResOffset[1]], [$BoatIni[0] + $ResOffset[0], $BoatIni[1] + $ResOffset[1]]]
	Local $Sw = 0
	Sleep(500)
	WaitForMenu(False)
	Sleep(250)
	If Not VisibleCursor() Then CoSe("{LCTRL}")
	Sleep(250)
	SetGUIStatus("Boat: " & $Boat & " Swap: " & $SwapMounts)
	If $SwapMounts = 0 Then
		MouseClick("right", $Mount[$Boat][0], $Mount[$Boat][1])
		Sleep(250)
		MouseClick("right", $Mount[$Boat][0], $Mount[$Boat][1])
	Else
		MouseClick("right", $Mount[Mod(($Boat + 1), 2)][0], $Mount[$Boat][1])
		Sleep(250)
		MouseClick("right", $Mount[$Boat][0], $Mount[$Boat][1])
	EndIf
	Sleep(500)
	CoSe("t")
	CoSe("{ESC}")
	If VisibleCursor() Then CoSe("{LCTRL}")
	MapMovement()
	Return True
EndFunc   ;==>BackToMount

Func Restock()
	Local $RestockSettings = IniReadSection("config/data.ini", "RestockSettings")
	If $RestockSettings[1][1] = 0 Then Return False
	SetGUIStatus("Restocking...")
	WinActivate($hBDO)
	Sleep(500)
	$Fish = True

	For $Order = 1 To 8 Step 1
		Switch Int($Order)
			Case Int($RestockSettings[11][1])
				If $RestockSettings[3][1] = 1 Then ; Trader
					SetGUIStatus("Selling Fish.")
					If SellFish($RestockSettings[7][1]) Then
						SetGUIInventory(0)
						SetGUIStatus("Selling successful")
					Else
						$Order -= 1
						ContinueLoop
					EndIf
				EndIf
			Case Int($RestockSettings[12][1])
				If $RestockSettings[4][1] = 1 Then ; Repair
					SetGUIStatus("Repairing.")
					If RepairInv($RestockSettings[8][1]) Then
						SetGUIStatus("Repairing successful")
					Else
						$Order -= 1
						ContinueLoop
					EndIf
				EndIf
			Case Int($RestockSettings[13][1])
				If $RestockSettings[5][1] = 1 Then ; Auction
					SetGUIStatus("Auctioning Relics.")
					If BrokerRelics($RestockSettings[9][1]) Then
						SetGUIStatus("Auctioning successful")
					Else
						$Order -= 1
						ContinueLoop
					EndIf
				EndIf
			Case Int($RestockSettings[14][1])
				If $RestockSettings[6][1] = 1 Then ; Bank
					SetGUIStatus("Storing Relics & Money.")
					If BankRelics($RestockSettings[10][1]) Then
						SetGUIInventory(0)
						SetGUIStatus("Sotring successful")
					Else
						$Order -= 1
						ContinueLoop
					EndIf
				EndIf
			Case Int($RestockSettings[15][1])
				NPCProxy($RestockSettings[19][1])
			Case Int($RestockSettings[16][1])
				NPCProxy($RestockSettings[20][1])
			Case Int($RestockSettings[17][1])
				NPCProxy($RestockSettings[21][1])
			Case Int($RestockSettings[18][1])
				NPCProxy($RestockSettings[22][1])
		EndSwitch
		If $Fish = False Then Return False
	Next

	SetGUIStatus("Autopathing to mount.")
	BackToMount($RestockSettings[2][1])
	SetGUIStatus("Autopath to mount complete.")
	SwapFishingrod()
	$Fish = False
	Fish()
	Return True
EndFunc   ;==>Restock
#EndRegion - Restock

#Region - Marketplace
Func RunMarketplace()
	$Marketplace = Not $Marketplace
	If $Marketplace = False Then
		SetGUIStatus("Pausing Marketplace")
	Else
		SetGUIStatus("Starting Marketplace")
		$Fish = False
		Marketplace()
	EndIf
EndFunc   ;==>RunMarketplace

Func Marketplace()
	Local Const $PurpleBags = "res/marketplace_purplebags.bmp"
	Local $RegistrationCountOffset[4] = [70, -9, 110, 5]
	Local $RefreshOffset[2] = [-440, 480]
	Local $x, $y, $IS
	Local $Diff[4]
	Local $timer

	$ResOffset = DetectFullscreenToWindowedOffset()
	$IS = _ImageSearchArea($PurpleBags, 1, $ResOffset[0], $ResOffset[1], $ResOffset[2], $ResOffset[3], $x, $y, 0, 0)
	If $IS = False Then
		SetGUIStatus("No PurpleBags found. Stopping.")
		$Marketplace = False
	EndIf

	Local $count = 0, $breakout = 0
	While $Marketplace
		SetGUIStatus("Waiting for Registration Count change")
		$number = FastFindBidBuy($x, $y)
		If $number >= 0 Then BuyItem($x, $y, $number)

		$Diff[$count] = PixelChecksum($x + $RegistrationCountOffset[0], $y + $RegistrationCountOffset[1], $x + $RegistrationCountOffset[2], $y + $RegistrationCountOffset[3])
		For $i = 0 To UBound($Diff) - 1
			If $Diff[0] <> $Diff[$i] Then
				If TimerDiff($timer) > 1000 Then
					SetGUIStatus("Refresh (Registration Count change)")
					MouseClick("left", $x + $RefreshOffset[0], $y + $RefreshOffset[1], 1, 0)
					$timer = TimerInit()
					Sleep(50)
					ExitLoop
				Else
					$breakout += 1
					If $breakout > 10 Then
						$IS = _ImageSearchArea($PurpleBags, 1, $x - 10, $y - 10, $x + 10, $y + 10, $x, $y, 0, 0)
						If $IS = False Then
							SetGUIStatus("No PurpleBags found. Stopping.")
							$Marketplace = False
						Else
							$breakout = 0
						EndIf
					EndIf
				EndIf
			EndIf
		Next
		If TimerDiff($timer) > 30000 Then
			SetGUIStatus("Refresh (30s no change detected)")
			MouseClick("left", $x + $RefreshOffset[0], $y + $RefreshOffset[1], 1, 0)
			$timer = TimerInit()
			Sleep(50)
		EndIf
		Sleep(50)
		$count += 1
		If $count = 4 Then $count = 0
	WEnd
EndFunc   ;==>Marketplace

Func FastFindBidBuy($x, $y)
	Local $Valid[2] = [0x979292, 0xB8B8B8]
	Local $SSN = 1, $FF
	Local $BidR[3] = [21, 12, 21]
	Local $Buy[3] = [3, 12, 21]
	Local $Bid[3] = [4, 12, 21]
	Local $BuyOffset[3] = [78, 54, 62] ; x, y, height 7
	Local $ButtonRegion[4] = [$x + $BuyOffset[0] - 15, $y + $BuyOffset[1] - 15, $x + $BuyOffset[0] + 15, $y + $BuyOffset[1] + 15]
	Local $count

	FFSnapShot($ButtonRegion[0], $ButtonRegion[1], $ButtonRegion[2], $ButtonRegion[3] + $BuyOffset[2] * 6, $SSN)

	For $i = 0 To 6
		$count = 0
		For $yBid = $Bid[1] To $Bid[2]
			$FF = FFGetPixel($ButtonRegion[0] + $Bid[0], $ButtonRegion[1] + $yBid + $BuyOffset[2] * $i, $SSN)
			If $FF = $Valid[0] Or $FF = $Valid[1] Then
				$count += 1
			EndIf
		Next
		If $count > 9 Then
			SetGUIStatus("Bid " & $i)
			MouseClick("left", $x + $BuyOffset[0], $y + $BuyOffset[1] + $i * $BuyOffset[2], 2, 0)
			CoSe("{SPACE}")
		EndIf
	Next


	For $i = 0 To 6
		$count = 0
		For $yBuy = $Buy[1] To $Buy[2]
			$FF = FFGetPixel($ButtonRegion[0] + $Buy[0], $ButtonRegion[1] + $yBuy + $BuyOffset[2] * $i, $SSN)
			If $FF = $Valid[0] Or $FF = $Valid[1] Then
				$count += 1
			EndIf
		Next
		If $count > 9 Then
			SetGUIStatus("Buy " & $i)
			Return ($i)
		EndIf
		$count = 0
		For $yBidR = $BidR[1] To $BidR[2]
			$FF = FFGetPixel($ButtonRegion[0] + $BidR[0], $ButtonRegion[1] + $yBidR + $BuyOffset[2] * $i, $SSN)
			If $FF = $Valid[0] Or $FF = $Valid[1] Then
				$count += 1
			EndIf
		Next
		If $count > 9 Then
			SetGUIStatus("BidR " & $i)
			Return ($i)
		EndIf
	Next
	Return -1
EndFunc   ;==>FastFindBidBuy


Func BuyItem($x, $y, $number)
	Local $MaxOffset[2] = [-111, 297]
	Local $BuyOffset[3] = [78, 54, 62] ; x, y, height

	MouseClick("left", $x + $BuyOffset[0], $y + $BuyOffset[1] + $number * $BuyOffset[2], 2, 0) ; buy
	MouseClick("left", $x + $MaxOffset[0] - 30, $y + $MaxOffset[1], 1, 0) ; amount
	CoSe("f") ; max
	CoSe("r") ; confirm
	CoSe("{SPACE}") ; yes
EndFunc   ;==>BuyItem
#EndRegion - Marketplace

#Region - Window Mode Preparation
Func DetectFullscreenToWindowedOffset() ; Returns $Offset[2] for windowed mode (Fullscreen returns [0, 0])

	Local $x1, $x2, $y1, $y2
	Local $Offset[4]
	Local $ClientZero[4] = [0, 0, 0, 0]

	WinActivate($hBDO)
	WinWaitActive($hBDO, "", 5)
	WinActivate($hBDO)
	Local $Client = WinGetPos($hBDO)
	If Not IsArray($Client) Then
		SetGUIStatus("E: ClientSize coudl not be detected")
		Return ($ClientZero)
	EndIf

	If $Client[2] = @DesktopWidth And $Client[3] = @DesktopHeight Then
		SetGUIStatus("Fullscreen detected (" & $Client[2] & "x" & $Client[3] & ") - No Offsets")
		Return ($Client)
	EndIf

	If Not VisibleCursor() Then CoSe("{LCTRL}")
	Opt("MouseCoordMode", 2)
	MouseMove(0, 0, 0)
	Opt("MouseCoordMode", 1)
	$x1 = MouseGetPos(0)
	$y1 = MouseGetPos(1)
	Opt("MouseCoordMode", 0)
	MouseMove(0, 0, 0)
	Opt("MouseCoordMode", 1)
	$x2 = MouseGetPos(0)
	$y2 = MouseGetPos(1)
	MouseMove($x1, $y1, 0)


	$Offset[0] = $Client[0] + $x1 - $x2
	$Offset[1] = $Client[1] + $y1 - $y2
	$Offset[2] = $Client[0] + $Client[2]
	$Offset[3] = $Client[1] + $Client[3]
	For $i = 0 To 3
		SetGUIStatus("ScreenOffset(" & $i & "): " & $Offset[$i])
	Next

	Return ($Offset)
EndFunc   ;==>DetectFullscreenToWindowedOffset

#EndRegion - Window Mode Preparation

#Region - GameLaunch
Func DetectLaunchState()
	Local $Identifiers[3] = ["res/launch_start.bmp", "res/launch_server.bmp", "res/launch_connect.bmp"]
	Local $x, $y
	For $i = 1 To UBound($Identifiers) Step 1
		If _ImageSearch($Identifiers[$i - 1], 0, $x, $y, 20, 0) = True Then Return $i
		Sleep(500)
	Next
EndFunc   ;==>DetectLaunchState

Func ConvertSpecialCharacters($String)
	Local $Split = StringSplit($String, "")
	Local $New = ""
	For $i = 1 To $Split[0] Step 1
		Switch $Split[$i]
			Case "!"
				$New &= "{!}"
			Case "#"
				$New &= "{#}"
			Case "+"
				$New &= "{+}"
			Case "^"
				$New &= "{^}"
			Case "{"
				$New &= "{{}"
			Case "}"
				$New &= "{}}"
			Case Else
				$New &= $Split[$i]
		EndSwitch
	Next
	Return ($New)
EndFunc   ;==>ConvertSpecialCharacters

Func LauncherLogin()
	Local $Launcher = "Black Desert Online Launcher"
	Local $Path = IniRead("config/data.ini", "StartUpSettings", "LauncherPath", "UNDEFINDED")
	Local $password = ConvertSpecialCharacters(IniRead("config/data.ini", "StartUpSettings", "Password", "UNDEFINDED"))
	Local $iPID = Run($Path & $Launcher & ".exe", $Path, @SW_SHOW)
	If $iPID = 0 Then
		MsgBox(1, "Error", "Wrong path! Path must be for example C:\Black Desert\")
		Exit -1
	EndIf
	While Not StringRegExp(WinGetText($Launcher), "100%", 0) ; Check if the download is complete
		Sleep(500)
	WEnd
	Sleep(1000)
	ControlSend($Launcher, "", "[CLASS:Chrome_RenderWidgetHostHWND; INSTANCE:1]", $password & "{ENTER}")
	Sleep(5000)
	ControlClick($Launcher, "", "[CLASS:Chrome_RenderWidgetHostHWND; INSTANCE:1]", "left", 1, 1030, 520)
	Sleep(5000)
	If ProcessWaitClose($iPID, 20) = 0 Then
		cw("Maintenance?")
		Return False
	Else
		Return True
	EndIf
EndFunc   ;==>LauncherLogin

Func GameStart($timeout = 90)
	Local $GS = IniReadSection("config/resolution_settings.ini", "GameStart")
	Local $initimeout = IniRead("config/data.ini", "StartUpSettings", "Timeout", "UNDEFINDED")

	If $initimeout <> "" Then $timeout = Int($initimeout)
	$timeout *= 1000
	Local $timer = TimerInit()
	Local $x, $y
	GUISetState(@SW_MINIMIZE)

	While TimerDiff($timer) < $timeout
		Switch DetectLaunchState()
			Case 1
				SetGUIStatus("Start found")
				ControlSend($hBDO, "", "", "{ENTER}") ; START
				$ResOffset = DetectFullscreenToWindowedOffset()
			Case 2
				SetGUIStatus("Last Server found")
				MouseClick("left", $GS[1][0] + $ResOffset[0], $GS[1][1] + $ResOffset[1], 3) ; ENTER MAIN SERVER
			Case 3
				SetGUIStatus("Connect found")
				MouseClick("left", $GS[2][0] + $ResOffset[0], $GS[2][1] + $ResOffset[1], 3) ; CONNECT
				Sleep(500)
				MouseClick("left", $GS[2][0] + $ResOffset[0], $GS[2][1] + $ResOffset[1], 3) ; CONNECT
				Return True
		EndSwitch
	WEnd

	Return False
EndFunc   ;==>GameStart

Func WaitForMenu($show = False)
	Local Const $WorkerIcon = "res/esc_worker.bmp"
	Local $x, $y, $IS
	Local $timer = TimerInit()
	Local $timeout = 90 * 1000

	While TimerDiff($timer) < $timeout
		$IS = _ImageSearchArea($WorkerIcon, 1, $ResOffset[0], $ResOffset[1], $ResOffset[2], $ResOffset[3], $x, $y, 50, 0)
		If $IS = False Then CoSe("{ESC}")
		If $IS = True Then
			If $show = False Then CoSe("{ESC}")
			Return True
		EndIf
		Sleep(2000)
	WEnd
EndFunc   ;==>WaitForMenu

Func LaunchMain()
	SetGUIStatus("Terminating Client")
	ProcessClose("BlackDesert64.exe")
	SetGUIStatus("Launcher Login")
	LauncherLogin()
	SetGUIStatus("Game Start")
	GameStart(Int($StartUpSettings[4][1]))
	Sleep(10000)
	SetGUIStatus("Waiting for Menu")
	If WaitForMenu() = True Then SetGUIStatus("Gamestart successful")
	Sleep(5000)
	$Fish = True
	$freedetectedslots = DetectFreeInventory()
EndFunc   ;==>LaunchMain
#EndRegion - GameLaunch

Func Main()
	ObfuscateTitle()
	Local $InventorySettings = IniReadSection("config/data.ini", "InventorySettings")
	$DryingSettings = IniReadSection("config/data.ini", "DryingSettings")
	Global $PickedLoot = Int(IniRead("config/data.ini", "CurrentStats", "PickedLoot", 0))
	Global $SwappedRods = 0, $Reserve = 0
	Local $fishingtimer = 0, $dryingtime = 0, $dryingtimeout = 0, $failedcasts = 0
	Local $ScreenSaver = TimerInit()
	Local $HandleDryFish
	Local $Connected
	InitGUI()

	While True
		GUILoopSwitch()
		While $Fish
			GUILoopSwitch()
			Switch GetState()
				Case 30 ; You feel a bite. Press 'Space' bar to start.
					$Breaktimer = 0
					SetGUIStatus("FishingBite")
					If ReelIn() = True Then
						SetGUIStatus("Solving riddle.")
						Riddler()

						SetGUIStatus("Evaluating loot.")
						Sleep(3000)

						$InventorySettings = IniReadSection("config/data.ini", "InventorySettings")
						If $freedetectedslots - $PickedLoot - Int($InventorySettings[2][1]) - Int($InventorySettings[1][1]) <= 0 Then
							$Reserve = 1
						Else
							$Reserve = 0
						EndIf

						$PickedLoot = HandleLoot($Reserve)
						SetGUIInventory($PickedLoot)

						If $freedetectedslots - $PickedLoot - $InventorySettings[2][1] <= 0 Then ; Limit
							SetGUIStatus("Limit reached. Stopping.")
							$Fish = False
							If IniRead("config/data.ini", "RestockSettings", "EnableRestock", 0) Then Restock() ; EXPERIMENTAL
							ExitLoop
						EndIf
						If ($freedetectedslots / 3) - $InventorySettings[2][1] - $PickedLoot <= 0 Then ; Drying condition
							$HandleDryFish = HandleDryFish(Int($DryingSettings[1][1]))
							If $HandleDryFish > 0 Then $freedetectedslots = $HandleDryFish
						EndIf
						SetGUIStatus("Inventory Status: [" & $freedetectedslots & "][" & $PickedLoot & "][" & $InventorySettings[2][1] & "][" & $InventorySettings[1][1] & "]")
					Else
						HandleRewardSpam()
					EndIf
				Case 20 ; You are currently fishing. Please wait until you feel a bite.
					If TimerDiff($ScreenSaver) / 1000 / 60 >= 2 Then ; To fix ScreenSaver messing up
						MouseMove(MouseGetPos(0) + 10, MouseGetPos(1))
						MouseMove(MouseGetPos(0) - 10, MouseGetPos(1))
						$ScreenSaver = TimerInit()
					EndIf
					$Breaktimer = 0
					If $fishingtimer <> 0 Then
						SetGUIStatus("Currently fishing. (" & Round(TimerDiff($fishingtimer) / 1000, 0) & "s)")
					Else
						SetGUIStatus("Currently fishing.")
					EndIf
				Case 10 ; Press 'Space' near a body of water to start fishing.
					$Breaktimer = 0
					SetGUIStatus("Ready for fishing.")
					If Cast() = False Then
						$failedcasts += 1
						If $failedcasts >= 12 Then
							SetGUIStatus("Too many failed casts. Stopping.")
							$Fish = False
							If IniRead("config/data.ini", "RestockSettings", "EnableRestock", 0) Then Restock() ; EXPERIMENTAL
							ExitLoop
						EndIf
						SetGUIStatus("Cast failed(" & $failedcasts & "). Inspecting equipped fishingrod.")
						If InspectFishingrod() = True Then
							SetGUIStatus("Swapping fishingrods.")
							If SwapFishingrod($InventorySettings[3][1]) = True Then
								$SwappedRods += 1
							Else
								SetGUIStatus("No fishingrods found. Stopping.")
								$Fish = False
								If IniRead("config/data.ini", "RestockSettings", "EnableRestock", 0) Then Restock() ; EXPERIMENTAL
								ExitLoop
							EndIf
						Else
							SetGUIStatus("Fishingrod ok. Maybe turn around?")
							Turn()
						EndIf
					Else
						$failedcasts = 0
					EndIf
					$fishingtimer = TimerInit()
				Case Else
					If $Breaktimer = 0 Then
						$Breaktimer = TimerInit()
						SetGUIStatus("Unidentified state")
					ElseIf TimerDiff($Breaktimer) / 1000 > 10 Then
						$Connected = IsProcessConnected("BlackDesert64.exe")
						SetGUIStatus("Game connected: " & $Connected)
						If $Connected = False And Int($StartUpSettings[1][1]) = 1 Then LaunchMain()
						SetGUIStatus("Unidentified state. Trying to equip fishingrod.")
						WaitForMenu(False)
						If SwapFishingrod() = False Then
							SetGUIStatus("Detection Error. UI Scale must be at 100%")
							$Fish = False
							ExitLoop
						Else
							Sleep(3000)
						EndIf
					Else
						SetGUIStatus("Unidentified state (" & Round(TimerDiff($Breaktimer) / 1000, 0) & "s)")
					EndIf
			EndSwitch
			Sleep(100)
			If $Fish = False Then
				SetGUIStatus("Fishing stopped.")
				$fishingtimer = 0
			EndIf
		WEnd

	WEnd
EndFunc   ;==>Main

Main()

Func TraderBargain() ; TODO
	Local $x, $y, $IS
	Local $shout = "res/bargain_shout.bmp"
	Local $ClapOffset[2] = [-60, 0]
	Local $SellRertryOffset[2] = [100, 0]
	Local $Success[3] = [-138, -172, 0x66CC33]
	Local $Failed[3] = [-140, -170, 0xF26A6A]
	Local $BargainWin = False
	$ResOffset = DetectFullscreenToWindowedOffset()

	$IS = _ImageSearchArea($shout, 1, $ResOffset[0], $ResOffset[1], $ResOffset[2], $ResOffset[3], $x, $y, 40, 0)
	If $IS = True Then
		While $BargainWin = False
			MouseClick("left", $x, $y)
			Sleep(1000)
			MouseClick("left", $x + $ClapOffset[0], $y + $ClapOffset[1])
			Sleep(1000)
			MouseClick("left", $x + $ClapOffset[0], $y + $ClapOffset[1])
			Sleep(1500)
			If $Success[2] = PixelGetColor($x + $Success[0], $y + $Success[1]) Then
				$BargainWin = True
				cw("success")
			EndIf
			If $Failed[2] = PixelGetColor($x + $Failed[0], $y + $Failed[1]) Then
				cw("failed")
			EndIf
			MouseClick("left", $x + $SellRertryOffset[0], $y + $SellRertryOffset[1])
			Sleep(250)
			CoSe("{Space}")
		WEnd
	EndIf
EndFunc   ;==>TraderBargain

