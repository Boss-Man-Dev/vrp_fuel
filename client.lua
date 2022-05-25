--##########	VRP Main	##########--
-- init vRP server context
Tunnel = module("vrp", "lib/Tunnel")
Proxy = module("vrp", "lib/Proxy")

local cvRP = module("vrp", "client/vRP")
vRP = cvRP()

local pvRP = {}
pvRP.loadScript = module
Proxy.addInterface("vRP", pvRP)

local cfg = module("vrp_fuel", "cfg/cfg")
local Fuel = class("Fuel", vRP.Extension)

Fuel.event = {}
Fuel.tunnel = {}

function Fuel:__construct()
    vRP.Extension.__construct(self)
	
	self.isNearPump = false
	self.isFueling = false
	self.currentCost = 0
	self.currentCash = 0
	self.fuelSynced = false
	self.inBlacklisted = false
	self.lastVeh = 0

	self.keys = {}
	self.keys = {}
	
	-- sets nearest pump
	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(0)
			local pumpNearby = self.getNearestPumps(5)
			local pumpMarker = self.getNearestPumps(50)
			local ped = GetPlayerPed(-1)
			local vehicle = GetVehiclePedIsIn(ped)
			
			-- handles getting pumps
			for obj, dist in pairs(pumpNearby) do
				if dist <= 3.0 then
					self.isNearPump = obj
				end
			end
			
			for _, v in pairs(self.keys) do
				DisableControlAction(0, v)
			end
			
			-- places maker around pump props
			for obj, dist in pairs(pumpMarker) do
				if dist >= 0.5 then
					local x,y,z = table.unpack(GetEntityCoords(obj))
					local t, dX, dY, dZ, rX, rY, rZ, sX, sY, sZ, r, g, b, a, b, f, p, r, tD, tN, d = table.unpack(cfg.marker.pump)
					DrawMarker(t, x,y,z + 0.5, dX, dY, dZ, rX, rY, rZ, sX, sY, sZ, r, g, b, a, b, f, p, r, tD, tN, d)
				end
			end
			
			--checks blacklist
			if vehicle then
				if DoesEntityExist(vehicle) and IsEntityAVehicle(vehicle) and not IsEntityDead(vehicle) then
					if GetPedInVehicleSeat(vehicle, -1) == PlayerPedId() then
						for _,car in pairs(cfg.blacklist) do
							local model = GetEntityModel(vehicle)
							if GetHashKey(car) == model then
								self.inBlacklisted = true
							else
								self.inBlacklisted = false
								self:ManageFuelUsage(vehicle)
							end
						end
					end
				else
					self.inBlacklisted = false
					self.fuelSynced = false
				end
			end
			
			-- speedometer
			if IsPedInAnyVehicle(GetPlayerPed(-1)) and cfg.hud then
				local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1))
				local class = GetVehicleClass(vehicle)
				if class ~= 15 and class ~= 16 and class ~=21 and class ~=13 then		-- We don't want planes, helicopters, bicycles and trains
					mph = tostring(math.ceil(GetEntitySpeed(vehicle) * 2.236936))
					kmh = tostring(math.ceil(GetEntitySpeed(vehicle) * 3.6))
					fuel = tostring(math.ceil(GetVehicleFuelLevel(vehicle)))
								
					--x,y,width,height,scale,text,r,g,b,a,font,jus
					local mx,my,mw,mh,ms,mr,mg,mb,ma,mf,j = table.unpack(cfg.speedometer.mph)
					local kx,ky,kw,kh,ks,kr,kg,kb,ka,kf,kj = table.unpack(cfg.speedometer.kmh)
					local fx,fy,fw,fh,fs,fr,fg,fb,fa,ff,fj = table.unpack(cfg.speedometer.fuel)
					
					DrawAdvancedText(mx,my,mw,mh,ms, ""..mph.."  mp/h", mr,mg,mb,ma,mf,j)
					DrawAdvancedText(kx,ky,kw,kh,ks, ""..kmh.."  km/h", kr,kg,kb,ka,kf,kj)
					DrawAdvancedText(fx,fy,fw,fh,fs, ""..fuel.." Fuel", fr,fg,fb,fa,ff,fj)
				end
			end
			
			-- random fuel for any new vehicle you enter
			if IsPedInAnyVehicle(GetPlayerPed(-1)) then
				local currentVeh = GetVehiclePedIsUsing(GetPlayerPed(-1))
				if currentVeh ~= self.lastVeh then
					SetVehicleFuelLevel(currentVeh, math.random(25, 100) + 0.0)
					
					self.lastVeh = currentVeh
				end
			end
		end
	end)

	-- prepares pump 
	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(0)
			local ped = GetPlayerPed(-1)
			local vehicle = GetVehiclePedIsIn(ped, true)
			local x,y,z = table.unpack(GetEntityCoords(ped))	-- player cords
			local px,py,pz = table.unpack(GetEntityCoords(self.isNearPump)) -- pump cords
			local vx,vy,vz = table.unpack(GetEntityCoords(vehicle))	-- vehicle cords
			local class = GetVehicleClass(vehicle)
			self.remote._test()
			
			if class ~= 15 and class ~= 16 and class ~=21 and class ~=13 then		-- We don't want planes, helicopters, bicycles and trains
				if self.fueling then
					DrawText3Ds(px,py,pz + 1.2, "Press ~g~E ~w~to cancel the fueling")
					if GetDistanceBetweenCoords(x,y,z, px,py,pz) > 1.5 
					or (IsControlJustReleased(0, 38)) 
					or self.currentFuel > 100 then
						self.fueling = false
						StopAnimTask(ped, "timetable@gardener@filling_can", "gar_ig_5_filling_can", 2.0)
					end
				else
					if GetDistanceBetweenCoords(x,y,z, px,py,pz) <= 5.0 then -- distance between you and pumpf
						if IsPedInAnyVehicle(ped) and GetPedInVehicleSeat(GetVehiclePedIsIn(ped), -1) == ped then
							DrawText3Ds(px,py,pz + 1.2, "Exit the vehicle to refuel")
						else
							if DoesEntityExist(vehicle) and GetDistanceBetweenCoords(x,y,z,vx,vy,vz) < 2.5 then		--check if by vehicle
								if not DoesEntityExist(GetPedInVehicleSeat(vehicle, -1)) then	-- checks if in driver seat
									if GetVehicleFuelLevel(vehicle) < 95 then
										if not self.inBlacklisted then
											DrawText3Ds(px,py,pz + 1.2, "Press ~g~E ~w~to refuel vehicle")
											if(IsControlJustReleased(0, 38))then
												if self.currentCash > 0 then
													self.fueling = true
													self:refuelFromPump(self.isNearPump, ped, vehicle)
												else
													DrawText3Ds(px,py,pz + 1.2, "Not enough cash")
												end
											end
										else
											DrawText3Ds(px,py,pz + 1.2, "Unable to fuel vehicle")
										end
									else
										DrawText3Ds(px,py,pz + 1.2, "Tank is full")
									end
								end
							end
						end
					end
				end
			end
		end
	end)
	
	-- force stops animation if not fueling
	Citizen.CreateThread(function()
		while not self.fueling do
			Citizen.Wait(0)
			StopAnimTask(GetPlayerPed(-1), "timetable@gardener@filling_can", "gar_ig_5_filling_can", 2.0)
		end
	end)
