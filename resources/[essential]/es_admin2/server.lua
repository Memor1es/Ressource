TriggerEvent("es:addGroup", "mod", "user", function(group) end)

-- Modify if you want, btw the _admin_ needs to be able to target the group and it will work
local groupsRequired = {slay = "mod", noclip = "admin", ghost = "admin", crash = "superadmin", freeze = "mod", bring = "mod", ["goto"] = "mod", slap = "mod", heal = "mod", kick = "mod", ban = "admin"}
local banned = ""
local bannedTable = {}
local admin = ""

function loadBans()
	banned = LoadResourceFile("es_admin2", "data/bans.txt") or ""
	if banned then
		local b = stringsplit(banned, "\n")
		for k,v in ipairs(b) do
			bannedTable[v] = true
		end
	end
end

function isBanned(id)
	return bannedTable[id]
end

function banUser(id)
	banned = banned .. id .. "\n"
	SaveResourceFile("es_admin2", "data/bans.txt", banned, -1)
	bannedTable[id] = true
end

AddEventHandler('playerConnecting', function(user, set)
	for k,v in ipairs(GetPlayerIdentifiers(source))do
		if isBanned(v) then
			set(GetConvar("es_admin_banreason", "Vous êtes bannis du serveur !"))
			CancelEvent()
			break
		end
	end
end)

RegisterServerEvent('es_admin:all')
AddEventHandler('es_admin:all', function(type)
	local Source = source
	TriggerEvent('es:getPlayerFromId', source, function(user)
		TriggerEvent('es:canGroupTarget', user.getGroup(), "admin", function(available)
			if available or user.getGroup() == "superadmin" then
				if type == "slay_all" then TriggerClientEvent('es_admin:quick', -1, 'slay') end
				if type == "heal_all" then TriggerClientEvent('es_admin:quick', -1, 'heal') end
				if type == "bring_all" then TriggerClientEvent('es_admin:quick', -1, 'bring', Source) end
				if type == "slap_all" then TriggerClientEvent('es_admin:quick', -1, 'slap') end
			else
				TriggerClientEvent('chatMessage', Source, "SYSTÈME", {255, 0, 0}, "Votre grade ne peut pas utiliser cette commande")
			end
		end)
	end)
end)

RegisterServerEvent('es_admin:quick')
AddEventHandler('es_admin:quick', function(id, type)
	local Source = source
	TriggerEvent('es:getPlayerFromId', source, function(user)
		TriggerEvent('es:getPlayerFromId', id, function(target)
			TriggerEvent('es:canGroupTarget', user.getGroup(), groupsRequired[type], function(available)
				print('Available?: ' .. tostring(available))
				TriggerEvent('es:canGroupTarget', user.getGroup(), target.getGroup(), function(canTarget)
					if canTarget and available then
						if type == "slay" then TriggerClientEvent('es_admin:quick', id, type) end
						if type == "noclip" then TriggerClientEvent('es_admin:quick', id, type) end
						if type == "freeze" then TriggerClientEvent('es_admin:quick', id, type) end
						if type == "crash" then TriggerClientEvent('es_admin:quick', id, type) end
						if type == "bring" then TriggerClientEvent('es_admin:quick', id, type, Source) end
						if type == "goto" then TriggerClientEvent('es_admin:quick', Source, type, id) end
						if type == "slap" then TriggerClientEvent('es_admin:quick', id, type) end
						if type == "heal" then TriggerClientEvent('es_admin:quick', id, type) end
						if type == "kick" then DropPlayer(id, 'kick by es_admin GUI') end
						if type == "ban" then
							for k,v in ipairs(GetPlayerIdentifiers(id))do
								banUser(v)
							end
							DropPlayer(id, GetConvar("es_admin_banreason", "Vous êtes bannis du serveur !"))
						end
					else
						if not available then
							TriggerClientEvent('chatMessage', Source, 'SYSTÈME', {255, 0, 0}, "Votre grade ne peut pas utiliser cette commande.")
						else
							TriggerClientEvent('chatMessage', Source, 'SYSTÈME', {255, 0, 0}, "Permission refusée.")
						end
					end
				end)
			end)
		end)
	end)
end)

