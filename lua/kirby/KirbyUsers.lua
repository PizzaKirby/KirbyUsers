if not ku then ku = {} end

--use ini file with captions as sections ? ( external )
--mainscript root dir
KU_DIR = "sys\\lua\\kirby\\KirbyUsers.lua"
--dirs make then relative to the root dir ? ( would only need to adjust 1 dir )
ku.GROUP_FILE = "sys\\lua\\Kirby\\users\\groups.conf"
ku.USER_FILE = "sys\\lua\\Kirby\\users\\users.conf"
ku.LOG_DIR = "sys\\lua\\Kirby\\users\\logs"
ku.SETTINGS_USER_SETTINGS_DIR = "sys\\lua\\Kirby\\users\\user_settings"
ku.REPORT_DIR = "sys\\lua\\Kirby\\users\\reports"
ku.CLAN_FILE = "sys\\lua\\Kirby\\users\\clans.conf"
ku.MEMBER_FILE = "sys\\lua\\Kirby\\users\\members.conf"
--utility
ku.EXTERNAL_LOGGING = false
--security ( kinda )
ku.ALLOW_MULTIPLE_VOTES_BY_SAME_IP = false
ku.DEFAULT_KICK_RATIO = game("mp_kickpercent")
ku.DURATION_MAX = 3600
--internal
ku.CMD_MARKER = '!'
ku.HUDTXT_START = 1
ku.modchat_r = {}
ku.groups = {}
ku.users = {}
ku.users_store = {}
ku.muted = {}
ku.cmds = {["say"] = {}}--,["parse"] = {},["rcon"] = {}}
ku.exPerms = {} -- External permissions
ku.tbanlist = {}
ku.clans = {}

--temp

--[[
	memedispenser
	NAME HISTORY
]]

--commands used by 'Unregistered' don't seem to have args ( yet can target players )

--default -> default script color
--standard -> default cs2d chatcolor ( yellow )
ku.colors = {

			default = '255255255',
			standard = '255220000',

			err = '255000050',
			succ = '000255050',
			std = '255255255',
			help = '111255111',
			chatspy = '050200100',
			info = '050100150',

			red = '255000000',
			green = '000255000',
			blue = '000000255',
			orange = '255150000',
			white = '255255255',
			black = '000000000',

			pl = 	{
						[1] = '222019019',
						[2] = '037059220',
						[3] = '017017128',
						[4] = '225033182',
						[5] = '191015015',
						[6] = '083019215',
						[7] = '179220037'
					},

			teams = {
						[0] = '255220000',
						[1] = '255025000',
						[2] = '050150255',
						[3] = '050150255' 
					}

			}




