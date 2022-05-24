local lang = vRP.lang
local Luang = module("vrp", "lib/Luang")

local Fuel = class("Fuel", vRP.Extension)

Fuel.event = {}
Fuel.tunnel = {}

function Fuel:__construct()
	vRP.Extension.__construct(self)
	
	self.cfg = module("vrp_fuel", "cfg/cfg")
end

function Fuel.event:playerSpawn(user, first_spawn)
	if first_spawn then
		for k,v in pairs(self.cfg.gas_station) do
			local name,gtype,x,y,z = table.unpack(v)
			
			local ment = clone(self.cfg.marker.Station)
			ment[2].title = "Gas Station"
			ment[2].pos = {x,y,z-1}
			vRP.EXT.Map.remote._addEntity(user.source, ment[1], ment[2])

			user:setArea("vRP:Gas:"..k,x,y,z,1,1.5,enter,leave)
		end
	end
end

function Round(num, numDecimalPlaces)
	local mult = 10^(numDecimalPlaces or 0)

	return math.floor(num * mult + 0.5) / mult
end

function Fuel.event:pay(price)
	for id, user in pairs(vRP.users) do
		local bank = user:getBank()
		local wallet = user:getWallet()
		if price and price > 0 then
			if self.cfg.wallet then
				user_wallet = wallet - price
				user:setWallet(user_wallet)
				vRP.EXT.Base.remote._notify(user.source, "Wallet: You paid $"..price.."0")
				self.remote._paid(source)
			else
				user_bank = bank - price
				user:setBank(user_bank)
				vRP.EXT.Base.remote._notify(user.source, "Bank: You paid $"..price.."0")
				self.remote._paid(source)
			end
		else
			vRP.EXT.Base.remote._notify(user.source, "No value")
		end
	end
end

function Fuel.event:balance()
	for _, user in pairs(vRP.users) do
		local bank = user:getBank()
		local wallet = user:getWallet()
		
		if self.cfg.wallet then			-- if using only wallet then
			money = user:getWallet()
		else
			money = user:getBank()
		end
		self.remote._balance(source, money)
	end
end

function Fuel.tunnel:pay(price)
	for _, user in pairs(vRP.users) do
		if self.cfg.pay then
			vRP:triggerEvent("pay", price)
		else
			vRP.EXT.Base.remote._notify(user.source, "In development: $"..price.."0")
			self.remote._paid(source)
		end
	end
end

function Fuel.tunnel:test()
	if self.cfg.pay then
		vRP:triggerEvent("balance")
	else
		money = 5000
		self.remote._balance(source, money)
	end
end

vRP:registerExtension(Fuel)