AddEventHandler('es:firstSpawn', function(Source, user)
	TriggerClientEvent('es_admin:setGroup', source, user.getGroup())
end)

RegisterServerEvent('es_admin:set')
AddEventHandler('es_admin:set', function(t, USER, GROUP)
	local Source = source
	TriggerEvent('es:getPlayerFromId', source, function(user)
		TriggerEvent('es:canGroupTarget', user.getGroup(), "superadmin", function(available)
			if available then
			if t == "group" then
				if(GetPlayerName(USER) == nil)then
					TriggerClientEvent('chatMessage', source, 'SYSTÈME', {255, 0, 0}, "Joueur non trouvé")
				else
					TriggerEvent("es:getAllGroups", function(groups)
						if(groups[GROUP])then
							TriggerEvent("es:setPlayerData", USER, "group", GROUP, function(response, success)
								TriggerClientEvent('es_admin:setGroup', USER, GROUP)
								TriggerClientEvent('chatMessage', -1, "CONSOLE", {0, 0, 0}, "Groupe ^2^*" .. GetPlayerName(tonumber(USER)) .. "^r^0 a été réglé sur ^2^*" .. GROUP)
							end)
						else
							TriggerClientEvent('chatMessage', source, 'SYSTÈME', {255, 0, 0}, "Joueur non trouvé")
						end
					end)
				end
			elseif t == "level" then
				if(GetPlayerName(USER) == nil)then
					TriggerClientEvent('chatMessage', source, 'SYSTÈME', {255, 0, 0}, "Joueur non trouvé")
				else
					GROUP = tonumber(GROUP)
					if(GROUP ~= nil and GROUP > -1)then
						TriggerEvent("es:setPlayerData", USER, "permission_level", GROUP, function(response, success)
							if(true)then
								TriggerClientEvent('chatMessage', -1, "CONSOLE", {0, 0, 0}, "Niveau d'autorisation ^2" .. GetPlayerName(tonumber(USER)) .. "^0 a été réglé sur ^2 " .. tostring(GROUP))
							end
						end)	
					else
						TriggerClientEvent('chatMessage', source, 'SYSTÈME', {255, 0, 0}, "Nombre incorrect")
					end
				end
			elseif t == "money" then
				if(GetPlayerName(USER) == nil)then
					TriggerClientEvent('chatMessage', source, 'SYSTÈME', {255, 0, 0}, "Joueur non trouvé")
				else
					GROUP = tonumber(GROUP)
					if(GROUP ~= nil and GROUP > -1)then
						TriggerEvent('es:getPlayerFromId', USER, function(target)
							target.setMoney(GROUP)
						end)
					else
						TriggerClientEvent('chatMessage', source, 'SYSTÈME', {255, 0, 0}, "Nombre incorrect")
					end
				end
			elseif t == "bank" then
				if(GetPlayerName(USER) == nil)then
					TriggerClientEvent('chatMessage', source, 'SYSTÈME', {255, 0, 0}, "Joueur non trouvé")
				else
					GROUP = tonumber(GROUP)
					if(GROUP ~= nil and GROUP > -1)then
						TriggerEvent('es:getPlayerFromId', USER, function(target)
							target.setBankBalance(GROUP)
						end)
					else
						TriggerClientEvent('chatMessage', source, 'SYSTÈME', {255, 0, 0}, "Nombre incorrect")
					end
				end
			end
			else
				TriggerClientEvent('chatMessage', source, 'SYSTÈME', {255, 0, 0}, "Le grade superadmin est nécessaire pour le faire.")
			end
		end)
	end)	
end)