end

-- special functions
function Fuel:ManageFuelUsage(vehicle)
	local ped = GetPlayerPed(-1)
	local vehicle = GetVehiclePedIsIn(ped)
	local fuel = GetVehicleFuelLevel(vehicle)

	if fuel > 0 and GetIsVehicleEngineRunning(vehicle) then
		local rpm = math.pow(GetVehicleCurrentRpm(vehicle), 1.5)
		
		local consumedFuel = 0.0
		
		consumedFuel = consumedFuel + GetVehicleCurrentRpm(vehicle) * cfg.impact.rpm
		consumedFuel = consumedFuel + GetVehicleAcceleration(vehicle) * cfg.impact.acceleration
		consumedFuel = consumedFuel + GetVehicleMaxTraction(vehicle) * cfg.impact.traction
		
		fuel = fuel - consumedFuel * cfg.impact.cunsumption * (cfg.classes[GetVehicleClass(vehicle)] or 1.0) * GetVehicleCurrentGear(vehicle)
		SetVehicleFuelLevel(vehicle, fuel + 0.0)
	end
end

function Fuel:refuelFromPump(pumpObject, ped, vehicle)
	TaskTurnPedToFaceEntity(ped, vehicle, 1000)
	SetCurrentPedWeapon(ped, -1569615261, true)
	LoadAnimDict("timetable@gardener@filling_can")
	TaskPlayAnim(ped, "timetable@gardener@filling_can", "gar_ig_5_filling_can", 2.0, 8.0, -1, 50, 0, 0, 0, 0)
	self.currentFuel = GetVehicleFuelLevel(vehicle)
	
	Citizen.CreateThread(function()
		while self.fueling do
			Citizen.Wait(0)
			local vx,vy,vz = table.unpack(GetEntityCoords(vehicle))
			for _, v in pairs(self.keys) do
				DisableControlAction(0, v)
			end
	
			DrawText3Ds(vx,vy,vz + 1.2, "\n Cost : ~g~$"..Round(self.currentCost, 1).."0")
			DrawText3Ds(vx,vy,vz + 0.5, Round(self.currentFuel, 1) .. "%")
		end
	end)
	
	Citizen.CreateThread(function()
		while self.fueling do
			Citizen.Wait(500)
			local new = math.random(10, 20) / 10
			local extraCost = new / 1.5 * cfg.multiplier
			
			self.currentFuel = self.currentFuel + new
				
			if self.currentFuel >= 100.0 then
				self.currentFuel = 100.0
				self.fueling = false
				StopAnimTask(GetPlayerPed(-1), "timetable@gardener@filling_can", "gar_ig_5_filling_can", 2.0)
			end
			
			self.currentCost = self.currentCost + extraCost
			
			if self.currentCash >= self.currentCost then
				SetVehicleFuelLevel(vehicle, self.currentFuel + 0.0)
			else
				self.fueling = false
			end

			if not self.fueling then
				self.remote._pay(Round(self.currentCost, 1))
			end
		end
	end)