--TODO 
--help command -> no param show all commands you have access to 																								DONE	
--help <command> show helptext / usage						   																							 	    DONE
--Fix the random letters when using colors ( probably the editor ? works fine ingame)  																			DONE
--  something's wrong with the '\169' string.byte returns 194 but string.char(194) results in another character 												DONE
-- try again when internet is back online (  works for hudtxt as it seems )  DONE ( using ASCII keyset)															DONE
--  NOT an internal problem 																																	DONE
--Fix external logging 																																			DONE
--help command list all avaiable commands when no paramter is given                    																			DONE
--find proper teamcolors																																		DONE
--listmaps [<mask>] command | only list the first 10 maps ( or all prefixes ? ) then 10 first for the given prefix | for !changemap 							DONE
--| only possible via external lib | make one ? 																												DONE
-- without the prefix ( for the sorting via mask at least ( maybe not won't be possible to list the first 10 dm_ maps for e.g.))								DONE
--unban command 																																				DONE
--banlist ( 15 most recent bans ? ( possible ? ) ( mask ))																										DONE
--merge <string> <message> <reason> to 1 argtype & add <ip> <usgn> | not message ( strips @C ) <string> & <reason> nope ,										DISCARDED
-- string needs to be give, reason is optional ( -> report command -> reason needed handle empty string function internal ? )									DISCARDED
--organzie the script ( sections ( essentials , moderation (functions)))																						FROZEN
--add *DEAD* when only tag is enabled ?																															DONE
--equip <itemid/#itemname> [<id>] | func itemname -> itemid | dynamically generate the table containing the names & ids | vice versa 							DISCARDED
--setpos ?																																						DISCARDED
--restartround | rr 																																			DONE
--create simple dll | creates a file or sth | try to run it via loadlib																							DISCARDED
--disable weapon dropping etc | 3 modes | not at all | only weapons contained in a table | all 																	DISCARDED
--report function report | rep <id> <reason>																													DONE
--confirmation for like bans or sth ? in sayhook setvar if confirmation is expected and save the params & func to be executed if confirmed						DISCARDED / FROZEN
--add new setting : playerlist console / chat ( chat highlights ips that are used multiple times) ( nah ? )														DISCARDED
--find a better way for the playerlist ( the spaces ) get longest name -> adjust length -> get ip 																DISCARDED
-- -> adjust length -> get usgn -> assemble -> print | way to force a string to have a specific length ( char whise )											DISCARDED
--better noticable leave / join messages for registered users in the logs 																						DONE
--removeuser | ru command 		   																																DONE
--chatspy ( for teamchat in all cases & spec if ingame & dead when alive and deadchat isn't enabled ( and person writing doesn't have a tag | color ofc ))		DONE
--add new setting to toggle Chatspy 																															DONE
--chatspy -> deathtag																																			DONE
--special group : Unregistered 																																	DISCARDED
--highlight own group in listgroups																																DONE
--bancommand to basically ban everything of a user ( or just ip & usgn ban ? )																					FROZEN
--add about command -> shows creator -> name -> usgn -> version -> name of the script ? 																		DISCARDED/FROZEN
--rework banlist so it only works for a given bantype ( ip,name,usgn )																							DONE
--in set_user : ignore player if a user with the same usid is already connected ( also with the same ip ? )														DONE ( USGN )												
--watchlogs | wl cmd ? shows the 15 most recent activities in the logs ? (saved in table ?)																		DISCARDED/FROZEN
--linux version for getMapsInDir 																																HIGH PRIORITY
--clanlist | cl -> shows online clanmembers
--internal : regClanMember(clanname,usgn)
--make a plan first
--add clan to ku.users table ?

--checks for quotes in string based arg type ( exploitable )																									DONE / HIGH PRIORITY
--ku.open_save(checks if exists not with f_exists and returns a file handle)
--line 640 -> triggers when color / tag is off + any chat message 																								DONE

--GLOBAL BANS on all servers running on the same physical server using this script

--INFO

--to support a color like random ( change - checkargs , isvalidcolor , adjust say, modchat)
--add reloadgroups ? 																																			DISCARDED / FROZEN
--recursive permissionlist : check if group is valid , check if group is ~= param() avoid infinite loops 														DONE


-------------------------------------------------------------------------
----- cs2d player override
-------------------------------------------------------------------------

_player = player
function player(id,value)
	if(value:lower() == "alive") then
		return ( _player(id,"health") > 0 )
	end
	return _player(id,value)
end

-------------------------------------------------------------------------
----- non cs2d utility functions
-------------------------------------------------------------------------
function ku.totable(s,match)
	local args = {}
	if not match then
		match = "[^%s]+"
	else
		match = "[^"..match.."]+"
	end
	for word in string.gmatch(s,match) do
		table.insert(args,word)
	end
	return args
end

function ku.table_count(t, item)
	local ret = {}
  	for i,v in pairs(t) do
  		if item == v then table.insert(ret,i) end
    end
    return ret
end

function ku.f_write(file,text,mode)
	if not mode then mode = "w" end
	--if(ku.f_exists(file)) then
	f = io.open(file,mode)
	if(f) then
		f:write(text)
		f:close()
	end
	--end
end

function ku.f_exists(file)
	local f = io.open(file)
	if (f) then
		f:close()
		return true
	end
	return false
end

function ku.f_read(file)
	local lines
	if(ku.f_exists(file)) then
		lines = {}
		for line in io.lines(file) do
			table.insert(lines,line)
		end
	end
	return lines
end

function ku.f_openSave(file,mode)
	if not mode then mode = "r" end
	local f = io.open(file,mode)
	if(f) then 
		return f
	else 
		return nil 
	end
end

function ku.log(line)
	if(ku.EXTERNAL_LOGGING) then
		ku.f_write(ku.LOG_DIR.."/"..os.date("%d-%m")..".log","["..os.date("%H:%M:%S").."] : "..line,"w+") -- redo
	else
		print(line)
	end
end

function ku.getRandomColor()
	--math.randomseed(os.time() * os.time())
	local r,g,b = ""..math.random(0,255),""..math.random(0,255),""..math.random(0,255)
	r,g,b = string.rep("0",3-r:len())..r,string.rep("0",3-g:len())..g,string.rep("0",3-b:len())..b
	return r..g..b
end

function ku.isValidColor(col)
	if(col:len() == 9) then
		local r = tonumber(col:sub(1,3))
		local g = tonumber(col:sub(4,6))
		local b = tonumber(col:sub(7,9))
		return ((r >= 0 and r <= 255) and (g >= 0 and g <= 255) and (b >= 0 and b <= 255))
	elseif(col:lower() == "random") then
		return true
	end
	return false
end

function ku.varToState(var)
	if(var == 1 or var == "1") then
		return "on"
	else
		return "off"
	end
end

function ku.toPrintableVal(val)
	if(type(val) == "boolean") then
		if(val) then return "true" else return "false" end
	elseif(type(val) == "string") then return val
	elseif(type(val) == "number") then return ""..val 
	elseif(type(val) == "table") then return "<table>" 
	elseif(type(val) == "nil") then return "nil" 
	end
	return "<unknown>"
end

function ku.save_Settings(id) -- make it more dynamic
	if(not ku.users[id].settings.color or not ku.users[id].settings.tag or not ku.users[id].settings.mm or not ku.users[id].settings.cs) then
		return
	end
	local f = io.open(ku.SETTINGS_USER_SETTINGS_DIR.."/"..player(id,"usgn")..".set","w")
	f:write(ku.users[id].settings.color..","..ku.users[id].settings.tag..","..ku.users[id].settings.mm..","..ku.users[id].settings.cs)
	f:close()
end

function ku.removeSpecialchars()
end

function ku.removeQuotes(str)
	str = str:gsub("\"","")
	str = str:gsub("'","")
	return str or ""
end

function ku.removeColorTag(str)
	str = str:gsub("\169","")
	return str or ""
end
-------------------------------------------------------------------------
----- script internal getters
-------------------------------------------------------------------------
function ku.get_groupPermissions(group,ptype)
	if not ptype then ptype = "table" end
	local perms = ku.groups[group]["permissions"]
	if(ku.groups[group]["inherit-from"]) then
		if(ku.groups[group]["inherit-from"] ~= group) then	--prevent simple infinite loops
			perms = perms..","..ku.get_groupPermissions(ku.groups[group]["inherit-from"],"string")
		end
	end
	if(ptype == "string") then
		return perms
	else
		return ku.totable(perms,",")
	end
end

function ku.get_groupLevel(group)
	if(group) then
		return tonumber(ku.groups[group]["level"])
	end
	return 0
end

function ku.get_groupColor(group)
	return ku.groups[group]["color"] 
end

function ku.get_groupTag(group)
	return ku.groups[group]["tag"]
end

function ku.get_Groups() --< may also be used to reload the groups
	if(ku.f_exists(ku.GROUP_FILE)) then
		ku.groups = {}  
		local curr_name = ""
		for line in io.lines(ku.GROUP_FILE) do
			if(line ~= "") then
				if(line:sub(1,1) == '#') then
					curr_name = line:sub(2)
					ku.groups[curr_name] = {}
				else
					local varname = string.match(line,"(.*):") 
					local val = string.match(line,":(.*)")
					if(curr_name and varname and val) then
						ku.groups[curr_name][varname] = val
					end
				end	
			end
		end		
	end
end

function ku.get_Users()
	if(ku.f_exists(ku.USER_FILE)) then
		ku.users_store = {}
		for line in io.lines(ku.USER_FILE) do
			local user = ku.totable(line,",")
			ku.users_store[tonumber(user[2])] = {name = user[1],group = user[3]}
			--table.insert(ku.users_store,{name = user[1],usgn = tonumber(user[2]),group = user[3]})
		end
	end
end

function ku.get_Clans()
	if(ku.f_exists(ku.CLAN_FILE)) then
		ku.clans = {} -- so it can be used to reload the clanlist
		for line in io.lines(ku.CLAN_FILE) do
			local clan = ku.totable(line,",")
			ku.clans[clan[1]] = {pattern = clan[2]} -- ku-clans["-[IfwsI]-"] = herp
		end
	end
end

function ku.get_Settings(id)
	--1/0 modchat 1/0 tag 1/0 color
	--either load or set to default ( last 3 lines ) then force save
	--seems to work with the commented stuff
	ku.users[id].settings = {}
	local set = {}
	if(ku.f_exists(ku.SETTINGS_USER_SETTINGS_DIR.."/"..player(id,"usgn")..".set")) then
		local f = io.open(ku.SETTINGS_USER_SETTINGS_DIR.."/"..player(id,"usgn")..".set","r")
		l = f:read()
		--if(l ~= nil) then
		set = ku.totable(l,",")
		--else
		--	set = {1,1,0,1} -- not needed ?
		--end
		f:close()
	--else
	--	set = {1,1,0,1}
	end
	ku.users[id].settings.color = tonumber(set[1]) or 1
	ku.users[id].settings.tag = tonumber(set[2]) or 1
	ku.users[id].settings.mm = tonumber(set[3]) or 0
	ku.users[id].settings.cs = tonumber(set[4]) or 1
end

function ku.get_idByName(name)
	name = name:lower()
	local ids = {}
	local ptable = player(0,"table")
	for id,_ in ipairs(ptable) do
		if(string.match(player(id,"name"):lower(),name)) then
			table.insert(ids,id)
		end
	end
	if(not ids[1]) then
		return nil,"No match!"
	end
	if (#ids > 1) then
		--error output
		return nil,"Multiple matches!" --"Multiple matches!"
	end
	return ids[1],nil
end

-------------------------------------------------------------------------
----- script internal setters
-------------------------------------------------------------------------

function ku.set_Color(id,col)
	--check if valid color
	if not ku.isValidColor(col) then col = ku.colors.default end
	--if not col then col = ku.colors.default end	--might be unnecessary since nil is not a valid color
	ku.users[id].color = col
end

function ku.set_RegName(id,name)
	ku.users[id].name = name
end

function ku.set_Tag(id,tag)
	ku.users[id].tag = tag
end

function ku.set_Permissions(id,permlist)
	--nokick permissions / add special permissions
	--don't remove anything to allow duplicate names for special perms & cmdperms ?
	ku.users[id].permissions = {}
	ku.users[id].permissionsEx = {}
	for i,p in ipairs(permlist) do
		for _,c in ipairs(ku.cmds["say"]) do
			if(c.name == p or c.shortcut == p or p == '*') then
				ku.users[id].permissions[c.name] = true
				--table.remove(permlist,i)
			end
		end
		for _,ex in ipairs(ku.exPerms) do
			if(ex.name == p or ex.shortcut == p or p == '*') then
				ku.users[id].permissionsEx[ex.name] = true
				--table.remove(permlist,i)
			--elseif(p == '*') table.remove stuff if NOT '*' ^
			end
		end
	end
end

function ku.set_Level(id,level)
	ku.users[id].level = tonumber(level)
end

function ku.set_user(id)
	ku.users[id] = {}
	ku.muted[id] = nil

	local already_connected
	local usid = player(id,"usgn")	

	for p,_ in ipairs(player(0,"table")) do
		if(player(p,"usgn") == usid and p ~= id) then
			already_connected = true
			ku.err(id,"A player with your U.S.G.N. ID is already connected!")
			ku.err(0,"Player "..player(id,"name").." | "..player(id,"ip").." | "..player(id,"usgn").." is joining with an U.S.G.N. ID which is already in use by ID "..p.." !")
			break
		end
	end
	--if usid < 0 then usid = 196 end
	--default group : Unregistered
	if(usid <= 0 or not ku.users_store[usid] or player(id,"bot") or already_connected) then
		ku.users[id].level = -1
		--if(ku.groups["Unregistered"]) then
		--	ku.set_Permissions(id,ku.get_groupPermissions("Unregistered"))
		--else
		ku.users[id].permissions = {}
		ku.users[id].permissionsEx = {}
		--end
		ku.users[id].settings = {}
		return
	end
	local group = ku.users_store[usid].group 
	local name = ku.users_store[usid].name
	if(ku.f_exists(ku.SETTINGS_USER_SETTINGS_DIR.."/"..player(id,"usgn")..".col","r")) then
		--use ku.f_read() ?
		local f = io.open(ku.SETTINGS_USER_SETTINGS_DIR.."/"..player(id,"usgn")..".col") 
		local col = f:read()
		if(ku.isValidColor(col)) then
			ku.set_Color(id,col)
		else
			ku.set_Color(id,ku.get_groupColor(group))
		end
	else
		ku.set_Color(id,ku.get_groupColor(group))
	end
	--ku.set_Settings(id,ku.get_userSettings)
	ku.users[id].group = group
	ku.set_Level(id,ku.get_groupLevel(group))
	ku.set_RegName(id,name)
	ku.set_Permissions(id,ku.get_groupPermissions(group))
	ku.set_Tag(id,ku.get_groupTag(group))
	ku.get_Settings(id)

	ku.log("User : #"..id.." "..usid.." | "..ku.users[id].name.." ( "..player(id,"name").." ) | "..group.." connected with the ip "..player(id,"ip"))
	--[[
	if(usid > 0) then
		for i,_ in ipairs(ku.users_store) do
			if(ku.users_store[i].usgn == usid) then
				local user = ku.users_store[i] 
				ku.users[id] = {}
				
				ku.setColor(id,ku.get_groupColor(user.group))
				ku.setRegName(id,user.name)
				ku.set_Permissions(id,ku.get_groupPermissions(user.group))
				ku.set_Level(id,ku.get_groupLevel(user.group)) 
				return
			end
		end
	end
	]]--
end


-------------------------------------------------------------------------
----- script internal registering functions
-------------------------------------------------------------------------
function ku.regSayCmd(name,shortcut,argnum,usage,func,help)
	if(not name) then ku.err(0,"No name given") return end
	if(not func or type(func) ~= "function") then ku.err(0,"failed to add command : "..name) return end
	if(not usage) then ku.err(0,"no usage specified for command : "..name) return end
	if(not argnum) then ku.err(0,"no argnum for command : "..name) return end
	
	table.insert(ku.cmds["say"],{name = name,shortcut = shortcut,argnum = argnum,func = func,usage = usage,help = help})  -- faster processing ? -- add usage  // args = numval / opt_args = numval
end

function ku.regPermEx(name,shortcut)
	if(not name) then ku.err(0,"No name given") return end
	table.insert(ku.exPerms,{name = name,shortcut = shortcut})
end

--ku.cmds["say"][shortcut]
--	if(shortcut) then
--		ku.cmds["say"][shortcut] = ku.cmds["say"][name]
--		--ku.cmds["say"][shortcut] = {func = func,usage = usage,help = help}
--	end
--table.insert(ku.cmds["say"],{name = name,shortcut = shortcut,help = help}) -- more memory usage ? relevant ?

-------------------------------------------------------------------------
----- cs2d hooks
-------------------------------------------------------------------------

function ku.radio(id,rid)
	if(ku.muted[id]) then
		local message = "You are muted!"
		if(ku.muted[id].reason) then
			message = message.." ( Reason : "..ku.muted[id].reason.." )"
		end
		ku.err(id,message)
		return 1
	end	
end


function ku.sayteam(id,txt)
	if(ku.muted[id]) then
		local message = "You are muted!"
		if(ku.muted[id].reason) then
			message = message.." ( Reason : "..ku.muted[id].reason.." )"
		end
		ku.err(id,message)
		return 1
	end
	--changes the bahavious in sayhook ? and vice versa

	--txt = ku.removeQuotes(txt)

	local cst = {}
	local csmsg = ""
	for pid,u in ipairs(ku.users) do
		if(u.permissionsEx["chatspy"] and (u.settings.cs == 1 )) then -- throws error after disconnecting ( maybe only if you are the only player , got permission) -- fixed 
			table.insert(cst,u)
		end
	end
	csmsg = player(id,"name").."\169"..ku.colors.standard.." (Team)" 
	if(not player(id,"alive") and player(id,"team") ~= 0) then csmsg = csmsg.." *DEAD*" end
	csmsg = csmsg..": \169"..ku.colors.chatspy..txt

    for tid,_ in ipairs(cst) do
		if( player(id,"team") ~= player(tid,"team") ) then
			ku.msg_team(tid,id,csmsg)
		--elseif( (player(id,"team") == 0) and player(tid,"alive")) then -- speaker is spec and target is not dead
		--	msg("chatspy aswell :>")
		end
	end
end

function ku.say(id,txt)
	if(ku.muted[id]) then
		local message = "You are muted!"
		if(ku.muted[id].reason) then
			message = message.." ( Reason : "..ku.muted[id].reason.." )"
		end
		ku.err(id,message)
		--if(ku.muted[id].reason) then
		--	ku.err(id,"You are muted! ( Reason : "..ku.muted[id].reason.." )")
		--else
		--	ku.err(id,"You are muted!")
		--end
		return 1
	end

	if(txt:lower() == "rank") then
		return 0
	end
	--stripbc here ? 
	txt = ku.removeQuotes(txt)

	if(txt:sub(1,1) == ku.CMD_MARKER) then
		args = ku.totable(txt:sub(2))	
		cmd = args[1]
		table.remove(args,1)
		for _,c in ipairs(ku.cmds["say"]) do
			if(cmd == c.name or cmd == c.shortcut) then
				if(ku.users[id].permissions[c.name]) then -- :C
					local func_args = ku.checkargs(args,c.usage,c.argnum,id)
					if(func_args.error) then
						ku.err(id,func_args.error)
						return 1
					end
					if(args.id) then
						if(ku.users[id].level <= ku.users[func_args.id].level) then
							ku.err(id,"The target's level is too high or equal!")
							return 1
						end
					end
					for n,v in ipairs(func_args) do
						msg(n.." | "..v)
					end
					c.func(id,func_args)
				else
					ku.err(id,"You don't have the permission to use this command!")
				end
				return 1 -- no permission
			end
		end
		ku.err(id,"Command does not exist")
		return 1
	--------------------------------------
	-- combinations possible : tag on | color on -> colored message + tag ? ,
	--                         tag off | color on -> teamcolored name + tag + colored message , 
	--                         tag off | color off -> return 0 , 
	--                         tag on  | color off -> teamcolored tag , normal chatcolor
	--------------------------------------
	elseif(ku.users[id].tag) then 
		local message = ""
		txt = txt:gsub("\169","")
		txt = ku.stripbc(txt)

		if(txt == "") then
			ku.err(id,"Empty message or banned symbols were used!")
			return 1
		end
	--color : 			ku.users[id].color
	--tag   :  			ku.users[id].tag
	--msg('\169'..ku.users[id].color..ku.users[id].tag.." "..player(id,"name").." : "..txt)
	--deathtag ? ( for color == 0 ) DONE
		if(ku.users[id].settings.color == 1) then
			-- add support for random
			local color = ku.colors.default
			if(ku.users[id].color == "random") then
				color = ku.getRandomColor()
			else
				color = ku.users[id].color
			end

			if(ku.users[id].settings.tag == 1) then
				message = '\169'..color..ku.users[id].tag.." "..player(id,"name").." : "..txt
			else
				message = '\169'..color..player(id,"name").." : "..txt
			end
		else
			if(ku.users[id].settings.tag == 1) then
				message = '\169'..ku.colors.teams[player(id,"team")]..ku.users[id].tag..' '..player(id,"name")
				if( (not player(id,"alive") ) ) then --and (player(id,"team") ~= 0) ) then
					message = message..' *DEAD*'
				end
				message = message..' : \169'..ku.colors.standard..txt
			--else
				--return 0
			end
		end

		--msg(message)
		--msg(ku.toPrintableVal(message ~= ""))
		--msg(txt)
		--msg(ku.toPrintableVal(txt ~= ""))
		if(message ~= "") then
			msg(message)
			return 1
		end
	end
	--[[
	elseif (ku.users[id].tag) then --does the user have a tag ? NOT the settings
		txt = ku.stripbc(txt)
		if(txt ~= "") then
			local cmsg = ""
			if(ku.users[id].settings.color == 0) then
				return 0
			end
			cmsg = cmsg..'\169'..ku.users[id].color
			if(ku.users[id].settings.tag == 1) then
				cmsg = cmsg..ku.users[id].tag.." "
			end
			
			cmsg = cmsg..player(id,"name").." : "..txt
			
			msg(cmsg)
			--msg('\169'..ku.users[id].color..ku.users[id].tag.." "..player(id,"name").." : "..txt)
		end
		return 1
	end
	]]--

	--chatspy -> iterate through all users -> everbody having the chatspy permissions AND meeting certain conditions : team / dead - alive return 0 ? to avoid duplicates if a mod writes a message
	--REMINDER -> special permissions ku.regSpecialPerm("permname","shortcut","description")
	--only people with cs permission left in the table
	--entering chatspy derp
	--strip bc 
	local cst = {}
	for pid,u in ipairs(ku.users) do
		if(u.permissionsEx["chatspy"] and (u.settings.cs == 1)) then
			table.insert(cst,u)
		end
	end
	--assemble msg here first
    for tid,_ in ipairs(cst) do
		if( ( player(id,"alive") ~= player(tid,"alive") ) and not player(id,"alive") ) then
			ku.msg_team(tid,id,player(id,"name").."\169"..ku.colors.standard.." *DEAD*: \169"..ku.colors.chatspy..txt)
		--elseif( (player(id,"team") == 0) and player(tid,"alive")) then -- speaker is spec and target is not dead -- specs always have the *DEAD* tag
		--	msg("chatspy aswell :>")
		end
	end
end

function ku.leave(id)
	if(player(id,"bot")) then return end

	if(ku.users[id].settings) then -- error when removing bots fixed ^
		ku.save_Settings(id)
	end

	ku.users[id] = nil

	if(ku.muted[id]) then
		if(ku.muted[id].src) then
			freetimer("ku.mute",tostring(id)..","..ku.muted[id].src)
		end
	end
	ku.muted[id] = nil
end

function ku.menu(id,title,sel)
	if(title == "[KU] Settings") then
		if(sel == 1) then
			ku.users[id].settings.color = (ku.users[id].settings.color + 1) % 2
		elseif(sel == 2) then
			ku.users[id].settings.tag = (ku.users[id].settings.tag + 1) % 2
		elseif(sel == 3) then
			ku.users[id].settings.mm = (ku.users[id].settings.mm + 1) % 2
			if(ku.users[id].settings.mm == 1) then
				ku.updatehud(id)
			else
				ku.clearhud(id)
			end
		elseif(sel == 4) then
			ku.users[id].settings.cs = (ku.users[id].settings.cs + 1) % 2
		end
		ku.settings(id,nil)
	end
end

function ku.vote(src,mode,id)
	--possible to not count votes by disableing it on vote / reenabling after ~ 1 sec ( or on next vote ) poosible , DONE
	if(mode == 1) then

		if(player(id,"bot")) then return end

		parse("mp_kickpercent "..ku.DEFAULT_KICK_RATIO)

		id = tonumber(id)

		if((ku.users[src].level < ku.users[id].level) and (ku.users[id].permissionsEx["nokick"])) then
			ku.exec('kick '..src..'" voting a moderator"',0)
		end

		if(not ALLOW_MULTIPLE_VOTES_BY_SAME_IP) then
			for _,p in ipairs(player(0,"table")) do
				if( ( player(p,"ip") == player(src,"ip") ) and ( player(p,"votekick") == id ) ) then parse("mp_kickpercent 0.0") end
			end
		end
	end
end

function ku.loghook(line)
	if(ku.tbanlist.expected) then
		--if(line:sub(1,1) == "*") then
		if(line:match(ku.tbanlist.btype)) then
			if(#ku.tbanlist.list >= 20) then 
				table.remove(ku.tbanlist.list,1) 
			end
			table.insert(ku.tbanlist.list,line)
			ku.tbanlist.ctype = ku.tbanlist.ctype + 1
		elseif(line:find("bans total:")) then
			if(ku.tbanlist.ctotal == 0) then
				local d = line:match("bans total: (%d*)") or ""
				if(d ~= "") then
					ku.tbanlist.ctotal = d
				end	
			end
		elseif(line:match("#?#End of banlist#?#")) then
			ku.tbanlist.expected =  nil
			local id = line:match("#?#End of banlist#?#(%d*)")
			parse('cmsg "\169'..ku.colors.orange..'Total bancount : '..ku.tbanlist.ctotal..'" '..id)
			parse('cmsg "\169'..ku.colors.orange..'Amount of '..ku.tbanlist.btype:sub(2)..' bans : '..ku.tbanlist.ctype..'" '..id)
			for _,v in ipairs(ku.tbanlist.list) do
				parse('cmsg "\169'..ku.colors.orange..v..'" '..id)
			end
			ku.tbanlist = {}
		end
	end
end

-------------------------------------------------------------------------
----- cs2d message functions
-------------------------------------------------------------------------

function ku.err(id,txt)
	local err = "\169"..ku.colors.err.."[KU] [ERROR] : "..txt
	if(id ~= 0) then
		msg2(id,err)
	else
		print(err)
	end
end

function ku.succ(id,txt)
	msg2(id,"\169"..ku.colors.succ.."[KU] "..txt)
end

function ku.std(id,txt)
	msg2(id,"\169"..ku.colors.std.."[KU] "..txt)
end

function ku.msg_help(id,txt)
	msg2(id,"\169"..ku.colors.help.."[KU] [HELP] "..txt)
end

function ku.msg_info(id,txt)
	msg2(id,"\169"..ku.colors.info.."[KU] [INFO] "..txt)
end

function ku.msg_team(id,src,txt)
	msg2(id,"\169"..ku.colors.teams[player(src,"team")]..txt)
end

function ku.hudtxt2(player,id,txt,x,y)
	parse('hudtxt2 '..player..' '..id..' "'..txt..'" '..x..' '..y..' 0')
end

function ku.updatehud(id)
	for i = ku.HUDTXT_START,ku.HUDTXT_START + 5 do -- eventually adjust the hudids
		if(ku.modchat_r[i]) then
			ku.hudtxt2(id,i,ku.modchat_r[i],10,35 + (15 * i))
		end
	end
end

function ku.clearhud(id)
	for i = ku.HUDTXT_START,ku.HUDTXT_START + 5 do
		if(ku.modchat_r[i]) then
			ku.hudtxt2(id,i,"",0,0)
		end
	end
end

-------------------------------------------------------------------------
----- cs2d utility functions
-------------------------------------------------------------------------

function ku.stripbc(s)
	while(s:sub(-2) == "@C") do -- while -> message could be msg@C@C
		s = s:sub(1,s:len() - 2)
	end
	return s
end

function ku.checkargs(arglist,usage,argnum,src)
	--not possible to have a command that accepts 0 or multiples args  DONE
	local expected = {}
	local args = {}
	local c = 1	

	for arg in string.gmatch(usage,"<(.-)>") do
		table.insert(expected,arg)
	end

	if(#arglist == 0) then
		if(#usage == 0 or argnum == 0) then
			return args
		else
			args.error = "usage : "..usage
			return args
		end
	end
	
	
	while c <= #expected do
		--------------------------------------
		-- handle nil args
		--------------------------------------
		if(arglist[c] == nil or arglist[c] == "") then
			if(c > argnum) then
				return args
				--return already handled params since the others are optional
			else
				args.error = "missing parameter : <"..expected[c]..">"
				return args				-- not all needed params could be set
			end
		end
		--------------------------------------
		-- id/name | id between 1 and maxplayers | name just a name pattern
		--------------------------------------
		-- add possiblity to be able to target yourself ? ( param on cmd registration / differen param name )
		-- '_' to replace spaces in names / first check with '_' if no matches were found replace them with ' ' ( blanks )
		-- support stuff like @me , @ct , @t ? ( )
		-- @me -> args.id = id
		-- add new parameter for regSayCmd to determine if it is suitable for that kind of targeting ? ( banning yourself / a whole team shouldn't be possible)
		if(expected[c] == "id/#name") then
			if(arglist[c]:sub(1,1) == '#') then -- maybe try to use it as plain id , then attempt to find a fitting user name // 0 < id < maxplayers ?
				id,e = ku.get_idByName(arglist[c]:sub(2))
				if(not id) then 
					args.error = e
					return args
				end
			else
				if(tonumber(arglist[c])) then
					id = tonumber(arglist[c])
				else
					args.error = "Invalid parameter format for <"..expected[c]..">"
					return args
				end
			end
			if(player(id,"exists")) then --doesnt accept chars
				args.id = id
			else
				args.error = "Player does not exist!"
				return args
			end
			if(src == id) then 
				args.error = "You can't target yourself!"
				return args
			end	
		--------------------------------------
		-- duration
		--------------------------------------
		--fix 4wasd will  break it ( valid as long as it contains at least 1 number ) | DONE
		elseif (expected[c] == "duration") then
			--if(not arglist[c]:match("%d")) then
			if(not tonumber(arglist[c])) then
				args.error = "Invalid parameter format for <"..expected[c]..">"
				return args
			end
			local duration = math.floor(tonumber(arglist[c])) or 0
			if(duration < 0) then --assume 0 as default on print error on < 0 ?
				args.duration = 0
			elseif(duration > ku.DURATION_MAX) then
				args.duration = ku.DURATION_MAX
			else
				args.duration = duration
			end
		--------------------------------------
		-- reason
		--------------------------------------
		elseif (expected[c] == "reason") then
			local reason = ""
			while(c <= #arglist) do
				if(reason ~= "") then
					reason = reason.." "..arglist[c]
				else
					reason = arglist[c]
				end
				c = c + 1
			end
			args.reason = reason:gsub("\"","")
			--text / always the last param
		--------------------------------------
		-- color
		--------------------------------------
		--accept rainbow ? 
		--accept random ?
		elseif (expected[c] == "color") then
			if(tonumber(arglist[c]) == nil and arglist[c]:lower() ~= "random") then
				args.error = "Invalid parameter format for <"..expected[c]..">"
				return args
			end
			if(ku.isValidColor(arglist[c])) then
				args.color = arglist[c]
			else
				args.error = "Invalid color!"
				return args
			end
			--valid color (0-255)(0-255)(0-255)
		--------------------------------------
		-- name
		--------------------------------------
		elseif (expected[c] == "newname") then -- iterate to the 2nd last param because of the show parameter // only used in setname ( currently iterates through the whole table , intended s)
			--assemble string
			local newname = ""
			while(c <= #arglist) do
				if(newname ~= "") then
					newname = newname.." "..arglist[c]
				else
					newname = arglist[c]
				end
				c = c + 1
			end
			args.newname = newname:gsub("\169","") -- might lead to VISUAL ONLY screwups
		--------------------------------------
		-- message
		--------------------------------------
		elseif(expected[c] == "message") then
			local message = ""
			while(c <= #arglist) do
				if(message ~= "") then
					message = message.." "..arglist[c]
				else
					message = arglist[c]
				end
				message = ku.stripbc(message)
				c = c + 1
			end
			message = message:gsub("\"",""):gsub(";",","):gsub("parse%(.*%)?",""):gsub("\169","")	
			if(message ~= "") then
				args.message = message
			else
				args.error = "Empty message!"
				return args
			end
		--------------------------------------
		-- show
		--------------------------------------
		elseif (expected[c] == "show") then --always optional // not used atm
			if(tonumber(arglist[c]) == nil) then
				args.error = "Invalid parameter format for <"..expected[c]..">"
				return args
			end
			arglist[c] = tonumber(arglist[c])
			if(arglist[c] >= 0 and arglist[c] <= 1) then
				args.show = arglist[c]
			end
		--------------------------------------
		-- command | valid registered command
		--------------------------------------
		elseif (expected[c] == "command") then
			if(not arglist[c] ) then
				return args
			end
			for _,cmd in ipairs(ku.cmds["say"]) do
				--c.name c.shortcut
				if (arglist[c] == cmd.name or arglist[c] == cmd.shortcut) then
					args.command,args.shortcut,args.usage,args.help = cmd.name,cmd.shortcut,cmd.usage,cmd.help-- return position in table or just the name / given parameter
					return args
				end
			end
			args.error = "Command ( "..arglist[c].." ) does not exist!"
			return args
		--------------------------------------
		-- valid registered group
		--------------------------------------
		elseif (expected[c] == "group") then
			if(ku.groups[arglist[c]]) then
				if(arglist[c] == "Unregistered") then
					args.error = "You can't add someone to this group!"
					return args
				end
				args.group = arglist[c]
			else
				args.error = "Group ( "..arglist[c]:gsub("\169","").." ) does not exist!"
				return args
			end
		--------------------------------------
		-- existing map
		--------------------------------------
		elseif (expected[c] == "map") then
			if(ku.f_exists("maps/"..arglist[c]..".map")) then
				args.map = arglist[c]
			else
				args.error = "Map ( "..arglist[c]:gsub("\169","").." ) does not exist!"
				return args
			end
		--------------------------------------
		-- valid usgn
		--------------------------------------
		elseif (expected[c] == "usgn") then
			if(ku.is_validUsgn(arglist[c])) then
				args.usgn = tonumber(arglist[c])
			else
				args.error = arglist[c]:gsub("\169","").." is not a valid USGN ID!"
				return args
			end
		--------------------------------------
		-- bantype ( "name" , "ip" , "usgn" )
		--------------------------------------
		elseif (expected[c] == "bantype") then
			local btype = arglist[c]:upper()
			if(btype == "NAME" ) then
				args.btype = "Name"
			elseif(btype == "IP") then
				args.btype = btype
			elseif(btype == "USGN") then
				args.btype = "USGN ID"
			else
				args.error = '"'..arglist[c]:gsub("\169","")..'" is not a valid bantype ( name,ip,usgn )'
				return args
			end
		--------------------------------------
		-- any kind of text / not sure what's expected
		--------------------------------------
		elseif (expected[c] == "string") then
			local str = ""
			while(c <= #arglist) do
				if(str ~= "") then
					str = str.." "..arglist[c]
				else
					str = arglist[c]
				end
				c = c + 1
			end	
			if(str ~= "") then
				args.str = str	
			else
				args.error = "No parameter given!"
				return args
			end
			--concat all params
		end
		--msg(arglist[c].." | "..expected[c])
		c = c + 1
	end
	return args
end

function ku.is_validUsgn(usgn)
	--rework
	return(tonumber(usgn) ~= nil)
	--[[
	if(type(usgn) == "number") then
		local m = string.match(usgn,"[0-9]*")
		if (m) then 
			return true
		end
	end
	return false
	--]]
end

function ku.exec(cmd,id)
	parse(cmd)
	local log_str = ""
	if(id == 0 or not id) then
		log_str = log_str.." SERVER"
	else
		log_str = log_str..player(id,"usgn").." | "..player(id,"name")
	end
	log_str = log_str.." -> "..cmd
	ku.log(log_str)
end

function ku.getMapsInDir(dir,pat) -- windows version atm
    local i, t, popen = 0, {}, io.popen
    for map in popen('dir "'..dir..'" /B *.map'):lines() do -- windows only
    	if(map:sub(-4) == ".map" and map:match(pat)) then
       	    i = i + 1
      	    t[i] = map:sub(1,-5)
      	end
    end
    return t
end

-------------------------------------------------------------------------
----- cs2d say commands
-------------------------------------------------------------------------
-------------------------------------------------------------------------
----- cs2d moderation commands
-------------------------------------------------------------------------

function ku.kick(id,args)
	--if(args[1] ~= nil) then
	--	cmd = cmd..' "'..args[1]..'"'
	--end
	ku.succ(id,"Kicked : "..player(args.id,"name").." ( IP : "..player(args.id,"ip").." | USGN : "..player(args.id,"usgn").." )")
	--optimize -> like mute
	if(args.reason) then
		ku.exec('kick '..args.id..'	"'..args.reason..'"',id)
	else
		ku.exec('kick '..args.id,id)	
	end
end

function ku.slay(id,args)
	if(player(args.id,"health") > 0 ) then
		ku.succ(id,"Slain : "..player(args.id,"name"))
		ku.exec("sethealth "..args.id.." 0",id)
	else
		ku.err(id,"Target is aready dead!")
	end
end

function ku.setname(id,args)
	ku.succ(id,"Set "..player(args.id,"name").."'s name to : "..args.newname)
	--args.show = args.show or 0
	ku.exec('setname '..args.id..' "'..args.newname..'" 1',id)
end

function ku.setcolor(id,args)
	f = io.open(ku.SETTINGS_USER_SETTINGS_DIR.."/"..player(id,"usgn")..".col","w")
	if(f) then
		f:write(args.color)
		f:close()
	end
	ku.set_Color(id,args.color)
	if(args.color == "random") then
		ku.succ(id,"Your color is now random!")
	else
		msg2(id,"\169"..args.color.."Your new color!")
	end
end

function ku.banip(id,args)
	ku.succ(id,"IP-Banned "..player(args.id,"name").." (IP : "..player(args.id,"ip").." )")
	if(not args.reason) then args.reason = "" end
	if(not args.duration) then args.duration = 0 end
	ku.exec('banip '..args.id..' '..args.duration..' "'..args.reason..'"',id)
end

function ku.banname(id,args)
	ku.succ(id,"NAME-Banned "..player(args.id,"name"))
	if(not args.reason) then args.reason = "" end
	if(not args.duration) then args.duration = 0 end
	ku.exec('banname '..args.id..' '..args.duration..' "'..args.reason..'"',id)
end

function ku.banusgn(id,args) --make specific usgn banning possible / or via !r command ?
	ku.succ(id,"USGN-Banned "..player(args.id,"name").." (USGN : "..player(args.id,"usgn").." )")
	if(not args.reason) then args.reason = "" end
	if(not args.duration) then args.duration = 0 end
	ku.exec('banusgn '..args.id..' '..args.duration..' "'..args.reason..'"',id)
end

function ku.unban(id,args)
	ku.exec('unban '..args.str,id)
	ku.succ(id,"Unbanning : "..args.str)
end

function ku.banlist(id,args)
	ku.tbanlist.expected = true
	ku.tbanlist.ctotal = 0
	ku.tbanlist.ctype = 0
	ku.tbanlist.btype = "* "..args.btype
	ku.tbanlist.list = {}
	ku.msg_info(id,"Look at the console for output!")
	ku.exec('banlist',id)
	print("#?#End of banlist#?#"..id)
end

function ku.mute(id,args)
	-- fix issue unmuted for x seconds and probs reason DONE ( i think )
	local str_id = ""
	local str_src = ""
	if(type(id) == "string") then
		local a = ku.totable(id,",")
		args = {id = tonumber(a[1])}
		id = tonumber(a[2])
	end
	if(ku.muted[args.id] ~= nil) then
		ku.muted[args.id] = nil
		str_id = "You are no longer muted"
		str_src = "Unmuted "..player(args.id,"name")
	else
		ku.muted[args.id] = {}
		ku.muted[args.id].src = id
		--ku.muted[args.id].state = true
		str_id = "You are now muted!"
		str_src = "Muted "..player(args.id,"name")
	end
	if(args.duration and ku.muted[args.id] ~= nil and args.duration > 0) then
		timer(args.duration * 1000,"ku.mute",args.id..","..id,1) -- stuff
		str_src = str_src.." for "..args.duration .." seconds !"
	end
	if(args.reason and ku.muted[args.id] ~= nil) then
		str_src = str_src.." ( Reason : "..args.reason.." )"
		ku.muted[args.id].reason = args.reason
	end
	ku.succ(id,str_src)
	ku.std(args.id,str_id)
end

function ku.changemap(id,args)
	ku.exec("changemap "..args.map,0)
end

function ku.info(id,args)
	if(not args.id) then args.id = id end -- make command avaiable to use on yourself ( if no param is given )
	ku.std(id,"NAME  : "..player(args.id,"name"))
	ku.std(id,"USGN  : "..player(args.id,"usgn"))
	ku.std(id,"IP    : "..player(args.id,"ip"))
	ku.std(id,"SPEED : "..player(args.id,"speedmod"))
	ku.std(id,"PING  : "..player(args.id,"ping")) -- show if bot ?
end

function ku.modchat(id,args)
	if(#ku.modchat_r >= 5) then
		table.remove(ku.modchat_r,1)
	end

	local color = ku.default
	if(ku.users[id].color == "random") then
		color = ku.getRandomColor()
	else
		color = ku.users[id].color
	end

	--args.message = args.message:gsub("parse%(.*%)?","")
	--args.message = args.message:gsub(";",",")
	--args.message = args.message:gsub("\169","")

	--local res = mmsg:match("%(MM%) : (.*)") -- if colortag is used message is empty yet not catched
	--find each occurance of '\169' , save the beginning position , take the next 9 chars and check if it's a valid color , if so -> remove ( removecolortag in either case )
	--inline colortags still working :/

	local mmsg
	if(args.message ~= "") then
		mmsg = '\169'..color..player(id,'name')..' (MM) : '..args.message
	else
		ku.err(id,"Empty message or not allowed symbols were used!")
		return
	end

	table.insert(ku.modchat_r,mmsg)
	print(mmsg) --for the logs

	local players = player(0,"table")
	for _,p in ipairs(players) do
		if(ku.users[id].permissions["modchat"]) then
			if(ku.users[id].settings.mm == 1) then
				ku.updatehud(p)
				--parse('cmsg "\169255255255#'..p..' -> Name : '..player(p,'name')..' | IP : '..player(p,'ip')..' | USGN : '..player(p,'usgn')..'" '..id)
				parse('cmsg "'..mmsg..'" '..p)
			else
				msg2(p,"\169"..color..player(id,"name").." (MM) : "..args.message)  -- add own simulated windows / 5 messages via hudtxt2
			end
		end
	end
end

function ku.help(id,args)
	--args.command,args.shortcut,args.usage,args.help = cmd.name,cmd.shortcut,cmd.usage,cmd.help
	if(args.command) then
		ku.msg_help(id,args.command.." | "..args.shortcut.." "..args.usage)
		ku.msg_help(id,args.help)
	else
		--#TODO print all avaiable commands
		--concat if already existing string + currently being processed string <= 26 else print
		ku.std(id,"List of avaiable commands :")

		local cmdlist = ""
		for c,_ in pairs(ku.users[id].permissions) do
			if(cmdlist == "") then
				cmdlist = c
			elseif (( #cmdlist + #c + 2 ) <= 26 ) then 
				cmdlist = cmdlist..", "..c		
			else
				ku.msg_help(id,cmdlist)
				cmdlist = c
			end
		end
		if(cmdlist ~= "") then
			ku.msg_help(id,cmdlist)
		end
		ku.std(id,"Type !help <command> to get more information about a command.")
	end
end

function ku.settings(id,args)
	local query = ""
	if(ku.users[id].permissions["modchat"]) then
		query = query..",Alternative modchat|"..ku.varToState(ku.users[id].settings.mm)
	end
	if(ku.users[id].permissions["Chatspy"]) then
		query = query..",Chatspy|"..ku.varToState(ku.users[id].settings.cs)
	end
	menu(id,"[KU] Settings,Color|"..ku.varToState(ku.users[id].settings.color)..",Tag|"..ku.varToState(ku.users[id].settings.tag)..query)
		--..",Alternative modchat|"..ku.varToState(ku.users[id].settings.mm)..",Chatspy|"..ku.varToState(ku.users[id].settings.cs))
end

function ku.report(id,args)
	ku.f_write(ku.REPORT_DIR.."\\"..os.date("%d-%m")..".rep","["..os.date("%H:%M:%S").."] Target : "..player(args.id,"name").." ( "..player(args.id,"usgn").." | "..player(args.id,"ip").." ) Reason : "..args.reason.."\n","a")
	ku.f_write(ku.REPORT_DIR.."\\"..os.date("%d-%m")..".rep","["..os.date("%H:%M:%S").."] By : NAME : "..player(id,"name").." | USGN "..player(id,"usgn").." | IP "..player(id,"ip").."\n","a")
	ku.f_write(ku.REPORT_DIR.."\\"..os.date("%d-%m")..".rep","["..os.date("%H:%M:%S").."]-----------------------------------------------------------\n","a")
	ku.succ(id,"Your report has been sent!")
end

function ku.restartround(id,args)
	ku.succ(id,"Restarting round!")
	ku.exec("restartround",id)
end
--[[
	tStr = "Kirby"
function ku.test()
	local res = ""
	local len = 15
	local tStr2 = "13.37.69.88"
	res = tStr..string.rep(" ",len - tStr:len())..tStr2	
	return res
end
msg(ku.test())
tStr = "Kirbyy"
msg(ku.test())
]]
	--red line / o

function ku.playerlist(id,args)
	local tPlayers = player(0,"table")
	local tIP = {}
	local tIPtemp = {}
	local tRes = {}
	local iMCount = 1

	for _,p in ipairs(tPlayers) do
		local ip = player(p,"ip")
		tIP[p] = ip
		tIPtemp[p] = ip
	end

	for iid,ip in ipairs(tIPtemp) do
		local matches = ku.table_count(tIPtemp,ip)

		if #matches >= 2 then
			for k,v in ipairs(matches) do
				tRes[v] = iMCount
				tIPtemp[v] = nil 
			end
			iMCount = iMCount + 1
		end
	end

	for iid,val in ipairs(tPlayers) do
		
		if(tRes[iid]) then
			parse('cmsg "\169'..ku.colors.pl[tRes[iid]]..'#'..iid.."     "..player(iid,"name")..'     '..tIP[iid]..'     '..player(iid,"usgn")..'" '..id)
		else
			parse('cmsg "\169'..ku.colors.white..'#'..iid.."     "..player(iid,"name")..'     '..tIP[iid]..'     '..player(iid,"usgn")..'" '..id)
		end
	end
end

function ku.onlinelist(id,args)
	ku.std(id,"Users online : ")
	for _,p in ipairs(player(0,"table")) do
		if(player(p,"bot")) then

		elseif(ku.users[p].level > 0) then
			ku.std(id,"#"..p.." -> "..player(p,"name").." ( "..ku.users[p].name.." ) | "..ku.users[p].group)
		end
	end
end

function ku.listmaps(id,args)
	local maps = ku.getMapsInDir("maps/",args.str)
	ku.msg_info(id,"See console for output!")
	ku.msg_info(id,'Total matches for "'..args.str..'" : '..#maps)
	parse('cmsg "\169'..ku.colors.green..'List of matches :" '..id)
	for _,map in ipairs(maps) do
		if(map:match(args.str)) then
			parse('cmsg "\169'..ku.colors.orange..map..'" '..id)
		end
	end
end

function ku.tempban(id,args)
	--add custom duration ? min ? ( max already exists ) currently the default tempbantime ( from votekicks ) ( mp_tempbantime )
	local usid = player(args.id,"usgn")
	local ip = player(args.id,"ip")
	local name = player(args.id,"name")
	
	--if(not args.reason) then
	--	args.reason = "tempban ( "..game("mp_tempbantime").." mins )"
	--end

	args.reason = args.reason.." tempban ( "..game("mp_tempbantime").." mins )"
	
	ku.exec('kick '..args.id..' "'..args.reason..'"',0)
	
	if(usid > 0) then
		ku.exec('banusgn '..usid..' -1 "'..args.reason..'"',0)
	end
	ku.exec('banip '..ip..' -1 "'..args.reason..'"',0)	
	ku.succ(id,"tempbanned : "..name.." ( IP : "..ip.." | USGN : "..usid.." ) for "..game("mp_tempbantime").." minutes!")
end

-------------------------------------------------------------------------
----- Administration
-------------------------------------------------------------------------

function ku.adduser(id,args)
	--grouplevel has to be lower than the user's
	--write + append ?
	local usid = player(args.id,"usgn")
	if( usid > 0 ) then
		if ( not ku.users_store[usid] ) then
			if( ku.get_groupLevel(args.group) < ku.users[id].level ) then
				ku.f_write(ku.USER_FILE,"\n"..player(args.id,"name")..","..usid..","..args.group,"a")
				ku.succ(id,'Added user "'..player(args.id,"name")..'" ( '..usid..' ) to '..args.group)
				ku.reloadusers(id,nil)
			else
				ku.err(id,"You can't add users to the selected group! ( level too low / equal )")
			end
		else
			ku.err(id,"User is already registered!")
		end
	else
		ku.err(id,"The target is not logged in to the U.S.G.N.!")
	end
end

function ku.removeuser(id,args)
	--only lover levels are targetable once again
	if(ku.users_store[args.usgn]) then
		if(ku.get_groupLevel(ku.users_store[args.usgn].group) < ku.users[id].level) then
			local users = ku.f_read(ku.USER_FILE)
			for ind,c in ipairs(users) do
				if(tonumber(c:match("%,(.*)%,")) == args.usgn ) then
					local tmp = ku.totable(c,",")
					ku.succ(id,"Removed user "..tmp[1].." ( "..args.usgn.." )")
					table.remove(users,ind)
				end
			end
			f = io.open(ku.USER_FILE,"w")
			if(f) then	
				for ind,line in ipairs(users) do
					f:write(line)
				end
				f:close()
			end
			ku.reloadusers(id,nil)
		else
			ku.err(id,"You can't remove that user!")
		end
	else
		ku.err(id,"There is no user registered with the given usgn!")
	end
end

function ku.reloadusers(id,args)
	ku.users = {}
	ku.get_Users()
	for _,id in ipairs(player(0,"table")) do
		if(not player(id,"bot")) then
			ku.set_user(id)
		end
	end
	ku.succ(id,"Users reloaded!")
end

function ku.listgroups(id,args)
	ku.std(id,"List of groups :")
	for n,g in pairs(ku.groups) do
		local str = ""
		if(n == ku.users[id].group) then
			str = str..">"
		end
		str = str..n.." | Level : "..g["level"]
		ku.std(id,str)
	end
end

function ku.listusers(id,args)

end

function ku.rcon(id,args)
	ku.succ(id,"Executing : "..args.str)
	ku.exec(args.str,id)
end

-------------------------------------------------------------------------
----- initialization
-------------------------------------------------------------------------

function ku.init()
	ku.get_Groups()
	ku.get_Users()
	--ku.get_Clans()
	addhook("join","ku.set_user")	
	addhook("say","ku.say",99999)
	addhook("leave","ku.leave")
	addhook("vote","ku.vote")
	addhook("menu","ku.menu")
	addhook("sayteam","ku.sayteam",99999)
	addhook("log","ku.loghook",99999)
	addhook("radio","ku.radio",99999)
end

ku.init()

--addhook("parse","ku.parse") -- find a way to add console commands
--addhook("rcon","ku.rcon")
--permissions per user / check if group user is in has access
--
--function ku.groupHasAccess(group,cmd)
--end
--
--
--[[
	<id/name> : 0 < id < sv_maxplayers : name string with '#' prefix
	<duration> : valid number
	<reason> : string : last param since length is not fix
	<color> : valid color
	<newname> : string
	<show> : 0/1 0 -> show , 1 -> hide
	[ ] : surrounds optional paramters
]]--
-- ban command ( bans usgn if avaiable , ip if not  )

--------------------------------------
--  essentials
--------------------------------------
ku.regSayCmd("onlinelist","o",0,"",ku.onlinelist,"Shows online users")
ku.regSayCmd("reloadusers","ru",0,"",ku.reloadusers,"Reloads the users")
ku.regSayCmd("setcol","sc",1,"<color>",ku.setcolor,"Sets your chatcolor")
ku.regSayCmd("settings","set",0,"",ku.settings,"Opens a settings window")
ku.regSayCmd("help","h",0,"[<command>]",ku.help,"Shows the help for a command")
ku.regPermEx("nokick","nk")
--------------------------------------
--  well dunno
--------------------------------------
--ku.regSayCmd("report","rep",2,"<id/#name> <reason>",ku.report,"Reports a player who is currently ingame")-- ( message to any mod online | if none online save report ? )
--------------------------------------
--  moderation 
--------------------------------------
ku.regSayCmd("info","i",0,"[<id/#name>]",ku.info,"Displays info about a player") -- if no param is given it'll target yourself
ku.regSayCmd("playerlist","pl",0,"",ku.playerlist,"Prints a playerlist to the console")
ku.regSayCmd("tempban","tb",1,"<id/#name> [<reason>]",ku.tempban,"Bans a player temporarily name , ip & usgn")
--ku.regSayCmd("reload","rl",0,"",ku.reload,"Reloads the script") > W I P <
ku.regSayCmd("slay","s",1,"<id/#name>",ku.slay,"Slays a user")
ku.regSayCmd("mute","m",1,"<id/#name> [<duration> <reason>]",ku.mute,"Mutes a user")
ku.regSayCmd("kick","k",1,"<id/#name> [<reason>]",ku.kick,"Kicks a player by id / name")
ku.regSayCmd("banip","bi",1,"<id/#name> [<duration> <reason>]",ku.banip,"Bans a player by IP")
ku.regSayCmd("banusgn","bu",1,"<id/#name> [<duration> <reason>]",ku.banusgn,"Bans a player by USGN")
ku.regSayCmd("banname","bn",1,"<id/#name> [<duration> <reason>]",ku.banname,"Bans a player by name")
ku.regSayCmd("setname","sn",2,"<id/#name> <newname>",ku.setname,"Sets a player's name") -- [<show>]" -- if show is not given the name is the 2ndlast param | removed for now | default 0 ( hide ) | newname -> '_' instead of spaces ? so it's 1 limited param
ku.regSayCmd("modchat","mm",1,"<message>",ku.modchat,"Sends a message to all moderators online")
ku.regSayCmd("changemap","map",1,"<map>",ku.changemap,"Changes the map") 
ku.regSayCmd("listmaps","lm",1,"<string>",ku.listmaps,"Lists up to 15 maps matching the string")
ku.regSayCmd("restartround","rr",0,"",ku.restartround,"Restarts the round")
ku.regSayCmd("unban","ub",1,"<string>",ku.unban,"Unbans the given ip/usgn/name")
ku.regPermEx("chatspy","cs")
--------------------------------------
--  administration
--------------------------------------
ku.regSayCmd("rcon","r",1,"<string>",ku.rcon,"Executes an rcon/lua command")
ku.regSayCmd("listgroups","lg",0,"",ku.listgroups,"Lists all current groups")
ku.regSayCmd("adduser","addu",2,"<id/#name> <group>",ku.adduser,"Adds a user to a group")
ku.regSayCmd("removeuser","remu",1,"<usgn>",ku.removeuser,"Removes a user")
ku.regSayCmd("banlist","bl",1,"<bantype>",ku.banlist,"Shows the 15 most recent bans of a given type ( name,usgn,ip )") 
--ku.regSayCmd("listusers","lu",0,"",ku.listusers,"Shows all registered useres in the console") -- TODO
--[[  

--W I P

ku.regSayCmd("report","rep",2,"<id> <reason>",ku.report,"Reports a player")

--/ W I P

]]