-- Rcon commands
AddEventHandler('rconCommand', function(commandName, args)
	if commandName == 'setadmin' then
		if #args ~= 2 then
				RconPrint("Usage: setadmin [user-id] [permission-level]\n")
				CancelEvent()
				return
		end

		if(GetPlayerName(tonumber(args[1])) == nil)then
			RconPrint("Joueur pas en jeu\n")
			CancelEvent()
			return
		end

		TriggerEvent("es:setPlayerData", tonumber(args[1]), "permission_level", tonumber(args[2]), function(response, success)
			RconPrint(response)

			if(true)then
				print(args[1] .. " " .. args[2])
				TriggerClientEvent('es:setPlayerDecorator', tonumber(args[1]), 'rank', tonumber(args[2]), true)
				TriggerClientEvent('chatMessage', -1, "CONSOLE", {0, 0, 0}, "Niveau d'autorisation ^2" .. GetPlayerName(tonumber(args[1])) .. "^0 a été réglé sur ^2 " .. args[2])
			end
		end)

		CancelEvent()
	elseif commandName == 'setgroup' then
		if #args ~= 2 then
				RconPrint("Usage: setgroup [user-id] [group]\n")
				CancelEvent()
				return
		end

		if(GetPlayerName(tonumber(args[1])) == nil)then
			RconPrint("Joueur pas en jeu\n")
			CancelEvent()
			return
		end

		TriggerEvent("es:getAllGroups", function(groups)

			if(groups[args[2]])then
				TriggerEvent("es:setPlayerData", tonumber(args[1]), "group", args[2], function(response, success)
					RconPrint(response)

					if(true)then
						print(args[1] .. " " .. args[2])
						TriggerClientEvent('es:setPlayerDecorator', tonumber(args[1]), 'group', tonumber(args[2]), true)
						TriggerClientEvent('chatMessage', -1, "CONSOLE", {0, 0, 0}, "Groupe ^2^*" .. GetPlayerName(tonumber(args[1])) .. "^r^0 a été réglé sur ^2^*" .. args[2])
					end
				end)
			else
				RconPrint("Ce groupe n'existe pas.\n")
			end
		end)

		CancelEvent()
	elseif commandName == 'setmoney' then
			if #args ~= 2 then
					RconPrint("Usage: setmoney [user-id] [money]\n")
					CancelEvent()
					return
			end

			if(GetPlayerName(tonumber(args[1])) == nil)then
				RconPrint("Joueur pas en jeu\n")
				CancelEvent()
				return
			end

			TriggerEvent("es:getPlayerFromId", tonumber(args[1]), function(user)
				if(user)then
					user.setMoney(tonumber(args[2]))

					RconPrint("Money give")
					TriggerClientEvent('chatMessage', tonumber(args[1]), "CONSOLE", {0, 0, 0}, "Votre argent a été réglé sur: ^2^*$" .. tonumber(args[2]))
				end
			end)

			CancelEvent()
		end
end)

-- Default commands
TriggerEvent('es:addCommand', 'admin', function(source, args, user)
	TriggerClientEvent('chatMessage', source, "SYSTÈME", {255, 0, 0}, "Niveau: ^*^2 " .. tostring(user.get('permission_level')))
	TriggerClientEvent('chatMessage', source, "SYSTÈME", {255, 0, 0}, "Groupe: ^*^2 " .. user.getGroup())
end, {help = "Indique quel niveau d'administration vous êtes et dans quel groupe vous êtes."})

-- Default commands
TriggerEvent('es:addCommand', 'report', function(source, args, user)
	table.remove(args, 1)
	TriggerClientEvent('chatMessage', source, "REPORT", {255, 0, 0}, " (^2" .. GetPlayerName(source) .." | "..source.."^0) " .. table.concat(args, " "))

	TriggerEvent("es:getPlayers", function(pl)
		for k,v in pairs(pl) do
			TriggerEvent("es:getPlayerFromId", k, function(user)
				if(user.getPermissions() > 0 and k ~= source)then
					TriggerClientEvent('chatMessage', k, "REPORT", {255, 0, 0}, " (^2" .. GetPlayerName(source) .." | "..source.."^0) " .. table.concat(args, " "))
				end
			end)
		end
	end)
end, {help = "Signaler un joueur ou un problème", params = {{name = "report", help = "Ce que vous voulez signaler"}}})