end

--notification function
function notification(msg)		
	SetNotificationTextEntry("STRING")
	AddTextComponentString(msg)
	DrawNotification(false, false)
end

-- draw prop/vehicle text
function DrawText3Ds(x, y, z, text)
	local onScreen,_x,_y=World3dToScreen2d(x,y,z)

	if onScreen then
		SetTextScale(0.35, 0.35)
		SetTextFont(4)
		SetTextProportional(1)
		SetTextColour(255, 255, 255, 255)
		SetTextEntry("STRING")
		SetTextCentre(1)
		AddTextComponentString(text)
		DrawText(_x,_y)
	end
end

-- draw speedometer text
function DrawAdvancedText(x,y ,w,h,sc, text, r,g,b,a,font,jus)
	SetTextFont(font)
	SetTextProportional(0)
	SetTextScale(sc, sc)
	N_0x4e096588b13ffeca(jus)
	SetTextColour(r, g, b, a)
	SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(1, 0, 0, 0, 255)
	SetTextOutline()
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x - 0.1+w, y - 0.02+h)
end
	
-- rounds value variable with passed decimal value passed
function Round(num, numDecimalPlaces)
	local mult = 10^(numDecimalPlaces or 0)

	return math.floor(num * mult + 0.5) / mult
end

--animation handler
function LoadAnimDict(dict)
	if not HasAnimDictLoaded(dict) then
		RequestAnimDict(dict)

		while not HasAnimDictLoaded(dict) do
			Citizen.Wait(1)
		end
	end
end

-- gets Pumps funtions
--get closest pump
function Fuel:getNearestPump(radius)
	local p = nil
	
	local ai = self:getNearestPumps(radius)
	local min = radius+10.0
	for k,v in pairs(ai) do
		if v < min then
		  min = v
		  p = k
		end
	end
	
	return p
end

--get all pump objects within radius
function Fuel:getNearestPumps(radius)
	if not radius then radius = 5 end
	local r = {}
	local px,py,pz = table.unpack(GetEntityCoords(GetPlayerPed(-1)))
	
	for hash in pairs(cfg.pumps) do
		for _, pump in pairs(GetGamePool('CObject')) do
			if DoesEntityExist(pump) and GetEntityModel(pump) == hash then
				local x,y,z = table.unpack(GetEntityCoords(pump))
				local dist = GetDistanceBetweenCoords(x,y,z,px,py,pz,true)
				if dist <= radius then
					r[pump] = dist
				end
			end
		end
	end
	
	return r
end

function Fuel:balance(balance)
	self.currentCash = balance
end

-- resets current cost after paying
function Fuel:paid()
	self.currentCost = 0
end

Fuel.tunnel.balance 			= Fuel.balance
Fuel.tunnel.paid 				= Fuel.paid

vRP:registerExtension(Fuel)