-- Append a message
function appendNewPos(msg)
	local file = io.open('resources/[essential]/es_admin2/positions.txt', "a")
	newFile = msg
	file:write(newFile)
	file:flush()
	file:close()
end

-- Do them hashes
function doHashes()
  lines = {}
  for line in io.lines("resources/[essential]/es_admin2/input.txt") do
  	lines[#lines + 1] = line
  end

  return lines
end


RegisterServerEvent('es_admin:givePos')
AddEventHandler('es_admin:givePos', function(str)
	appendNewPos(str)
end)

-- Noclip
TriggerEvent('es:addGroupCommand', 'noclip', "admin", function(source, args, user)
	TriggerClientEvent("es_admin:noclip", source)
	SaveResourceFile("es_admin2", "data/admin.txt", admin, -1)
end, function(source, args, user)
	TriggerClientEvent('chatMessage', source, "SYSTÈME", {255, 0, 0}, "Permissions insuffisantes !")
end, {help = "Activer ou désactiver noclip"})

-- ghost
TriggerEvent('es:addGroupCommand', 'ghost', "admin", function(source, args, user)
	TriggerClientEvent("es_admin:ghost", source)
end, function(source, args, user)
	TriggerClientEvent('chatMessage', source, "SYSTÈME", {255, 0, 0}, "Permissions insuffisantes !")
end, {help = "Activer ou désactiver le mode fantôme"})

-- Kicking
TriggerEvent('es:addGroupCommand', 'kick', "mod", function(source, args, user)
	if args[2] then
		if(GetPlayerName(tonumber(args[2])))then
			local player = tonumber(args[2])

			-- User permission check
			TriggerEvent("es:getPlayerFromId", player, function(target)

				local reason = args
				table.remove(reason, 1)
				table.remove(reason, 1)
				if(#reason == 0)then
					reason = "Kick: Vous avez été kick du serveur !"
				else
					reason = "Kick: " .. table.concat(reason, " ")
				end

				TriggerClientEvent('chatMessage', -1, "SYSTÈME", {255, 0, 0}, "Player ^2" .. GetPlayerName(player) .. "^0 a été kick(^2" .. reason .. "^0)")
				DropPlayer(player, reason)
			end)
		else
			TriggerClientEvent('chatMessage', source, "SYSTÈME", {255, 0, 0}, "ID de joueur incorrect !")
		end
	else
		TriggerClientEvent('chatMessage', source, "SYSTÈME", {255, 0, 0}, "ID de joueur incorrect !")
	end
end, function(source, args, user)
	TriggerClientEvent('chatMessage', source, "SYSTÈME", {255, 0, 0}, "Permissions insuffisantes !")
end, {help = "Kick un utilisateur avec la raison spécifiée ou aucune raison", params = {{name = "userid", help = "L'identifiant du joueur"}, {name = "reason", help = "La raison pour laquelle vous voulez kick ce joueur"}}})

--[[ Announcing
TriggerEvent('es:addGroupCommand', 'announce', "mod", function(source, args, user)
	table.remove(args, 1)
	TriggerClientEvent('chatMessage', -1, "ANNOUNCEMENT", {255, 0, 0}, "" .. table.concat(args, " "))
end, function(source, args, user)
	TriggerClientEvent('chatMessage', source, "SYSTÈME", {255, 0, 0}, "Permissions insuffisantes !")
end, {help = "Annoncer un message à l'ensemble du serveur", params = {{name = "announcement", help = "Le message à annoncer"}}})]]--

-- Freezing
local frozen = {}
TriggerEvent('es:addGroupCommand', 'freeze', "mod", function(source, args, user)
	if args[2] then
		if(GetPlayerName(tonumber(args[2])))then
			local player = tonumber(args[2])

			-- User permission check
			TriggerEvent("es:getPlayerFromId", player, function(target)

				if(frozen[player])then
					frozen[player] = false
				else
					frozen[player] = true
				end

				TriggerClientEvent('es_admin:freezePlayer', player, frozen[player])

				local state = "unfrozen"
				if(frozen[player])then
					state = "frozen"
				end

				TriggerClientEvent('chatMessage', player, "SYSTÈME", {255, 0, 0}, "Tu as été " .. state .. " par ^2" .. GetPlayerName(source))
				TriggerClientEvent('chatMessage', source, "SYSTÈME", {255, 0, 0}, "Player ^2" .. GetPlayerName(player) .. "^0 a été " .. state)
			end)
		else
			TriggerClientEvent('chatMessage', source, "SYSTÈME", {255, 0, 0}, "ID de joueur incorrect !")
		end
	else
		TriggerClientEvent('chatMessage', source, "SYSTÈME", {255, 0, 0}, "ID de joueur incorrect !")
	end
end, function(source, args, user)
	TriggerClientEvent('chatMessage', source, "SYSTÈME", {255, 0, 0}, "Permissions insuffisantes !")
end, {help = "Freeze ou libérer un utilisateur", params = {{name = "userid", help = "L'identifiant du joueur"}}})

-- Bring
local frozen = {}
TriggerEvent('es:addGroupCommand', 'bring', "mod", function(source, args, user)
	if args[2] then
		if(GetPlayerName(tonumber(args[2])))then
			local player = tonumber(args[2])

			-- User permission check
			TriggerEvent("es:getPlayerFromId", player, function(target)

				TriggerClientEvent('es_admin:teleportUser', target.get('source'), user.getCoords().x, user.getCoords().y, user.getCoords().z)

				TriggerClientEvent('chatMessage', player, "SYSTÈME", {255, 0, 0}, "Vous avez teleporté par ^2" .. GetPlayerName(source))
				TriggerClientEvent('chatMessage', source, "SYSTÈME", {255, 0, 0}, "Player ^2" .. GetPlayerName(player) .. "^0 a été teleporté")
			end)
		else
			TriggerClientEvent('chatMessage', source, "SYSTÈME", {255, 0, 0}, "ID de joueur incorrect !")
		end
	else
		TriggerClientEvent('chatMessage', source, "SYSTÈME", {255, 0, 0}, "ID de joueur incorrect !")
	end
end, function(source, args, user)
	TriggerClientEvent('chatMessage', source, "SYSTÈME", {255, 0, 0}, "Permissions insuffisantes !")
end, {help = "Téléporter un utilisateur vers vous", params = {{name = "userid", help = "L'identifiant du joueur"}}})

-- Bring
local frozen = {}
TriggerEvent('es:addGroupCommand', 'slap', "admin", function(source, args, user)
	if args[2] then
		if(GetPlayerName(tonumber(args[2])))then
			local player = tonumber(args[2])

			-- User permission check
			TriggerEvent("es:getPlayerFromId", player, function(target)

				TriggerClientEvent('es_admin:slap', player)

				TriggerClientEvent('chatMessage', player, "SYSTÈME", {255, 0, 0}, "Vous avez été slap par ^2" .. GetPlayerName(source))
				TriggerClientEvent('chatMessage', source, "SYSTÈME", {255, 0, 0}, "Player ^2" .. GetPlayerName(player) .. "^0 a été slap")
			end)
		else
			TriggerClientEvent('chatMessage', source, "SYSTÈME", {255, 0, 0}, "ID de joueur incorrect !")
		end
	else
		TriggerClientEvent('chatMessage', source, "SYSTÈME", {255, 0, 0}, "ID de joueur incorrect !")
	end
end, function(source, args, user)
	TriggerClientEvent('chatMessage', source, "SYSTÈME", {255, 0, 0}, "Permissions insuffisantes !")
end, {help = "Slap un joueur", params = {{name = "userid", help = "L'identifiant du joueur"}}})

-- Freezing
local frozen = {}
TriggerEvent('es:addGroupCommand', 'goto', "mod", function(source, args, user)
	if args[2] then
		if(GetPlayerName(tonumber(args[2])))then
			local player = tonumber(args[2])

			-- User permission check
			TriggerEvent("es:getPlayerFromId", player, function(target)
				if(target)then

					TriggerClientEvent('es_admin:teleportUser', source, target.getCoords().x, target.getCoords().y, target.getCoords().z)

					TriggerClientEvent('chatMessage', player, "SYSTÈME", {255, 0, 0}, "Vous avez été téléporté par ^2" .. GetPlayerName(source))
					TriggerClientEvent('chatMessage', source, "SYSTÈME", {255, 0, 0}, "Téléporté au joueur ^2" .. GetPlayerName(player) .. "")
				end
			end)
		else
			TriggerClientEvent('chatMessage', source, "SYSTÈME", {255, 0, 0}, "ID de joueur incorrect !")
		end
	else
		TriggerClientEvent('chatMessage', source, "SYSTÈME", {255, 0, 0}, "ID de joueur incorrect !")
	end
end, function(source, args, user)
	TriggerClientEvent('chatMessage', source, "SYSTÈME", {255, 0, 0}, "Permissions insuffisantes !")
end, {help = "Se téléporter vers un utilisateur", params = {{name = "userid", help = "L'identifiant du joueur"}}})

-- Kill yourself
TriggerEvent('es:addCommand', 'die', function(source, args, user)
	TriggerClientEvent('es_admin:kill', source)
	TriggerClientEvent('chatMessage', source, "", {0,0,0}, "^1^*Tu t'es tué.")
end, {help = "Suicide"})

-- Killing
TriggerEvent('es:addGroupCommand', 'slay', "admin", function(source, args, user)
	if args[2] then
		if(GetPlayerName(tonumber(args[2])))then
			local player = tonumber(args[2])

			-- User permission check
			TriggerEvent("es:getPlayerFromId", player, function(target)

				TriggerClientEvent('es_admin:kill', player)

				TriggerClientEvent('chatMessage', player, "SYSTÈME", {255, 0, 0}, "Vous avez été tué par ^2" .. GetPlayerName(source))
				TriggerClientEvent('chatMessage', source, "SYSTÈME", {255, 0, 0}, "Player ^2" .. GetPlayerName(player) .. "^0 a été tué.")
			end)
		else
			TriggerClientEvent('chatMessage', source, "SYSTÈME", {255, 0, 0}, "ID de joueur incorrect !")
		end
	else
		TriggerClientEvent('chatMessage', source, "SYSTÈME", {255, 0, 0}, "ID de joueur incorrect !")
	end
end, function(source, args, user)
	TriggerClientEvent('chatMessage', source, "SYSTÈME", {255, 0, 0}, "Permissions insuffisantes !")
end, {help = "Slay un joueur", params = {{name = "userid", help = "L'identifiant du joueur"}}})

-- Heal 
TriggerEvent('es:addGroupCommand', 'heal', "mod", function(source, args, user)
	if args[2] then
		if(GetPlayerName(tonumber(args[2])))then
			local player = tonumber(args[2])

			-- User permission check
			TriggerEvent("es:getPlayerFromId", player, function(target)

				TriggerClientEvent('es_admin:heal', player)

				TriggerClientEvent('chatMessage', player, "SYSTÈME", {255, 0, 0}, "Vous avez été soigné par ^2" .. GetPlayerName(source))
				TriggerClientEvent('chatMessage', source, "SYSTÈME", {255, 0, 0}, "Player ^2" .. GetPlayerName(player) .. "^0 a été soigné.")
			end)
		else
			TriggerClientEvent('chatMessage', source, "SYSTÈME", {255, 0, 0}, "ID de joueur incorrect !")
		end
	else
		TriggerClientEvent('chatMessage', source, "SYSTÈME", {255, 0, 0}, "ID de joueur incorrect !")
	end
end, function(source, args, user)
	TriggerClientEvent('chatMessage', source, "SYSTÈME", {255, 0, 0}, "Permissions insuffisantes !")
end, {help = "Soigner un joueur", params = {{name = "userid", help = "L'identifiant du joueur"}}})


-- Crashing
TriggerEvent('es:addGroupCommand', 'crash', "superadmin", function(source, args, user)
	if args[2] then
		if(GetPlayerName(tonumber(args[2])))then
			local player = tonumber(args[2])

			-- User permission check
			TriggerEvent("es:getPlayerFromId", player, function(target)

				TriggerClientEvent('es_admin:crash', player)

				TriggerClientEvent('chatMessage', source, "SYSTÈME", {255, 0, 0}, "Player ^2" .. GetPlayerName(player) .. "^0 a été Crash.")
			end)
		else
			TriggerClientEvent('chatMessage', source, "SYSTÈME", {255, 0, 0}, "ID de joueur incorrect !")
		end
	else
		TriggerClientEvent('chatMessage', source, "SYSTÈME", {255, 0, 0}, "ID de joueur incorrect !")
	end
end, function(source, args, user)
	TriggerClientEvent('chatMessage', source, "SYSTÈME", {255, 0, 0}, "Permissions insuffisantes !")
end, {help = "Crash un utilisateur, aucune idée pourquoi cela existe toujours =D", params = {{name = "userid", help = "L'identifiant du joueur"}}})

-- Position
TriggerEvent('es:addGroupCommand', 'pos', "mod", function(source, args, user)
	TriggerClientEvent('es_admin:givePosition', source)
end, function(source, args, user)
	TriggerClientEvent('chatMessage', source, "SYSTÈME", {255, 0, 0}, "Permissions insuffisantes !")
end, {help = "Enregistrer la position dans le fichier"})

function stringsplit(inputstr, sep)
	if sep == nil then
		sep = "%s"
	end
	local t={} ; i=1
	for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
		t[i] = str
		i = i + 1
	end
	return t
end

TriggerEvent('es:addGroupCommand', 'name', "admin", function(source, args, user)
	TriggerClientEvent("es_admin:name", source)
	TriggerClientEvent('chatMessage', source, "SYSTÈME", {255, 0, 0}, "Viewname activé!")
end, function(source, args, user)
    TriggerClientEvent('chatMessage', source, "SYSTÈME", {255, 0, 0}, "Permissions insuffisantes!")
end)

TriggerEvent('es:addGroupCommand', 'blackout', "admin", function(source, args, user)
	TriggerClientEvent('es:Blackout', -1, toggle)
end)

TriggerEvent('es:addGroupCommand', 'blackoutoff', "admin", function(source, args, user)
	TriggerClientEvent('es:BlackoutOff', -1, toggle)
end)

TriggerEvent('es:addGroupCommand', 'NpcOn', "admin", function(source, args, user)
	TriggerClientEvent('es:NpcOn', -1, toggle)
end)

TriggerEvent('es:addGroupCommand', 'NpcOff', "admin", function(source, args, user)
	TriggerClientEvent('es:NpcOff', -1, toggle)
end)

TriggerEvent('es:addGroupCommand', 'menu', "mod", function(source, args, user)
	TriggerClientEvent('es:openmenu', source, toggle)
	print(GetPlayerName(source) .. " vien d'ouvrir le menu")
end, function(source, args, user)
	TriggerClientEvent('chatMessage', source, "SYSTÈME", {255, 0, 0}, "Permissions insuffisantes!")
	print(GetPlayerName(source) .. " vien de vouloir ouvrir le menu")
end)


loadBans()
